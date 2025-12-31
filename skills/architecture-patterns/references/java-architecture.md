# Java/Spring Boot Architecture Patterns

## Layered Architecture (Standard Spring Boot Pattern)

### Structure
```
src/main/java/com/company/domain/
├── controller/          # Presentation Layer
│   ├── UserController.java
│   └── dto/
│       ├── CreateUserRequest.java
│       └── UserResponse.java
├── service/             # Business Layer
│   ├── UserService.java
│   └── impl/
│       └── UserServiceImpl.java
├── repository/          # Data Access Layer
│   └── UserRepository.java
├── entity/              # Domain Model
│   └── User.java
├── exception/           # Custom Exceptions
│   └── UserNotFoundException.java
└── config/              # Configuration
    └── SecurityConfig.java
```

### Minimal Approach
```java
// All in controller, minimal abstraction
@RestController
@RequestMapping("/api/users")
public class UserController {
    @Autowired
    private UserRepository userRepository;

    @PostMapping
    public User create(@RequestBody User user) {
        return userRepository.save(user);
    }
}
```

### Clean Approach
```java
// Full layering with DTOs, service, repository

// Controller
@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;

    @PostMapping
    public ResponseEntity<UserResponse> create(@Valid @RequestBody CreateUserRequest request) {
        UserResponse response = userService.createUser(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }
}

// Service Interface
public interface UserService {
    UserResponse createUser(CreateUserRequest request);
}

// Service Implementation
@Service
@RequiredArgsConstructor
@Transactional
public class UserServiceImpl implements UserService {
    private final UserRepository userRepository;
    private final UserMapper userMapper;

    @Override
    public UserResponse createUser(CreateUserRequest request) {
        User user = userMapper.toEntity(request);
        User saved = userRepository.save(user);
        return userMapper.toResponse(saved);
    }
}

// Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);
}

// DTOs
@Data
public class CreateUserRequest {
    @NotBlank
    @Email
    private String email;

    @NotBlank
    @Size(min = 8)
    private String password;
}

@Data
public class UserResponse {
    private Long id;
    private String email;
    private LocalDateTime createdAt;

    public static UserResponse from(User user) {
        // mapping logic
    }
}
```

### Pragmatic Approach
```java
// Controller
@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;

    @PostMapping
    public UserResponse create(@Valid @RequestBody CreateUserRequest request) {
        return userService.createUser(request);
    }
}

// Service (no interface, direct implementation)
@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepository;

    public UserResponse createUser(CreateUserRequest request) {
        User user = new User(request.getEmail(), request.getPassword());
        user = userRepository.save(user);
        return UserResponse.from(user);
    }
}

// Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);
}
```

## Hexagonal Architecture (Ports & Adapters)

**When to Use**: Complex business logic, multiple integrations, high testability requirements

```
com/company/domain/
├── application/         # Application Services (Use Cases)
│   ├── port/
│   │   ├── in/         # Inbound Ports (driven by external actors)
│   │   │   └── CreateUserUseCase.java
│   │   └── out/        # Outbound Ports (to external systems)
│   │       └── UserPersistencePort.java
│   └── service/
│       └── UserApplicationService.java
├── domain/             # Pure Business Logic
│   ├── model/
│   │   └── User.java
│   └── exception/
│       └── InvalidUserException.java
└── adapter/            # Adapters
    ├── in/             # Inbound Adapters
    │   └── rest/
    │       └── UserController.java
    └── out/            # Outbound Adapters
        └── persistence/
            └── UserJpaAdapter.java
```

## Dependency Injection Best Practices

### Constructor Injection (Recommended)
```java
@Service
@RequiredArgsConstructor  // Lombok generates constructor
public class UserService {
    private final UserRepository userRepository;
    private final EmailService emailService;
}

// Or without Lombok
@Service
public class UserService {
    private final UserRepository userRepository;
    private final EmailService emailService;

    public UserService(UserRepository userRepository, EmailService emailService) {
        this.userRepository = userRepository;
        this.emailService = emailService;
    }
}
```

### Field Injection (Discouraged)
```java
@Service
public class UserService {
    @Autowired  // Avoid this
    private UserRepository userRepository;
}
```

## Exception Handling Architecture

### Minimal
```java
@RestController
public class UserController {
    @PostMapping("/users")
    public User create(@RequestBody User user) {
        try {
            return userService.create(user);
        } catch (Exception e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
        }
    }
}
```

### Clean
```java
// Custom Exception
public class UserNotFoundException extends RuntimeException {
    public UserNotFoundException(Long id) {
        super("User not found with id: " + id);
    }
}

// Global Exception Handler
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(UserNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleUserNotFound(UserNotFoundException ex) {
        ErrorResponse error = ErrorResponse.builder()
            .status(HttpStatus.NOT_FOUND.value())
            .message(ex.getMessage())
            .timestamp(LocalDateTime.now())
            .build();
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidation(MethodArgumentNotValidException ex) {
        Map<String, String> errors = ex.getBindingResult().getFieldErrors().stream()
            .collect(Collectors.toMap(
                FieldError::getField,
                FieldError::getDefaultMessage
            ));
        ErrorResponse error = ErrorResponse.builder()
            .status(HttpStatus.BAD_REQUEST.value())
            .message("Validation failed")
            .errors(errors)
            .timestamp(LocalDateTime.now())
            .build();
        return ResponseEntity.badRequest().body(error);
    }
}

// Error Response DTO
@Data
@Builder
public class ErrorResponse {
    private int status;
    private String message;
    private Map<String, String> errors;
    private LocalDateTime timestamp;
}
```

## Testing Architecture

### Minimal
```java
@SpringBootTest
class UserServiceTest {
    @Autowired
    private UserService userService;

    @Test
    void createUser() {
        User user = userService.createUser(new CreateUserRequest("test@example.com", "password"));
        assertNotNull(user.getId());
    }
}
```

### Clean
```java
// Unit Test (Service)
@ExtendWith(MockitoExtension.class)
class UserServiceTest {
    @Mock
    private UserRepository userRepository;

    @Mock
    private UserMapper userMapper;

    @InjectMocks
    private UserServiceImpl userService;

    @Test
    void createUser_Success() {
        // Arrange
        CreateUserRequest request = new CreateUserRequest("test@example.com", "password");
        User user = new User(1L, "test@example.com");
        UserResponse expected = new UserResponse(1L, "test@example.com");

        when(userMapper.toEntity(request)).thenReturn(user);
        when(userRepository.save(user)).thenReturn(user);
        when(userMapper.toResponse(user)).thenReturn(expected);

        // Act
        UserResponse actual = userService.createUser(request);

        // Assert
        assertEquals(expected, actual);
        verify(userRepository).save(user);
    }
}

// Integration Test (Controller)
@SpringBootTest
@AutoConfigureMockMvc
class UserControllerIntegrationTest {
    @Autowired
    private MockMvc mockMvc;

    @Test
    void createUser_Success() throws Exception {
        String requestBody = """
            {
                "email": "test@example.com",
                "password": "password123"
            }
            """;

        mockMvc.perform(post("/api/users")
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestBody))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.id").exists())
            .andExpect(jsonPath("$.email").value("test@example.com"));
    }
}
```

## Package Organization Strategies

### By Layer (Feature-Light)
```
com.company.myapp/
├── controller/
├── service/
├── repository/
└── entity/
```
**Use when**: Simple applications, few domains

### By Feature (Feature-Heavy)
```
com.company.myapp/
├── user/
│   ├── UserController.java
│   ├── UserService.java
│   ├── UserRepository.java
│   └── User.java
├── order/
│   ├── OrderController.java
│   ├── OrderService.java
│   ├── OrderRepository.java
│   └── Order.java
```
**Use when**: Multiple domains, clear boundaries

### Hybrid (Recommended for most cases)
```
com.company.myapp/
├── user/
│   ├── controller/
│   ├── service/
│   ├── repository/
│   └── entity/
├── order/
│   ├── controller/
│   ├── service/
│   ├── repository/
│   └── entity/
└── common/
    ├── config/
    ├── exception/
    └── util/
```

## Configuration Management

### application.yml Structure
```yaml
spring:
  application:
    name: myapp
  datasource:
    url: jdbc:postgresql://localhost:5432/mydb
    username: ${DB_USERNAME}
    password: ${DB_PASSWORD}
  jpa:
    hibernate:
      ddl-auto: validate
    show-sql: false

# Custom properties
app:
  security:
    jwt:
      secret: ${JWT_SECRET}
      expiration: 86400000
  email:
    from: noreply@example.com
```

### Configuration Properties Class
```java
@ConfigurationProperties(prefix = "app.security.jwt")
@Validated
@Data
public class JwtProperties {
    @NotBlank
    private String secret;

    @Min(1000)
    private long expiration;
}

// Enable in main class or config
@EnableConfigurationProperties(JwtProperties.class)
```

## Trade-offs Summary

| Aspect | Minimal | Pragmatic | Clean |
|--------|---------|-----------|-------|
| Files Created | 2-3 | 4-6 | 8-12 |
| Abstraction Layers | 1-2 | 2-3 | 3-4 |
| DTOs | Reuse entities | Selected DTOs | Full DTOs |
| Service Interface | No | Optional | Yes |
| Exception Handling | Basic try-catch | @RestControllerAdvice | Custom exceptions + handler |
| Testing | Integration only | Critical unit + integration | Full unit + integration + contract |
| Time to Implement | Hours | 1-2 days | 2-4 days |
| Maintainability | Low | Medium | High |
