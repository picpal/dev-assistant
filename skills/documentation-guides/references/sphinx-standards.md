# Python Docstring Standards

## Google Style (Recommended)

```python
def create_user(name: str, email: str, age: int = None) -> User:
    """Create a new user account.

    Creates a user with the provided information and saves to database.
    Email must be unique across all users.

    Args:
        name: Full name of the user
        email: Email address (must be valid format)
        age: User age in years (optional)

    Returns:
        User: The created user object with generated ID

    Raises:
        ValueError: If email format is invalid
        DuplicateEmailError: If email already exists

    Examples:
        >>> user = create_user("John Doe", "john@example.com", 30)
        >>> print(user.id)
        1
    """
    pass
```

## NumPy Style

```python
def process_data(data, threshold=0.5):
    """
    Process input data with given threshold.

    Parameters
    ----------
    data : array_like
        Input data to process
    threshold : float, optional
        Threshold value (default: 0.5)

    Returns
    -------
    ndarray
        Processed data

    Notes
    -----
    Uses binary thresholding algorithm.
    """
    pass
```

## Class Documentation

```python
class UserService:
    """Service for managing user accounts.

    This service handles all user-related operations including
    creation, updates, authentication, and password management.

    Attributes:
        repository: User repository for database access
        validator: User data validator
    """

    def __init__(self, repository: UserRepository):
        """Initialize service with repository."""
        self.repository = repository
```
