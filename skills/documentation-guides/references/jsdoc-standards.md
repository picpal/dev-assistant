# JSDoc/TSDoc Standards

## Function Documentation

```typescript
/**
 * Creates a new user account.
 *
 * @param name - Full name of the user
 * @param email - Email address (must be unique)
 * @param age - User age (optional)
 * @returns The created user object
 * @throws {ValidationError} If email format is invalid
 * @throws {DuplicateEmailError} If email already exists
 *
 * @example
 * ```ts
 * const user = createUser("John Doe", "john@example.com", 30);
 * console.log(user.id); // 1
 * ```
 */
function createUser(name: string, email: string, age?: number): User {
    // ...
}
```

## Interface Documentation

```typescript
/**
 * User account representation.
 *
 * @property id - Unique user identifier
 * @property name - Full name
 * @property email - Email address
 */
interface User {
    id: number;
    name: string;
    email: string;
}
```

## React Component Documentation

```typescript
/**
 * User profile display component.
 *
 * Shows user information with edit capability.
 *
 * @param props - Component props
 * @param props.user - User object to display
 * @param props.onSave - Callback when user is saved
 * @returns User profile component
 */
export function UserProfile({
    user,
    onSave
}: {
    user: User;
    onSave: (user: User) => void;
}): JSX.Element {
    // ...
}
```

## Common Tags

- `@param`: Parameter description
- `@returns`: Return value
- `@throws`: Exception thrown
- `@example`: Usage example
- `@deprecated`: Deprecated function
- `@see`: Related items
