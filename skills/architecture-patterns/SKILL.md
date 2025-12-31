---
name: architecture-patterns
description: Multi-language architecture patterns and design approaches for Java/Spring Boot, Python, and TypeScript/React, with guidance on Minimal/Clean/Pragmatic trade-offs
trigger: When designing feature architecture or making architectural decisions
---

# Architecture Patterns Skill

This skill provides comprehensive architecture patterns, design approaches, and trade-off analysis for multi-language environments.

## Purpose

Guide architects and developers in making informed architectural decisions by providing:
- Three design approaches (Minimal/Clean/Pragmatic) with trade-offs
- Language-specific architecture patterns
- Framework conventions and best practices
- Project structure recommendations
- Design pattern catalog with use cases

## Coverage

- **Java/Spring Boot**: Layered architecture, hexagonal architecture, domain-driven design
- **Python**: Application patterns for FastAPI/Flask/Django, service layer patterns
- **TypeScript/React**: Component architecture, state management patterns, API layer design
- **Cross-cutting**: Error handling, validation, testing, security, performance

## When to Use

- Designing new feature architecture
- Choosing between multiple implementation approaches
- Evaluating trade-offs (speed vs quality vs maintainability)
- Understanding framework conventions
- Learning design patterns for specific contexts
- Structuring greenfield projects

## Three Architectural Approaches

### Minimal Approach
**Philosophy**: Fastest path to working solution with minimal changes

**When to Use**:
- Prototypes or proof-of-concepts
- Simple features with low complexity
- Tight deadlines
- Low-risk changes
- Features unlikely to change

**Trade-offs**:
- ✅ Fast implementation (hours)
- ✅ Low risk of breaking existing code
- ✅ Easy to understand
- ❌ May accumulate technical debt
- ❌ Harder to extend later
- ❌ Less testable

### Clean Approach
**Philosophy**: Best practices, SOLID principles, long-term maintainability

**When to Use**:
- Core business logic
- Features expected to evolve
- Team learning/reference implementations
- High-risk or complex features
- Long-lived projects

**Trade-offs**:
- ✅ Highly maintainable
- ✅ Easy to extend and test
- ✅ Clear separation of concerns
- ❌ More files to create
- ❌ Longer implementation time (days)
- ❌ Higher initial complexity

### Pragmatic Approach
**Philosophy**: Balanced trade-off between speed and quality

**When to Use**:
- Most production features (default choice)
- When timeline and quality both matter
- Moderate complexity features
- Existing codebase with mixed patterns

**Trade-offs**:
- ✅ Good balance of speed and quality
- ✅ Maintainable without over-engineering
- ✅ Testable critical paths
- ✅ Reasonable complexity
- ⚖️ Some compromises on both sides

## Reference Files

### java-architecture.md
Comprehensive guide for Java/Spring Boot architecture:
- Layered architecture (Controller → Service → Repository → Entity)
- Hexagonal architecture (Ports & Adapters)
- Domain-Driven Design patterns
- Spring Boot project structure
- Package organization strategies
- Bean lifecycle and dependency injection
- Exception handling architecture
- Testing architecture (unit, integration, contract)

### python-architecture.md
Python application architecture patterns:
- FastAPI/Flask/Django architecture patterns
- Service layer pattern
- Repository pattern vs direct ORM
- Dependency injection approaches
- Module and package organization
- Error handling patterns
- Async architecture (async/await patterns)
- Testing architecture (pytest patterns)

### typescript-react-architecture.md
TypeScript/React application architecture:
- Component architecture (atomic design, feature-based)
- State management patterns (Context, Redux, Zustand)
- Custom hooks patterns
- API layer design
- Type organization (interfaces, types, enums)
- Error boundary patterns
- Testing architecture (Jest, RTL, E2E)
- Code splitting and lazy loading

### design-patterns-catalog.md
Common design patterns with multi-language examples:
- **Creational**: Factory, Builder, Singleton
- **Structural**: Adapter, Decorator, Facade
- **Behavioral**: Strategy, Observer, Command
- **Enterprise**: Repository, Service Layer, DTO
- Language-specific implementations and idiomatic usage

### trade-off-analysis.md
Framework for analyzing architectural trade-offs:
- Performance vs Maintainability
- Simplicity vs Flexibility
- Type Safety vs Development Speed
- Monolith vs Microservices (for relevant features)
- Abstraction levels (when to abstract vs when to keep simple)
- Testing strategies (unit vs integration vs E2E)

### greenfield-structures.md
Project structure templates for new projects:
- Java/Spring Boot starter structure
- Python/FastAPI starter structure
- TypeScript/React starter structure
- Multi-module project organization
- Configuration management
- Environment setup

## Usage Examples

### Example 1: Choosing Approach for User Authentication Feature

**Context**: Building user authentication for a production application

**Analysis**:
- **Minimal**: Quick OAuth integration with session storage
  - Fast but hard to extend to JWT or multi-provider later

- **Clean**: Full authentication service with strategy pattern
  - Supports multiple providers, testable, but takes 3-4 days

- **Pragmatic**: ✅ **Recommended**
  - Dedicated auth service with configuration-based provider selection
  - Supports current need (OAuth) with easy JWT addition later
  - 1-2 days implementation, good test coverage

**Decision**: Pragmatic approach balances immediate needs with future flexibility

### Example 2: Database Access Layer Design (Java/Spring Boot)

**Context**: Adding database access for new entity

**Minimal Approach**:
```java
// UserController.java - All in one place
@RestController
public class UserController {
    @Autowired
    private UserRepository userRepository;

    @PostMapping("/users")
    public User createUser(@RequestBody User user) {
        return userRepository.save(user);  // Direct repository access
    }
}
```

**Clean Approach**:
```java
// UserController.java
@RestController
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;

    @PostMapping("/users")
    public ResponseEntity<UserResponse> createUser(@Valid @RequestBody CreateUserRequest request) {
        return ResponseEntity.ok(userService.createUser(request));
    }
}

// UserService.java
@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepository;
    private final UserMapper userMapper;

    public UserResponse createUser(CreateUserRequest request) {
        User user = userMapper.toEntity(request);
        User saved = userRepository.save(user);
        return userMapper.toResponse(saved);
    }
}

// Separate DTOs, mapper, exception handling, validation
```

**Pragmatic Approach**:
```java
// UserController.java
@RestController
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;

    @PostMapping("/users")
    public UserResponse createUser(@Valid @RequestBody CreateUserRequest request) {
        return userService.createUser(request);
    }
}

// UserService.java
@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepository;

    public UserResponse createUser(CreateUserRequest request) {
        User user = new User(request.getName(), request.getEmail());
        user = userRepository.save(user);
        return UserResponse.from(user);  // Simple static factory
    }
}

// DTOs with static factory methods, standard validation
```

### Example 3: State Management in React

**Minimal**: Use component state everywhere
```typescript
// UserList.tsx
function UserList() {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    setLoading(true);
    fetch('/api/users')
      .then(r => r.json())
      .then(setUsers)
      .finally(() => setLoading(false));
  }, []);

  return <div>{/* render */}</div>;
}
```

**Clean**: Full Context + Custom Hook + React Query
```typescript
// contexts/UserContext.tsx
const UserContext = createContext<UserContextType>(null);

export function UserProvider({ children }) {
  // Complex state management
}

// hooks/useUsers.ts
export function useUsers() {
  return useQuery(['users'], fetchUsers, {
    staleTime: 5000,
    cacheTime: 10000,
  });
}

// components/UserList.tsx
function UserList() {
  const { users, loading } = useUsers();
  return <div>{/* render */}</div>;
}
```

**Pragmatic**: Custom Hook with fetch
```typescript
// hooks/useUsers.ts
export function useUsers() {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    setLoading(true);
    fetchUsers()
      .then(setUsers)
      .finally(() => setLoading(false));
  }, []);

  return { users, loading };
}

// components/UserList.tsx
function UserList() {
  const { users, loading } = useUsers();
  return <div>{/* render */}</div>;
}
```

## Best Practices

### For Minimal Approach
1. **Know the debt**: Document what you're skipping
2. **Test critical path**: At least one integration test
3. **Set refactor trigger**: Define when to upgrade to Clean
4. **Avoid cascading**: Don't let "quick fixes" compound

### For Clean Approach
1. **Don't over-engineer**: Apply patterns only when needed
2. **Document decisions**: Explain why you chose complexity
3. **Ensure value**: Make sure abstraction pays off
4. **Keep it simple**: Clean doesn't mean complicated

### For Pragmatic Approach
1. **Be strategic**: Invest quality where it matters
2. **Follow existing patterns**: Match codebase style
3. **Test critical paths**: Focus test coverage on important flows
4. **Refactor as needed**: Don't be afraid to upgrade later

## Integration with Code-Architect Agent

This skill supports the `code-architect` agent by providing:
- Approach selection criteria
- Language-specific patterns
- Trade-off analysis frameworks
- Implementation blueprints
- Design pattern catalog

The code-architect agent uses this knowledge to design one of three approaches based on assignment.

## Related Skills

- **debugging-patterns**: Ensure architecture facilitates debugging
- **test-automation**: Design for testability
- **quality-standards**: Apply SOLID principles appropriately
- **performance-benchmarks**: Optimize architecture for performance

## Decision Framework

When choosing an approach, consider:

1. **Feature Longevity**: How long will this feature live?
   - Short (< 6 months): Minimal
   - Medium (6-18 months): Pragmatic
   - Long (> 18 months): Clean

2. **Complexity**: How complex is the feature?
   - Low (< 100 LOC): Minimal
   - Medium (100-500 LOC): Pragmatic
   - High (> 500 LOC): Clean

3. **Change Frequency**: How often will it change?
   - Rarely: Minimal
   - Occasionally: Pragmatic
   - Frequently: Clean

4. **Team Familiarity**: How familiar is team with the domain?
   - Expert: Minimal (they know shortcuts)
   - Proficient: Pragmatic
   - Learning: Clean (reference implementation)

5. **Business Criticality**: How critical is this feature?
   - Low: Minimal
   - Medium: Pragmatic
   - High: Clean

**Scoring**: Assign points (Minimal=1, Pragmatic=2, Clean=3) to each factor, average the score:
- 1.0-1.6: Choose Minimal
- 1.7-2.3: Choose Pragmatic
- 2.4-3.0: Choose Clean

## Maintenance

Update reference files when:
- New framework versions change best practices
- New design patterns emerge
- Team learns better approaches
- Technology landscape shifts (e.g., new state management libraries)
- Retrospectives reveal pattern improvements
