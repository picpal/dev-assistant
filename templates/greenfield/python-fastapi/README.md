# Python/FastAPI Greenfield Template

Starter template for new FastAPI projects with best practices.

## Project Structure

```
my-fastapi-app/
├── app/
│   ├── main.py
│   ├── config/settings.py
│   ├── db/
│   ├── models/
│   ├── schemas/
│   ├── routes/
│   ├── services/
│   └── dependencies/
├── tests/
├── alembic/
├── .env.example
├── pyproject.toml
└── README.md
```

## Included Features

- FastAPI 0.104+
- SQLAlchemy 2.0+ (async)
- Pydantic 2.0+ for validation
- Alembic for migrations
- PostgreSQL driver
- Poetry for dependency management
- pytest for testing
- Black + isort for formatting
- Type hints throughout

## Getting Started

1. Copy `.env.example` to `.env` and configure
2. Install dependencies: `poetry install`
3. Run migrations: `alembic upgrade head`
4. Start server: `poetry run uvicorn app.main:app --reload`

## Conventions

- **Module by feature**: Each domain in separate module
- **Type hints**: Use everywhere for better IDE support
- **Pydantic schemas**: Separate request/response models
- **Async**: Use async/await for I/O operations
- **Dependency injection**: Use FastAPI Depends()
- **Testing**: pytest with fixtures

## Reference

See `skills/architecture-patterns/references/python-architecture.md` for detailed patterns.
