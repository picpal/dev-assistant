# Python Architecture Patterns

## FastAPI Application Architecture

### Structure
```
app/
├── main.py                 # Application entry point
├── config/
│   ├── __init__.py
│   └── settings.py        # Environment configuration
├── routes/                # API Routes (Presentation Layer)
│   ├── __init__.py
│   └── user_routes.py
├── services/              # Business Logic Layer
│   ├── __init__.py
│   └── user_service.py
├── repositories/          # Data Access Layer (optional)
│   ├── __init__.py
│   └── user_repository.py
├── models/                # Database Models (SQLAlchemy/ORM)
│   ├── __init__.py
│   └── user.py
├── schemas/               # Pydantic Schemas (DTOs)
│   ├── __init__.py
│   └── user_schema.py
├── dependencies/          # Dependency Injection
│   ├── __init__.py
│   └── database.py
└── exceptions/            # Custom Exceptions
    ├── __init__.py
    └── user_exceptions.py
```

### Minimal Approach
```python
# main.py - everything in one file
from fastapi import FastAPI
from sqlalchemy.orm import Session

app = FastAPI()

@app.post("/users")
def create_user(name: str, email: str, db: Session = Depends(get_db)):
    user = User(name=name, email=email)
    db.add(user)
    db.commit()
    db.refresh(user)
    return user
```

### Clean Approach
```python
# routes/user_routes.py
from fastapi import APIRouter, Depends, status
from app.schemas.user_schema import UserCreate, UserResponse
from app.services.user_service import UserService
from app.dependencies.auth import get_current_user

router = APIRouter(prefix="/api/users", tags=["users"])

@router.post("", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def create_user(
    user_data: UserCreate,
    service: UserService = Depends(),
    current_user = Depends(get_current_user)
) -> UserResponse:
    return await service.create_user(user_data)

# services/user_service.py
from app.repositories.user_repository import UserRepository
from app.schemas.user_schema import UserCreate, UserResponse
from app.exceptions.user_exceptions import UserAlreadyExistsException

class UserService:
    def __init__(self, repository: UserRepository = Depends()):
        self.repository = repository

    async def create_user(self, user_data: UserCreate) -> UserResponse:
        # Check if user exists
        existing = await self.repository.find_by_email(user_data.email)
        if existing:
            raise UserAlreadyExistsException(user_data.email)

        # Create user
        user = await self.repository.create(user_data)
        return UserResponse.from_orm(user)

# repositories/user_repository.py
from sqlalchemy.orm import Session
from app.models.user import User
from app.schemas.user_schema import UserCreate

class UserRepository:
    def __init__(self, db: Session = Depends(get_db)):
        self.db = db

    async def create(self, user_data: UserCreate) -> User:
        user = User(**user_data.dict())
        self.db.add(user)
        self.db.commit()
        self.db.refresh(user)
        return user

    async def find_by_email(self, email: str) -> User | None:
        return self.db.query(User).filter(User.email == email).first()

# schemas/user_schema.py
from pydantic import BaseModel, EmailStr, Field
from datetime import datetime

class UserCreate(BaseModel):
    name: str = Field(..., min_length=1, max_length=100)
    email: EmailStr
    password: str = Field(..., min_length=8)

class UserResponse(BaseModel):
    id: int
    name: str
    email: str
    created_at: datetime

    class Config:
        from_attributes = True  # Pydantic v2 (orm_mode in v1)

# exceptions/user_exceptions.py
from fastapi import HTTPException, status

class UserAlreadyExistsException(HTTPException):
    def __init__(self, email: str):
        super().__init__(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"User with email {email} already exists"
        )
```

### Pragmatic Approach
```python
# routes/user_routes.py
from fastapi import APIRouter, Depends, HTTPException, status
from app.schemas.user_schema import UserCreate, UserResponse
from app.services.user_service import UserService

router = APIRouter(prefix="/api/users", tags=["users"])

@router.post("", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def create_user(
    user_data: UserCreate,
    service: UserService = Depends()
) -> UserResponse:
    return await service.create_user(user_data)

# services/user_service.py
from sqlalchemy.orm import Session
from fastapi import Depends, HTTPException, status
from app.models.user import User
from app.schemas.user_schema import UserCreate, UserResponse
from app.dependencies.database import get_db

class UserService:
    def __init__(self, db: Session = Depends(get_db)):
        self.db = db

    async def create_user(self, user_data: UserCreate) -> UserResponse:
        # Check existing user
        existing = self.db.query(User).filter(User.email == user_data.email).first()
        if existing:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="User already exists"
            )

        # Create user
        user = User(**user_data.dict())
        self.db.add(user)
        self.db.commit()
        self.db.refresh(user)
        return UserResponse.from_orm(user)

# schemas/user_schema.py
from pydantic import BaseModel, EmailStr

class UserCreate(BaseModel):
    name: str
    email: EmailStr
    password: str

class UserResponse(BaseModel):
    id: int
    name: str
    email: str

    class Config:
        from_attributes = True
```

## Flask Application Architecture

### Structure (Application Factory Pattern)
```
app/
├── __init__.py            # Application factory
├── config.py              # Configuration
├── models/                # SQLAlchemy models
│   ├── __init__.py
│   └── user.py
├── routes/                # Blueprints
│   ├── __init__.py
│   └── user_routes.py
├── services/              # Business logic
│   ├── __init__.py
│   └── user_service.py
└── extensions.py          # Extensions (db, migrate, etc.)
```

### Application Factory
```python
# app/__init__.py
from flask import Flask
from app.extensions import db, migrate
from app.routes import user_routes

def create_app(config_name='development'):
    app = Flask(__name__)
    app.config.from_object(f'app.config.{config_name.capitalize()}Config')

    # Initialize extensions
    db.init_app(app)
    migrate.init_app(app, db)

    # Register blueprints
    app.register_blueprint(user_routes.bp)

    return app

# app/extensions.py
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate

db = SQLAlchemy()
migrate = Migrate()
```

## Dependency Injection Patterns

### FastAPI (Native Support)
```python
from fastapi import Depends
from sqlalchemy.orm import Session

# Dependency function
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Usage in route
@router.get("/users")
def get_users(db: Session = Depends(get_db)):
    return db.query(User).all()

# Dependency class
class UserService:
    def __init__(self, db: Session = Depends(get_db)):
        self.db = db

# Nested dependencies
def get_user_service(db: Session = Depends(get_db)) -> UserService:
    return UserService(db)

@router.get("/users")
def get_users(service: UserService = Depends(get_user_service)):
    return service.get_all()
```

### Flask (Manual Injection)
```python
# Using g object
from flask import g

def get_db():
    if 'db' not in g:
        g.db = SessionLocal()
    return g.db

@app.teardown_appcontext
def close_db(error):
    db = g.pop('db', None)
    if db is not None:
        db.close()

# Usage
@app.route('/users')
def get_users():
    db = get_db()
    return db.query(User).all()
```

## Error Handling

### Minimal
```python
@router.post("/users")
def create_user(user: UserCreate, db: Session = Depends(get_db)):
    try:
        user = User(**user.dict())
        db.add(user)
        db.commit()
        return user
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))
```

### Clean
```python
# Custom exceptions
class UserException(Exception):
    """Base exception for user operations"""
    pass

class UserNotFoundException(UserException):
    def __init__(self, user_id: int):
        self.user_id = user_id
        super().__init__(f"User {user_id} not found")

class UserAlreadyExistsException(UserException):
    def __init__(self, email: str):
        self.email = email
        super().__init__(f"User with email {email} already exists")

# Global exception handler (FastAPI)
from fastapi import Request
from fastapi.responses import JSONResponse

@app.exception_handler(UserNotFoundException)
async def user_not_found_handler(request: Request, exc: UserNotFoundException):
    return JSONResponse(
        status_code=404,
        content={
            "error": "UserNotFound",
            "message": str(exc),
            "user_id": exc.user_id
        }
    )

# Flask error handler
@app.errorhandler(UserNotFoundException)
def handle_user_not_found(e):
    return jsonify(error=str(e)), 404
```

## Async Patterns (FastAPI)

### Async Service
```python
class UserService:
    def __init__(self, db: AsyncSession = Depends(get_async_db)):
        self.db = db

    async def create_user(self, user_data: UserCreate) -> User:
        async with self.db as session:
            user = User(**user_data.dict())
            session.add(user)
            await session.commit()
            await session.refresh(user)
            return user

# Async route
@router.post("/users")
async def create_user(
    user_data: UserCreate,
    service: UserService = Depends()
):
    return await service.create_user(user_data)
```

## Configuration Management

### Environment-based Configuration
```python
# config/settings.py
from pydantic import BaseSettings

class Settings(BaseSettings):
    app_name: str = "MyApp"
    database_url: str
    secret_key: str
    debug: bool = False

    class Config:
        env_file = ".env"

settings = Settings()

# Usage
from app.config.settings import settings

@app.get("/")
def root():
    return {"app": settings.app_name}
```

## Testing Architecture

### Minimal
```python
# tests/test_user.py
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_create_user():
    response = client.post("/users", json={"name": "John", "email": "john@example.com"})
    assert response.status_code == 201
```

### Clean
```python
# tests/conftest.py
import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.main import app
from app.dependencies.database import get_db
from app.models.base import Base

SQLALCHEMY_DATABASE_URL = "sqlite:///./test.db"

@pytest.fixture(scope="function")
def db_session():
    engine = create_engine(SQLALCHEMY_DATABASE_URL)
    Base.metadata.create_all(bind=engine)
    SessionLocal = sessionmaker(bind=engine)
    session = SessionLocal()
    yield session
    session.close()
    Base.metadata.drop_all(bind=engine)

@pytest.fixture(scope="function")
def client(db_session):
    def override_get_db():
        yield db_session
    app.dependency_overrides[get_db] = override_get_db
    yield TestClient(app)
    app.dependency_overrides.clear()

# tests/test_user_service.py
import pytest
from app.services.user_service import UserService
from app.schemas.user_schema import UserCreate

def test_create_user(db_session):
    service = UserService(db=db_session)
    user_data = UserCreate(name="John", email="john@example.com", password="password123")
    user = service.create_user(user_data)
    assert user.id is not None
    assert user.email == "john@example.com"

# tests/test_user_routes.py
def test_create_user_endpoint(client):
    response = client.post("/api/users", json={
        "name": "John",
        "email": "john@example.com",
        "password": "password123"
    })
    assert response.status_code == 201
    data = response.json()
    assert data["email"] == "john@example.com"
```

## Trade-offs Summary

| Aspect | Minimal | Pragmatic | Clean |
|--------|---------|-----------|-------|
| Files Created | 1-2 | 4-6 | 8-12 |
| Layers | Route only | Route + Service | Route + Service + Repository |
| Validation | Basic Pydantic | Pydantic + business rules | Full validation + custom validators |
| DI | Minimal | Function-based | Class-based services |
| Exception Handling | try-except | HTTPException | Custom exceptions + handlers |
| Testing | Integration only | Critical unit + integration | Full unit + integration |
| Type Hints | Partial | Most functions | Complete |
| Time to Implement | Hours | 1-2 days | 2-4 days |
