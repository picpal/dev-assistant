# JavaDoc Standards

## Class Documentation

```java
/**
 * Service for managing user accounts.
 * <p>
 * Handles user creation, updates, and authentication.
 * Uses bcrypt for password hashing.
 *
 * @author Team Name
 * @since 1.0
 */
@Service
public class UserService {
    // ...
}
```

## Method Documentation

```java
/**
 * Creates a new user account.
 *
 * @param request the user creation request containing name and email
 * @return the created user with generated ID
 * @throws IllegalArgumentException if email is invalid
 * @throws DuplicateEmailException if email already exists
 */
public User createUser(UserRequest request) {
    // ...
}
```

## Field Documentation

```java
/**
 * Maximum number of login attempts before account lockout.
 */
private static final int MAX_LOGIN_ATTEMPTS = 5;
```

## Common Tags

- `@param`: Parameter description
- `@return`: Return value description
- `@throws`: Exception that might be thrown
- `@see`: Reference to related class/method
- `@deprecated`: Marks deprecated code
- `@since`: Version when added
