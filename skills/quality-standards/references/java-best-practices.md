# Java/Spring Boot Best Practices

## Dependency Injection

**Prefer Constructor Injection**:
```java
// Good
@Service
public class UserService {
    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }
}

// Avoid field injection
@Autowired
private UserRepository userRepository;  // Harder to test
```

## Use Optional for Null Safety

```java
// Good
public Optional<User> findUser(Long id) {
    return userRepository.findById(id);
}

// Usage
userService.findUser(id)
    .ifPresent(user -> process(user));

// Avoid returning null
public User findUser(Long id) {
    return null;  // Leads to NPE
}
```

## Immutability

```java
// Good: Immutable
@Value
public class User {
    Long id;
    String name;
    String email;
}

// Or with builder
@Builder
public class User {
    private final Long id;
    private final String name;
    private final String email;
}
```

## Exception Handling

```java
// Good: Specific exceptions
public void processPayment(Payment payment) {
    if (payment.getAmount() <= 0) {
        throw new IllegalArgumentException("Amount must be positive");
    }
}

// Avoid empty catch
try {
    riskyOperation();
} catch (Exception e) {
    // Never do this
}
```

## SOLID Principles

**Single Responsibility**:
```java
// Good: Each class has one responsibility
@RestController
public class UserController { /* HTTP only */ }

@Service
public class UserService { /* Business logic */ }

@Repository
public interface UserRepository { /* Data access */ }
```
