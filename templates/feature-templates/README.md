# Feature Templates

Common feature patterns for quick scaffolding across Java/Spring Boot, Python/FastAPI, and TypeScript/React.

## Available Templates

### 1. CRUD Operations
Basic Create-Read-Update-Delete operations for an entity.

**Includes**:
- Entity/Model definition
- Repository/Database layer
- Service layer with business logic
- API endpoints (REST)
- DTOs/Schemas for request/response
- Basic validation
- Unit and integration tests

**Example**: User management, Product catalog, Blog posts

---

### 2. Authentication & Authorization
User authentication and role-based access control.

**Includes**:
- User model with password hashing
- Login/Register endpoints
- JWT token generation (or session-based)
- Auth middleware/guards
- Role-based permissions
- Password reset flow
- Refresh token mechanism

**Frameworks**:
- Java: Spring Security
- Python: FastAPI Depends + JWT
- TypeScript: Context API + Protected Routes

---

### 3. File Upload & Storage
Handle file uploads with validation and storage.

**Includes**:
- File upload endpoint with size/type validation
- Storage service (local or cloud)
- File metadata tracking
- Download/serve endpoints
- Image resizing (if applicable)
- Security checks

**Storage Options**:
- Local filesystem
- S3/MinIO
- Azure Blob Storage

---

### 4. Pagination & Filtering
List endpoints with pagination, sorting, and filtering.

**Includes**:
- Paginated query support
- Sort by multiple fields
- Filter by criteria
- Search functionality
- Response metadata (total count, page info)

**Example Response**:
```json
{
  "items": [...],
  "total": 150,
  "page": 2,
  "pageSize": 20,
  "totalPages": 8
}
```

---

### 5. Background Jobs
Asynchronous task processing.

**Includes**:
- Job queue setup (Celery, Bull, Spring @Async)
- Task definition and execution
- Job status tracking
- Retry logic
- Scheduled jobs (cron)

**Use Cases**:
- Email sending
- Report generation
- Data import/export
- Batch processing

---

### 6. Real-time Updates
WebSocket or Server-Sent Events for live data.

**Includes**:
- WebSocket/SSE endpoint setup
- Connection management
- Event broadcasting
- Client-side subscription
- Reconnection logic

**Frameworks**:
- Java: Spring WebSocket
- Python: FastAPI WebSocket or SSE
- TypeScript: native WebSocket or Socket.IO

---

### 7. Search Functionality
Full-text search with filtering.

**Includes**:
- Search endpoint with query parsing
- Database full-text search (PostgreSQL, MySQL)
- Or integration with Elasticsearch
- Ranking/relevance scoring
- Highlight matches
- Search suggestions/autocomplete

---

### 8. Caching Layer
Cache frequently accessed data for performance.

**Includes**:
- Cache configuration (Redis, in-memory)
- Cache-aside pattern
- TTL (time-to-live) settings
- Cache invalidation strategy
- Cache warming
- Monitoring/stats

**Caching Strategies**:
- Read-through
- Write-through
- Cache-aside
- Write-behind

---

### 9. Rate Limiting
Protect APIs from abuse.

**Includes**:
- Rate limit middleware
- Per-user or per-IP limits
- Sliding window or token bucket
- Custom limit tiers
- Response headers (X-RateLimit-*)
- Exceed limit handling

**Storage**:
- In-memory (single server)
- Redis (distributed)

---

### 10. Audit Logging
Track who changed what and when.

**Includes**:
- Audit log model (user, action, timestamp, changes)
- Automatic logging on CRUD operations
- Query audit history
- Retention policy
- Compliance support (GDPR, SOX)

**Fields Tracked**:
- User ID
- Action type (create/update/delete)
- Entity type and ID
- Before/after values
- Timestamp
- IP address

---

## Usage

Each template provides:
1. **Code snippets** for all three languages
2. **Implementation guide** with step-by-step instructions
3. **Testing examples** for critical paths
4. **Common pitfalls** and how to avoid them
5. **Performance considerations**
6. **Security best practices**

## How to Apply Templates

When using `/build` command:
1. Mention the feature template you want to use
2. The workflow will adapt it to your chosen approach (Minimal/Clean/Pragmatic)
3. Code will be generated following your project's detected language and conventions

**Example**:
```
/build Add user authentication using the Auth template
```

The workflow will:
- Detect your project language (Java/Python/TypeScript)
- Present 3 approaches (Minimal/Clean/Pragmatic)
- Generate auth code following your project conventions
- Include tests appropriate to chosen approach

## Customization

Templates are starting points - customize based on:
- Project requirements
- Team conventions
- Performance needs
- Security requirements
- Compliance regulations

## Best Practices

1. **Don't copy blindly**: Understand the pattern before applying
2. **Adapt to context**: Modify templates for your specific use case
3. **Follow project conventions**: Match existing code style
4. **Test thoroughly**: Templates provide basic tests, add more as needed
5. **Security review**: Especially for auth, file upload, and data access

## Contribution

To add new feature templates:
1. Create template documentation
2. Provide multi-language examples (Java/Python/TypeScript)
3. Include tests and security considerations
4. Document common issues and solutions
