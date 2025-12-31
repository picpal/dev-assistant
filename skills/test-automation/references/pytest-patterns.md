# pytest Testing Patterns

## Basic Test Structure

```python
import pytest
from myapp.services import UserService
from myapp.models import User

class TestUserService:
    """Test suite for UserService"""

    @pytest.fixture
    def user_repository_mock(self):
        """Mock repository"""
        from unittest.mock import Mock
        return Mock()

    @pytest.fixture
    def user_service(self, user_repository_mock):
        """Create UserService with mock"""
        return UserService(user_repository_mock)

    def test_get_user_returns_user_when_exists(self, user_service, user_repository_mock):
        # Arrange
        user = User(id=1, name="John", email="john@example.com")
        user_repository_mock.find_by_id.return_value = user

        # Act
        result = user_service.get_user_by_id(1)

        # Assert
        assert result == user
        user_repository_mock.find_by_id.assert_called_once_with(1)
```

## Parametrized Tests

```python
@pytest.mark.parametrize("email,expected", [
    ("john@example.com", True),
    ("invalid", False),
    ("", False),
    ("@example.com", False),
])
def test_email_validation(email, expected):
    result = validate_email(email)
    assert result == expected

@pytest.mark.parametrize("amount,tax_rate,expected", [
    (10, 0.1, 11.0),
    (20, 0.2, 24.0),
    (100, 0.15, 115.0),
])
def test_calculate_total_with_tax(amount, tax_rate, expected):
    result = calculate_total(amount, tax_rate)
    assert result == expected
```

## Fixtures with Scopes

```python
@pytest.fixture(scope="session")
def database():
    """Setup database once for entire test session"""
    db = create_test_database()
    yield db
    db.cleanup()

@pytest.fixture(scope="function")
def user(database):
    """Create fresh user for each test"""
    u = User(name="Test User")
    database.add(u)
    yield u
    database.delete(u)
```

## Async Testing

```python
@pytest.mark.asyncio
async def test_async_fetch_user():
    user = await fetch_user_async(1)
    assert user.id == 1

@pytest.mark.asyncio
async def test_concurrent_requests():
    results = await asyncio.gather(
        fetch_user_async(1),
        fetch_user_async(2)
    )
    assert len(results) == 2
```
