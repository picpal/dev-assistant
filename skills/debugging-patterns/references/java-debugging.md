# Java/Spring Boot Debugging Guide

## Common Exception Types

### NullPointerException

**Cause**: Attempting to use a null reference

**Common Scenarios**:
```java
// 1. Null return from repository
User user = userRepository.findById(id);  // Returns null, not Optional
user.getName();  // NPE!

// Fix: Use Optional
Optional<User> userOpt = userRepository.findById(id);
User user = userOpt.orElseThrow(() -> new UserNotFoundException(id));

// 2. Uninitialized field
public class UserService {
    private UserRepository userRepo;  // null! Missing @Autowired

    public void doSomething() {
        userRepo.findAll();  // NPE
    }
}

// Fix: Add @Autowired or use constructor injection
@Autowired
private UserRepository userRepo;

// Better: Constructor injection
public UserService(UserRepository userRepo) {
    this.userRepo = userRepo;
}

// 3. Null check missing
String email = user.getEmail();  // email might be null
if (email.contains("@")) { }  // NPE if email is null

// Fix: Check for null
if (email != null && email.contains("@")) { }
```

### ClassNotFoundException / NoClassDefFoundError

**ClassNotFoundException**: Class not found at runtime (CLASSPATH issue)
**NoClassDefFoundError**: Class was present during compilation but missing at runtime

**Solutions**:
```groovy
// Check dependencies in build.gradle
dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-data-jpa'
    // Make sure version is correct and dependency is present
}

// Clean and rebuild
./gradlew clean build
```

### IllegalStateException

**Common in Spring Boot**:
```java
// Cause: Accessing Hibernate entity outside of session
@Entity
public class User {
    @OneToMany(fetch = FetchType.LAZY)
    private List<Order> orders;
}

User user = userRepository.findById(id);
// ... session closed ...
user.getOrders().size();  // IllegalStateException: no session

// Fix: Use @Transactional
@Transactional
public UserDTO getUserWithOrders(Long id) {
    User user = userRepository.findById(id).orElseThrow();
    // Access lazy-loaded fields within transaction
    return new UserDTO(user, user.getOrders());
}
```

### ConcurrentModificationException

**Cause**: Modifying collection while iterating

**Example**:
```java
List<String> items = new ArrayList<>(Arrays.asList("a", "b", "c"));

// Wrong: Modifying while iterating
for (String item : items) {
    if (item.equals("b")) {
        items.remove(item);  // ConcurrentModificationException!
    }
}

// Fix 1: Use Iterator
Iterator<String> it = items.iterator();
while (it.hasNext()) {
    if (it.next().equals("b")) {
        it.remove();  // Safe
    }
}

// Fix 2: Use removeIf (Java 8+)
items.removeIf(item -> item.equals("b"));

// Fix 3: Collect to new list
List<String> filtered = items.stream()
    .filter(item -> !item.equals("b"))
    .collect(Collectors.toList());
```

## Spring Boot Specific Issues

### Bean Not Found / Circular Dependency

**Bean Not Found**:
```java
// Problem: Component not scanned
package com.example.service;  // Outside @SpringBootApplication package

@Service
public class UserService { }

// Fix: Add @ComponentScan
@SpringBootApplication
@ComponentScan(basePackages = {"com.example", "com.other"})
public class Application { }
```

**Circular Dependency**:
```java
// Problem: A depends on B, B depends on A
@Service
public class ServiceA {
    @Autowired
    private ServiceB serviceB;
}

@Service
public class ServiceB {
    @Autowired
    private ServiceA serviceA;  // Circular!
}

// Fix 1: Use @Lazy
@Service
public class ServiceA {
    @Autowired
    @Lazy
    private ServiceB serviceB;
}

// Fix 2: Refactor to remove circular dependency (better)
// Extract common logic to ServiceC
```

### Database Connection Issues

**Connection Pool Exhausted**:
```yaml
# Increase pool size in application.yml
spring:
  datasource:
    hikari:
      maximum-pool-size: 20
      connection-timeout: 30000
      leak-detection-threshold: 60000  # Detect leaks
```

**N+1 Query Problem**:
```java
// Problem: Fetching in loop
List<User> users = userRepository.findAll();  // 1 query
for (User user : users) {
    List<Order> orders = user.getOrders();  // N queries
    // ...
}

// Fix: Use JOIN FETCH or @EntityGraph
@Query("SELECT u FROM User u JOIN FETCH u.orders")
List<User> findAllWithOrders();

// Or @EntityGraph
@EntityGraph(attributePaths = {"orders"})
List<User> findAll();
```

### Configuration Issues

**Missing Property**:
```
Description:
Binding to target org.springframework.boot.context.properties.bind.BindException:
Failed to bind properties under 'spring.datasource.url' to java.lang.String

// Fix: Add property to application.yml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/mydb
    username: user
    password: password
```

## JVM Debugging Techniques

### Using JVM Flags for Debugging

```bash
# Enable remote debugging
java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 -jar app.jar

# Enable assertions
java -ea -jar app.jar

# Verbose class loading
java -verbose:class -jar app.jar

# GC logging
java -Xlog:gc*:file=gc.log -jar app.jar

# Heap dump on OutOfMemoryError
java -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/tmp/heapdump.hprof -jar app.jar
```

### Memory Leak Detection

```bash
# Generate heap dump
jmap -dump:format=b,file=heap.bin <pid>

# Analyze with jhat (deprecated) or Eclipse MAT
# Look for:
# - Objects with high retained size
# - Growing collections
# - Listeners not unregistered
# - Static collections
```

## IDE Debugging Tips

### IntelliJ IDEA

**Breakpoint Types**:
- **Line Breakpoint**: Pause at specific line
- **Method Breakpoint**: Pause when method is called
- **Exception Breakpoint**: Pause when exception is thrown
- **Field Watchpoint**: Pause when field is modified

**Conditional Breakpoints**:
```java
// Right-click breakpoint, add condition
for (int i = 0; i < 100; i++) {
    process(i);  // Breakpoint condition: i == 50
}
```

**Evaluate Expression**:
- Alt+F8 to evaluate expressions during debugging
- Can call methods, modify variables

### Eclipse

**Debug Perspective**: Window → Perspective → Open Perspective → Debug

**Display View**: Show result of expressions without breakpoint

## Logging Best Practices

### SLF4J with Logback

```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Service
public class UserService {
    private static final Logger log = LoggerFactory.getLogger(UserService.class);

    public User createUser(UserRequest request) {
        log.debug("Creating user with email: {}", request.getEmail());

        try {
            User user = userRepository.save(User.from(request));
            log.info("User created successfully: id={}", user.getId());
            return user;
        } catch (Exception e) {
            log.error("Failed to create user: {}", request.getEmail(), e);
            throw new UserCreationException("User creation failed", e);
        }
    }
}
```

**Log Levels**:
- **TRACE**: Very detailed, rarely used
- **DEBUG**: Detailed information for debugging
- **INFO**: Important runtime events
- **WARN**: Warning messages (recoverable issues)
- **ERROR**: Error messages (non-recoverable issues)

**Configuration** (logback-spring.xml):
```xml
<configuration>
    <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
    </appender>

    <logger name="com.example" level="DEBUG" />
    <logger name="org.springframework" level="INFO" />
    <logger name="org.hibernate.SQL" level="DEBUG" />

    <root level="INFO">
        <appender-ref ref="CONSOLE" />
    </root>
</configuration>
```

## Common Patterns

### Debugging Stack Traces

```
java.lang.NullPointerException: null
    at com.example.service.UserService.createUser(UserService.java:42)  ← Start here
    at com.example.controller.UserController.create(UserController.java:28)
    at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
    ...
```

**Read from top to bottom**:
1. Exception type: NullPointerException
2. First line of your code (UserService.java:42): This is where the NPE occurred
3. Trace back to understand how you got there

### Reproducing Bugs

1. **Identify Steps**: What actions lead to the bug?
2. **Isolate Variables**: What data causes the issue?
3. **Create Test**: Write failing test to reproduce
4. **Fix**: Make test pass
5. **Verify**: Ensure test now passes

### Binary Search Debugging

When unsure where bug is:
```java
public void complexMethod() {
    stepA();
    log.debug("After stepA");  // Add logging
    stepB();
    log.debug("After stepB");
    stepC();
    log.debug("After stepC");
    // Find which step fails
}
```

## Tools

- **IntelliJ IDEA Debugger**: Full-featured debugging
- **VisualVM**: JVM monitoring and profiling
- **JProfiler**: Commercial profiler
- **Eclipse MAT**: Memory analysis
- **Spring Boot Actuator**: Application monitoring
- **Postman/curl**: API testing
- **H2 Console**: In-memory database inspection

## Quick Reference

| Error | Common Cause | Quick Fix |
|-------|--------------|-----------|
| NullPointerException | Null reference | Add null check, use Optional |
| ClassNotFoundException | Missing dependency | Check build.gradle |
| IllegalStateException | Hibernate session closed | Add @Transactional |
| ConcurrentModificationException | Modifying while iterating | Use Iterator.remove() |
| NoSuchBeanDefinitionException | Bean not found | Check @ComponentScan |
| CircularDependencyException | Circular beans | Use @Lazy or refactor |
| DataIntegrityViolationException | Database constraint | Check unique constraints |
| MethodArgumentNotValidException | Validation failed | Check @Valid and constraints |
