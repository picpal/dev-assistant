# Design Patterns Catalog

Multi-language implementation guide for common design patterns.

## Enterprise Patterns

### Repository Pattern

**Purpose**: Abstract data access logic from business logic

**Java/Spring Boot:**
```java
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);
    List<User> findByAgeGreaterThan(int age);
}

// Usage in Service
@Service
public class UserService {
    private final UserRepository userRepository;

    public User findByEmail(String email) {
        return userRepository.findByEmail(email)
            .orElseThrow(() -> new UserNotFoundException(email));
    }
}
```

**Python:**
```python
class UserRepository:
    def __init__(self, db: Session):
        self.db = db

    def find_by_email(self, email: str) -> User | None:
        return self.db.query(User).filter(User.email == email).first()

    def create(self, user_data: dict) -> User:
        user = User(**user_data)
        self.db.add(user)
        self.db.commit()
        return user
```

### Service Layer Pattern

**Purpose**: Encapsulate business logic, coordinate between controllers and repositories

**Implementation**: See architecture reference files for each language

### DTO (Data Transfer Object)

**Purpose**: Transfer data between layers, decouple internal models from API contracts

**Java:**
```java
@Data
public class UserResponse {
    private Long id;
    private String name;
    private String email;

    public static UserResponse from(User user) {
        UserResponse dto = new UserResponse();
        dto.setId(user.getId());
        dto.setName(user.getName());
        dto.setEmail(user.getEmail());
        return dto;
    }
}
```

**Python (Pydantic):**
```python
class UserResponse(BaseModel):
    id: int
    name: str
    email: str

    class Config:
        from_attributes = True  # Enable from ORM
```

**TypeScript:**
```typescript
interface UserResponse {
  id: number;
  name: string;
  email: string;
}

function toUserResponse(user: User): UserResponse {
  return {
    id: user.id,
    name: user.name,
    email: user.email,
  };
}
```

## Creational Patterns

### Factory Pattern

**Purpose**: Create objects without specifying exact class

**Java:**
```java
public interface NotificationService {
    void send(String message);
}

public class EmailNotificationService implements NotificationService {
    public void send(String message) { /* email logic */ }
}

public class SmsNotificationService implements NotificationService {
    public void send(String message) { /* sms logic */ }
}

@Component
public class NotificationServiceFactory {
    public NotificationService create(NotificationType type) {
        return switch (type) {
            case EMAIL -> new EmailNotificationService();
            case SMS -> new SmsNotificationService();
            default -> throw new IllegalArgumentException("Unknown type");
        };
    }
}
```

**Python:**
```python
def create_notification_service(service_type: str):
    if service_type == "email":
        return EmailNotificationService()
    elif service_type == "sms":
        return SmsNotificationService()
    else:
        raise ValueError(f"Unknown service type: {service_type}")
```

### Builder Pattern

**Purpose**: Construct complex objects step by step

**Java:**
```java
@Builder
public class User {
    private String name;
    private String email;
    private int age;
    private String address;
}

// Usage
User user = User.builder()
    .name("John")
    .email("john@example.com")
    .age(30)
    .build();
```

**TypeScript:**
```typescript
class UserBuilder {
  private user: Partial<User> = {};

  withName(name: string): this {
    this.user.name = name;
    return this;
  }

  withEmail(email: string): this {
    this.user.email = email;
    return this;
  }

  build(): User {
    if (!this.user.name || !this.user.email) {
      throw new Error('Missing required fields');
    }
    return this.user as User;
  }
}

// Usage
const user = new UserBuilder()
  .withName('John')
  .withEmail('john@example.com')
  .build();
```

### Singleton Pattern

**Purpose**: Ensure only one instance exists

**Java (Spring):**
```java
@Service  // Spring beans are singletons by default
public class ConfigurationService {
    // Only one instance per Spring container
}
```

**Python:**
```python
class DatabaseConnection:
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance._initialize()
        return cls._instance

    def _initialize(self):
        self.connection = create_connection()
```

**TypeScript:**
```typescript
class Logger {
  private static instance: Logger;
  private constructor() {}

  static getInstance(): Logger {
    if (!Logger.instance) {
      Logger.instance = new Logger();
    }
    return Logger.instance;
  }
}

const logger = Logger.getInstance();
```

## Structural Patterns

### Adapter Pattern

**Purpose**: Convert interface of a class into another interface

**Java:**
```java
// Legacy interface
public interface OldPaymentGateway {
    void processPayment(double amount);
}

// New interface
public interface PaymentService {
    void pay(Money amount);
}

// Adapter
public class PaymentGatewayAdapter implements PaymentService {
    private final OldPaymentGateway gateway;

    public void pay(Money amount) {
        gateway.processPayment(amount.toDouble());
    }
}
```

### Decorator Pattern

**Purpose**: Add behavior to objects dynamically

**Python:**
```python
# Function decorator
def log_execution(func):
    def wrapper(*args, **kwargs):
        print(f"Executing {func.__name__}")
        result = func(*args, **kwargs)
        print(f"Finished {func.__name__}")
        return result
    return wrapper

@log_execution
def process_user(user_id: int):
    # process logic
    pass
```

**TypeScript:**
```typescript
// Method decorator
function Log(target: any, propertyKey: string, descriptor: PropertyDescriptor) {
  const original = descriptor.value;

  descriptor.value = function(...args: any[]) {
    console.log(`Calling ${propertyKey} with`, args);
    const result = original.apply(this, args);
    console.log(`Result:`, result);
    return result;
  };
}

class UserService {
  @Log
  getUser(id: number): User {
    // implementation
  }
}
```

## Behavioral Patterns

### Strategy Pattern

**Purpose**: Define family of algorithms, make them interchangeable

**Java:**
```java
public interface PaymentStrategy {
    void pay(double amount);
}

public class CreditCardPayment implements PaymentStrategy {
    public void pay(double amount) { /* credit card logic */ }
}

public class PayPalPayment implements PaymentStrategy {
    public void pay(double amount) { /* paypal logic */ }
}

public class PaymentProcessor {
    private PaymentStrategy strategy;

    public void setStrategy(PaymentStrategy strategy) {
        this.strategy = strategy;
    }

    public void processPayment(double amount) {
        strategy.pay(amount);
    }
}
```

**Python:**
```python
from typing import Protocol

class PaymentStrategy(Protocol):
    def pay(self, amount: float) -> None:
        ...

class CreditCardPayment:
    def pay(self, amount: float):
        print(f"Paying {amount} with credit card")

class PayPalPayment:
    def pay(self, amount: float):
        print(f"Paying {amount} with PayPal")

class PaymentProcessor:
    def __init__(self, strategy: PaymentStrategy):
        self.strategy = strategy

    def process(self, amount: float):
        self.strategy.pay(amount)
```

### Observer Pattern

**Purpose**: Define one-to-many dependency between objects

**React (built-in with hooks):**
```typescript
// Context acts as observable
const UserContext = createContext<User | null>(null);

// Observers subscribe via useContext
function UserProfile() {
  const user = useContext(UserContext);  // Observer
  return <div>{user?.name}</div>;
}
```

**Java (Spring Events):**
```java
// Event
public class UserCreatedEvent {
    private final User user;
}

// Publisher
@Service
public class UserService {
    @Autowired
    private ApplicationEventPublisher publisher;

    public User createUser(User user) {
        User saved = repository.save(user);
        publisher.publishEvent(new UserCreatedEvent(saved));
        return saved;
    }
}

// Observer
@Component
public class UserEventListener {
    @EventListener
    public void onUserCreated(UserCreatedEvent event) {
        // Send welcome email
    }
}
```

## React-Specific Patterns

### Custom Hook Pattern

**Purpose**: Reuse stateful logic across components

```typescript
function useLocalStorage<T>(key: string, initialValue: T) {
  const [value, setValue] = useState<T>(() => {
    const stored = localStorage.getItem(key);
    return stored ? JSON.parse(stored) : initialValue;
  });

  useEffect(() => {
    localStorage.setItem(key, JSON.stringify(value));
  }, [key, value]);

  return [value, setValue] as const;
}

// Usage
function UserPreferences() {
  const [theme, setTheme] = useLocalStorage('theme', 'light');
  return <button onClick={() => setTheme('dark')}>Switch</button>;
}
```

### Render Props Pattern

```typescript
interface RenderPropsComponentProps {
  render: (data: User[]) => ReactNode;
}

function UserDataProvider({ render }: RenderPropsComponentProps) {
  const [users, setUsers] = useState<User[]>([]);

  useEffect(() => {
    fetchUsers().then(setUsers);
  }, []);

  return <>{render(users)}</>;
}

// Usage
<UserDataProvider
  render={(users) => <UserList users={users} />}
/>
```

## When to Use Which Pattern

| Pattern | Use When | Avoid When |
|---------|----------|------------|
| Repository | Data access abstraction needed | Direct ORM usage is simple enough |
| Service Layer | Business logic is complex | Logic is trivial CRUD |
| DTO | API contract differs from domain | Internal-only usage |
| Factory | Multiple implementations exist | Only one implementation |
| Builder | Complex object construction | Simple objects |
| Singleton | Truly global state needed | Can use DI instead |
| Strategy | Multiple algorithms, runtime selection | Only one algorithm |
| Observer | Event-driven architecture | Direct method calls suffice |
