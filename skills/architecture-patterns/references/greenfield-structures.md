# Greenfield Project Structures

Starter structures for new projects in Java/Spring Boot, Python, and TypeScript/React.

## Java/Spring Boot Project

### Gradle Structure
```
my-spring-app/
├── gradle/
│   └── wrapper/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/company/myapp/
│   │   │       ├── MyAppApplication.java
│   │   │       ├── config/
│   │   │       │   ├── SecurityConfig.java
│   │   │       │   └── WebConfig.java
│   │   │       ├── user/
│   │   │       │   ├── controller/
│   │   │       │   │   └── UserController.java
│   │   │       │   ├── service/
│   │   │       │   │   └── UserService.java
│   │   │       │   ├── repository/
│   │   │       │   │   └── UserRepository.java
│   │   │       │   ├── entity/
│   │   │       │   │   └── User.java
│   │   │       │   └── dto/
│   │   │       │       ├── CreateUserRequest.java
│   │   │       │       └── UserResponse.java
│   │   │       └── common/
│   │   │           ├── exception/
│   │   │           │   ├── GlobalExceptionHandler.java
│   │   │           │   └── ResourceNotFoundException.java
│   │   │           └── util/
│   │   └── resources/
│   │       ├── application.yml
│   │       ├── application-dev.yml
│   │       ├── application-prod.yml
│   │       └── db/migration/
│   │           └── V1__Initial_schema.sql
│   └── test/
│       └── java/
│           └── com/company/myapp/
│               ├── user/
│               │   ├── UserServiceTest.java
│               │   └── UserControllerIntegrationTest.java
│               └── MyAppApplicationTests.java
├── build.gradle
├── settings.gradle
├── gradlew
├── gradlew.bat
├── .gitignore
└── README.md
```

### build.gradle
```gradle
plugins {
    id 'java'
    id 'org.springframework.boot' version '3.2.0'
    id 'io.spring.dependency-management' version '1.1.4'
    id 'org.flywaydb.flyway' version '10.0.0'
}

group = 'com.company'
version = '0.0.1-SNAPSHOT'

java {
    sourceCompatibility = '17'
}

configurations {
    compileOnly {
        extendsFrom annotationProcessor
    }
}

repositories {
    mavenCentral()
}

dependencies {
    // Spring Boot
    implementation 'org.springframework.boot:spring-boot-starter-web'
    implementation 'org.springframework.boot:spring-boot-starter-data-jpa'
    implementation 'org.springframework.boot:spring-boot-starter-validation'
    implementation 'org.springframework.boot:spring-boot-starter-security'

    // Database
    runtimeOnly 'org.postgresql:postgresql'
    implementation 'org.flywaydb:flyway-core'

    // Lombok
    compileOnly 'org.projectlombok:lombok'
    annotationProcessor 'org.projectlombok:lombok'

    // Testing
    testImplementation 'org.springframework.boot:spring-boot-starter-test'
    testImplementation 'org.springframework.security:spring-security-test'
}

tasks.named('test') {
    useJUnitPlatform()
}
```

### application.yml
```yaml
spring:
  application:
    name: my-spring-app

  datasource:
    url: jdbc:postgresql://localhost:5432/myapp_db
    username: ${DB_USERNAME:postgres}
    password: ${DB_PASSWORD:postgres}
    driver-class-name: org.postgresql.Driver

  jpa:
    hibernate:
      ddl-auto: validate
    show-sql: false
    properties:
      hibernate:
        format_sql: true
        dialect: org.hibernate.dialect.PostgreSQLDialect

  flyway:
    enabled: true
    baseline-on-migrate: true

server:
  port: 8080
  error:
    include-message: always
    include-stacktrace: on_param

logging:
  level:
    root: INFO
    com.company.myapp: DEBUG
```

### Main Application Class
```java
package com.company.myapp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class MyAppApplication {
    public static void main(String[] args) {
        SpringApplication.run(MyAppApplication.class, args);
    }
}
```

## Python/FastAPI Project

### Project Structure
```
my-fastapi-app/
├── app/
│   ├── __init__.py
│   ├── main.py
│   ├── config/
│   │   ├── __init__.py
│   │   └── settings.py
│   ├── db/
│   │   ├── __init__.py
│   │   ├── base.py
│   │   └── session.py
│   ├── models/
│   │   ├── __init__.py
│   │   └── user.py
│   ├── schemas/
│   │   ├── __init__.py
│   │   └── user.py
│   ├── routes/
│   │   ├── __init__.py
│   │   └── user.py
│   ├── services/
│   │   ├── __init__.py
│   │   └── user.py
│   └── dependencies/
│       ├── __init__.py
│       ├── database.py
│       └── auth.py
├── tests/
│   ├── __init__.py
│   ├── conftest.py
│   └── test_user.py
├── alembic/
│   ├── versions/
│   └── env.py
├── .env.example
├── .gitignore
├── alembic.ini
├── pyproject.toml
├── requirements.txt
└── README.md
```

### pyproject.toml
```toml
[tool.poetry]
name = "my-fastapi-app"
version = "0.1.0"
description = ""
authors = ["Your Name <you@example.com>"]

[tool.poetry.dependencies]
python = "^3.11"
fastapi = "^0.104.0"
uvicorn = {extras = ["standard"], version = "^0.24.0"}
sqlalchemy = "^2.0.0"
pydantic = {extras = ["email"], version = "^2.0.0"}
pydantic-settings = "^2.0.0"
alembic = "^1.12.0"
psycopg2-binary = "^2.9.0"
python-jose = {extras = ["cryptography"], version = "^3.3.0"}
passlib = {extras = ["bcrypt"], version = "^1.7.0"}

[tool.poetry.dev-dependencies]
pytest = "^7.4.0"
pytest-asyncio = "^0.21.0"
httpx = "^0.25.0"
black = "^23.10.0"
isort = "^5.12.0"
mypy = "^1.6.0"
ruff = "^0.1.0"

[build-system]
requires = ["poetry-core"]
build-backend = "poetry.core.masonry.api"

[tool.black]
line-length = 100
target-version = ['py311']

[tool.isort]
profile = "black"
line_length = 100

[tool.pytest.ini_options]
testpaths = ["tests"]
pythonpath = ["."]
```

### app/main.py
```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.config.settings import settings
from app.routes import user

app = FastAPI(
    title=settings.app_name,
    version="0.1.0",
    docs_url="/api/docs",
    redoc_url="/api/redoc",
)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Routes
app.include_router(user.router, prefix="/api")

@app.get("/health")
async def health_check():
    return {"status": "healthy"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app.main:app", host="0.0.0.0", port=8000, reload=True)
```

### app/config/settings.py
```python
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    app_name: str = "My FastAPI App"
    database_url: str
    secret_key: str
    cors_origins: list[str] = ["http://localhost:3000"]
    debug: bool = False

    class Config:
        env_file = ".env"

settings = Settings()
```

### .env.example
```bash
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/myapp_db
SECRET_KEY=your-secret-key-here
CORS_ORIGINS=["http://localhost:3000"]
DEBUG=true
```

## TypeScript/React Project

### Project Structure (Vite + React)
```
my-react-app/
├── public/
│   └── vite.svg
├── src/
│   ├── features/
│   │   └── users/
│   │       ├── components/
│   │       │   ├── UserList.tsx
│   │       │   ├── UserCard.tsx
│   │       │   └── UserForm.tsx
│   │       ├── hooks/
│   │       │   └── useUsers.ts
│   │       ├── services/
│   │       │   └── userService.ts
│   │       ├── types/
│   │       │   └── user.types.ts
│   │       └── index.ts
│   ├── shared/
│   │   ├── components/
│   │   │   ├── Button.tsx
│   │   │   ├── Input.tsx
│   │   │   └── Loading.tsx
│   │   ├── hooks/
│   │   │   └── useApi.ts
│   │   ├── services/
│   │   │   └── apiClient.ts
│   │   ├── types/
│   │   │   └── common.types.ts
│   │   └── utils/
│   │       └── format.ts
│   ├── App.tsx
│   ├── App.css
│   ├── main.tsx
│   └── vite-env.d.ts
├── .env.example
├── .gitignore
├── index.html
├── package.json
├── tsconfig.json
├── tsconfig.node.json
├── vite.config.ts
└── README.md
```

### package.json
```json
{
  "name": "my-react-app",
  "private": true,
  "version": "0.0.1",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "lint": "eslint . --ext ts,tsx --report-unused-disable-directives --max-warnings 0",
    "preview": "vite preview",
    "test": "vitest",
    "test:ui": "vitest --ui"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.18.0",
    "axios": "^1.6.0"
  },
  "devDependencies": {
    "@types/react": "^18.2.37",
    "@types/react-dom": "^18.2.15",
    "@typescript-eslint/eslint-plugin": "^6.10.0",
    "@typescript-eslint/parser": "^6.10.0",
    "@vitejs/plugin-react": "^4.2.0",
    "eslint": "^8.53.0",
    "eslint-plugin-react-hooks": "^4.6.0",
    "eslint-plugin-react-refresh": "^0.4.4",
    "typescript": "^5.2.2",
    "vite": "^5.0.0",
    "vitest": "^0.34.0",
    "@testing-library/react": "^14.0.0",
    "@testing-library/jest-dom": "^6.1.0"
  }
}
```

### tsconfig.json
```json
{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,

    /* Bundler mode */
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",

    /* Linting */
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true,

    /* Path mapping */
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["src"],
  "references": [{ "path": "./tsconfig.node.json" }]
}
```

### vite.config.ts
```typescript
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import path from 'path'

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost:8000',
        changeOrigin: true,
      },
    },
  },
})
```

### src/main.tsx
```typescript
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.tsx'
import './index.css'

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
```

### .env.example
```bash
VITE_API_URL=http://localhost:8000/api
VITE_APP_NAME=My React App
```

## Common Configuration Files

### .gitignore (Universal)
```
# Dependencies
node_modules/
.pnp
.pnp.js

# Build outputs
/build
/dist
target/
*.class

# Environment
.env
.env.local
.env.*.local

# IDE
.idea/
.vscode/
*.iml
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
*.log
logs/

# Testing
/coverage
.pytest_cache/
__pycache__/

# Database
*.db
*.sqlite
```

### README.md Template
```markdown
# Project Name

Brief description of the project.

## Prerequisites

- Java 17+ / Python 3.11+ / Node 18+
- PostgreSQL 15+
- [Other dependencies]

## Setup

### Java/Spring Boot
```bash
./gradlew bootRun
```

### Python/FastAPI
```bash
poetry install
poetry run uvicorn app.main:app --reload
```

### TypeScript/React
```bash
npm install
npm run dev
```

## Environment Variables

Copy `.env.example` to `.env` and fill in the values:

```bash
cp .env.example .env
```

## Database Setup

[Instructions for database setup]

## Testing

[Instructions for running tests]

## Deployment

[Deployment instructions]

## License

[License information]
```

## Multi-Module Project (Advanced)

For larger projects, consider monorepo structure:

```
my-full-stack-app/
├── backend/          # Java/Spring Boot or Python/FastAPI
├── frontend/         # React/TypeScript
├── shared/           # Shared types/schemas
├── docker/
│   ├── docker-compose.yml
│   └── Dockerfile.*
└── README.md
```

This enables:
- Shared type definitions
- Coordinated deployments
- Single repository for full stack
