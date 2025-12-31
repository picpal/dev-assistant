# JUnit 5 Testing Patterns

## Basic Test Structure (AAA Pattern)

```java
@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private UserService userService;

    @Test
    @DisplayName("Should return user when user exists")
    void shouldReturnUserWhenUserExists() {
        // Arrange
        Long userId = 1L;
        User expected = new User(userId, "John", "john@example.com");
        when(userRepository.findById(userId)).thenReturn(Optional.of(expected));

        // Act
        User actual = userService.getUserById(userId);

        // Assert
        assertThat(actual)
            .isNotNull()
            .extracting(User::getId, User::getName)
            .containsExactly(userId, "John");

        verify(userRepository).findById(userId);
    }
}
```

## Parameterized Tests

```java
@ParameterizedTest
@ValueSource(strings = {"", " ", "  ", "\t", "\n"})
void shouldRejectBlankEmail(String email) {
    assertThatThrownBy(() -> userService.createUser("John", email))
        .isInstanceOf(IllegalArgumentException.class);
}

@ParameterizedTest
@CsvSource({
    "10, 0.1, 11.0",
    "20, 0.2, 24.0",
    "100, 0.15, 115.0"
})
void shouldCalculateTotalWithTax(double amount, double taxRate, double expected) {
    double result = calculator.calculateTotal(amount, taxRate);
    assertThat(result).isEqualTo(expected);
}
```

## Spring Boot Integration Tests

```java
@SpringBootTest
@AutoConfigureMockMvc
class UserControllerIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    void shouldCreateUser() throws Exception {
        UserRequest request = new UserRequest("John", "john@example.com");

        mockMvc.perform(post("/api/users")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.name").value("John"));
    }
}
```

## Repository Tests

```java
@DataJpaTest
class UserRepositoryTest {

    @Autowired
    private UserRepository userRepository;

    @Test
    void shouldFindUserByEmail() {
        User user = new User(null, "John", "john@example.com");
        userRepository.save(user);

        Optional<User> found = userRepository.findByEmail("john@example.com");

        assertThat(found)
            .isPresent()
            .get()
            .extracting(User::getName)
            .isEqualTo("John");
    }
}
```
