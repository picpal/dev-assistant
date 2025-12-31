# Python Best Practices

## PEP 8 Style Guide

```python
# Good: lowercase with underscores
def calculate_total(items):
    pass

class UserService:
    pass

# Constants: UPPERCASE
MAX_RETRIES = 3

# 4 spaces for indentation (never tabs)
```

## Type Hints

```python
from typing import List, Optional, Dict

def process_users(
    user_ids: List[int],
    options: Optional[Dict[str, any]] = None
) -> List[User]:
    """Process users with type safety."""
    pass
```

## List Comprehensions

```python
# Good: List comprehension
squares = [x**2 for x in range(10)]

# Avoid building with append in loop
squares = []
for x in range(10):
    squares.append(x**2)
```

## Context Managers

```python
# Good: Always use context managers for resources
with open('file.txt') as f:
    data = f.read()

# Avoid manual close
f = open('file.txt')
data = f.read()
f.close()  # Might not execute if error
```

## Pythonic Patterns

```python
# Good: Use get() with default
value = config.get('timeout', 30)

# Good: Use enumerate
for i, item in enumerate(items):
    print(f"{i}: {item}")

# Good: Use zip for parallel iteration
for name, age in zip(names, ages):
    print(f"{name} is {age}")
```

## Avoid Mutable Defaults

```python
# Bad
def add_item(item, items=[]):  # Shared across calls!
    items.append(item)
    return items

# Good
def add_item(item, items=None):
    if items is None:
        items = []
    items.append(item)
    return items
```
