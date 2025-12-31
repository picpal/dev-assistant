# Java/Spring Boot Greenfield Template

Starter template for new Spring Boot projects with best practices.

## Project Structure

```
my-spring-app/
├── gradle/
│   └── wrapper/
├── src/
│   ├── main/
│   │   ├── java/com/company/myapp/
│   │   │   ├── MyAppApplication.java
│   │   │   ├── config/
│   │   │   ├── [feature]/
│   │   │   │   ├── controller/
│   │   │   │   ├── service/
│   │   │   │   ├── repository/
│   │   │   │   ├── entity/
│   │   │   │   └── dto/
│   │   │   └── common/
│   │   └── resources/
│   │       ├── application.yml
│   │       └── db/migration/
│   └── test/
├── build.gradle
└── README.md
```

## Included Features

- Spring Boot 3.2+
- Spring Data JPA
- Spring Security (basic setup)
- PostgreSQL driver
- Flyway migrations
- Lombok for boilerplate reduction
- Validation
- Testing (JUnit 5, Mockito)

## Getting Started

1. Update `build.gradle` with your group and artifact names
2. Update package structure in `src/main/java`
3. Configure `application.yml` with your database settings
4. Run: `./gradlew bootRun`

## Conventions

- **Package by feature**: Each domain gets its own package
- **Constructor injection**: Use Lombok @RequiredArgsConstructor
- **DTOs**: Separate request/response objects from entities
- **Exception handling**: Global @ControllerAdvice
- **Testing**: Unit tests for services, integration tests for controllers

## Reference

See `skills/architecture-patterns/references/java-architecture.md` for detailed patterns.
