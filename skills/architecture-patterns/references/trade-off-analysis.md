# Architecture Trade-off Analysis

Framework for evaluating architectural decisions across different dimensions.

## Key Trade-off Dimensions

### 1. Performance vs Maintainability

**Performance-Optimized:**
- ✅ Faster execution
- ✅ Lower resource usage
- ❌ Complex code
- ❌ Harder to modify

**Maintainability-Optimized:**
- ✅ Clear, readable code
- ✅ Easy to modify and extend
- ❌ May have overhead
- ❌ Sometimes slower

**When to favor Performance:**
- High-traffic endpoints
- Data processing pipelines
- Real-time systems
- Resource-constrained environments

**When to favor Maintainability:**
- Business logic
- Features that change frequently
- Code reviewed by many developers
- Long-lived projects

### 2. Simplicity vs Flexibility

**Simple:**
- ✅ Fast to implement
- ✅ Easy to understand
- ✅ Low cognitive load
- ❌ Hard to extend later
- ❌ May need rewrite

**Flexible:**
- ✅ Accommodates future changes
- ✅ Extensible design
- ❌ More complex upfront
- ❌ May over-engineer

**Decision Matrix:**
```
Requirements Certainty vs Complexity

High Certainty, Low Complexity → Simple (Minimal)
High Certainty, High Complexity → Simple with good structure (Pragmatic)
Low Certainty, Low Complexity → Flexible (Pragmatic)
Low Certainty, High Complexity → Flexible (Clean)
```

### 3. Type Safety vs Development Speed

**Strictly Typed:**
- ✅ Catch errors at compile time
- ✅ Better IDE support
- ✅ Self-documenting
- ❌ More boilerplate
- ❌ Slower to prototype

**Loosely Typed:**
- ✅ Rapid prototyping
- ✅ Less code
- ❌ Runtime errors
- ❌ Harder to refactor

**Recommendation by Language:**
- **Java**: Always use strong typing (it's the language nature)
- **Python**: Use type hints for public APIs, optional for internal
- **TypeScript**: Enable strict mode for production, relax for prototypes

### 4. Abstraction Level

**Highly Abstract:**
```java
// High abstraction - Generic, reusable
public interface Repository<T, ID> {
    T save(T entity);
    Optional<T> findById(ID id);
    void delete(ID id);
}

public class UserRepository implements Repository<User, Long> {
    // Implementation
}
```

**Low Abstraction:**
```java
// Low abstraction - Specific, direct
public class UserRepository {
    public User saveUser(User user) { ... }
    public User getUserById(Long id) { ... }
    public void deleteUser(Long id) { ... }
}
```

**When to abstract:**
- Pattern repeats 3+ times
- Clear interface contract
- Multiple implementations expected
- Domain warrants it

**When to keep concrete:**
- Used only once or twice
- Simple, straightforward logic
- Unlikely to change
- Minimal approach chosen

### 5. Testing Strategy

**Full Test Coverage:**
- ✅ High confidence in changes
- ✅ Catches regressions
- ✅ Facilitates refactoring
- ❌ Time-consuming
- ❌ Maintenance overhead

**Pragmatic Testing:**
- ✅ Faster implementation
- ✅ Focus on critical paths
- ❌ Some risk of bugs
- ❌ Less refactoring safety

**Testing Pyramid:**
```
        E2E (Few)
       /        \
  Integration
    (Some)
   /     \
 Unit Tests
  (Many)
```

**Test Coverage by Approach:**
- **Minimal**: 1-2 integration tests, no unit tests
- **Pragmatic**: Critical path unit tests + integration tests
- **Clean**: Full unit coverage + integration + E2E

## Scoring Framework

### Multi-Dimensional Scoring

For each architectural decision, score (1-5) on these dimensions:

1. **Implementation Speed** (1=slow, 5=fast)
2. **Maintainability** (1=hard, 5=easy)
3. **Flexibility** (1=rigid, 5=flexible)
4. **Performance** (1=slow, 5=fast)
5. **Testability** (1=hard, 5=easy)
6. **Complexity** (1=complex, 5=simple)

Example scoring:

| Dimension | Minimal | Pragmatic | Clean |
|-----------|---------|-----------|-------|
| Implementation Speed | 5 | 3 | 1 |
| Maintainability | 2 | 4 | 5 |
| Flexibility | 1 | 3 | 5 |
| Performance | 4 | 3 | 3 |
| Testability | 2 | 4 | 5 |
| Complexity | 5 | 3 | 2 |
| **Total** | **19** | **20** | **21** |

**Weighted by Project Needs:**

Startup MVP (prioritize speed):
- Implementation Speed: 3x weight
- Maintainability: 1x weight
- **Minimal approach wins**

Enterprise System (prioritize quality):
- Implementation Speed: 1x weight
- Maintainability: 3x weight
- **Clean approach wins**

Most Projects (balanced):
- All dimensions: 1x weight
- **Pragmatic approach wins**

## Common Trade-off Scenarios

### Scenario 1: User Authentication

**Context**: Add authentication to existing app

**Minimal**: Session-based with hardcoded users
- Speed: 2 hours
- Flexibility: Hard to add OAuth later
- **Use if**: Internal tool, <10 users

**Pragmatic**: JWT with database users
- Speed: 1 day
- Flexibility: Can add OAuth with refactor
- **Use if**: Standard web app, <1000 users

**Clean**: Auth service with strategy pattern
- Speed: 2-3 days
- Flexibility: Easy to add multiple auth methods
- **Use if**: SaaS product, multiple auth methods expected

### Scenario 2: API Rate Limiting

**Minimal**: In-memory counter
```typescript
const requestCounts = new Map<string, number>();

function rateLimit(userId: string) {
  const count = requestCounts.get(userId) || 0;
  if (count > 100) throw new Error('Rate limited');
  requestCounts.set(userId, count + 1);
}
```
- ✅ Fast to implement
- ❌ Doesn't work across servers
- ❌ Resets on restart

**Pragmatic**: Redis-based counter
```typescript
async function rateLimit(userId: string) {
  const key = `ratelimit:${userId}`;
  const count = await redis.incr(key);
  if (count === 1) await redis.expire(key, 60);
  if (count > 100) throw new Error('Rate limited');
}
```
- ✅ Works across servers
- ✅ Persists across restarts
- ⚖️ Requires Redis

**Clean**: Sliding window with token bucket
- ✅ More accurate limiting
- ✅ Configurable strategies
- ❌ More complex

**Decision**: Pragmatic for most web apps

### Scenario 3: Database Migration

**Minimal**: Manual SQL scripts
- Run migrations manually in production
- No rollback mechanism

**Pragmatic**: Flyway/Liquibase (Java) or Alembic (Python)
- Automated migrations
- Version tracking
- Basic rollback

**Clean**: Blue-green deployment with backward-compatible migrations
- Zero-downtime migrations
- Full rollback capability
- **Use if**: Mission-critical system

## Decision Checklist

Before choosing an approach, answer these questions:

**Project Context:**
- [ ] Is this a prototype or production system?
- [ ] What's the expected lifespan? (<6mo / 6-18mo / >18mo)
- [ ] How many developers will work on this? (1 / 2-5 / >5)
- [ ] What's the timeline pressure? (ASAP / Normal / Flexible)

**Technical Context:**
- [ ] How complex is the feature? (Simple / Moderate / Complex)
- [ ] How often will it change? (Rarely / Sometimes / Frequently)
- [ ] What's the performance requirement? (Normal / High / Critical)
- [ ] How critical is correctness? (Low / Medium / High)

**Business Context:**
- [ ] What's the business impact? (Low / Medium / High)
- [ ] Is this differentiating or commodity? (Commodity / Differentiating)
- [ ] What's the cost of failure? (Low / Medium / High)

**Scoring:**
- Mostly "Low/Simple/Rare" → Minimal
- Mix of levels → Pragmatic
- Mostly "High/Complex/Frequent" → Clean

## Anti-Patterns to Avoid

### 1. Premature Optimization
Building for scale you don't have yet

**Example**: Using microservices for 100 users
**Fix**: Start with monolith, split when needed

### 2. Gold Plating
Adding features "because they might be useful"

**Example**: Adding multi-currency support to single-country app
**Fix**: Implement when actually needed (YAGNI principle)

### 3. Resume-Driven Development
Using technology because it's trendy

**Example**: Using GraphQL for simple CRUD API
**Fix**: Choose based on project needs, not resume

### 4. Analysis Paralysis
Over-analyzing trade-offs, never shipping

**Example**: Spending 2 weeks deciding architecture for 1-day feature
**Fix**: Use Pragmatic approach as default, adjust if clearly wrong

### 5. Not Invented Here
Rejecting existing solutions, building from scratch

**Example**: Building custom ORM instead of using JPA/SQLAlchemy
**Fix**: Prefer battle-tested libraries

## Summary Guidelines

1. **Start Pragmatic**: Use pragmatic approach as default
2. **Downgrade to Minimal**: When time is critical AND feature is temporary
3. **Upgrade to Clean**: When complexity or longevity justifies it
4. **Measure Impact**: Track metrics, not just gut feeling
5. **Refactor When Needed**: It's okay to start Minimal and refactor to Clean later
6. **Document Decisions**: Record why you chose the approach (ADRs)
