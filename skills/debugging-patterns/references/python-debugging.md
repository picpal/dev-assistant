# Python Debugging Guide

## Common Python Errors

### ImportError / ModuleNotFoundError

**Cause**: Module cannot be found

**Common Scenarios**:
```python
# 1. Package not installed
import requests  # ModuleNotFoundError: No module named 'requests'

# Fix: Install package
# pip install requests
# Or add to requirements.txt and run: pip install -r requirements.txt

# 2. Wrong virtual environment
# Fix: Activate correct venv
# source venv/bin/activate  # Linux/Mac
# venv\Scripts\activate  # Windows

# 3. Circular import
# file_a.py
from file_b import function_b

# file_b.py
from file_a import function_a  # Circular!

# Fix: Move import inside function or restructure
# file_b.py
def function_b():
    from file_a import function_a  # Import only when needed
    function_a()

# Better: Extract common code to file_c.py

# 4. PYTHONPATH issue
# Fix: Add to path
import sys
sys.path.insert(0, '/path/to/module')
```

### AttributeError

**Cause**: Object doesn't have the attribute

**Examples**:
```python
# 1. Wrong type
items = [1, 2, 3]
result = items.filter(lambda x: x > 1)  # AttributeError: 'list' has no attribute 'filter'

# Fix: Use list comprehension or filter()
result = [x for x in items if x > 1]
result = list(filter(lambda x: x > 1, items))

# 2. None value
user = get_user(999)  # Returns None
user.name  # AttributeError: 'NoneType' object has no attribute 'name'

# Fix: Check for None
if user is not None:
    print(user.name)

# Or use getattr with default
name = getattr(user, 'name', 'Unknown')

# 3. Misspelled attribute
class User:
    def __init__(self, name):
        self.username = name

user = User("John")
print(user.name)  # AttributeError: 'User' object has no attribute 'name'

# Fix: Use correct attribute
print(user.username)
```

### TypeError

**Cause**: Wrong type for operation

**Examples**:
```python
# 1. Wrong number of arguments
def greet(name, age):
    return f"Hello {name}, age {age}"

greet("John")  # TypeError: greet() missing 1 required positional argument: 'age'

# Fix: Provide all arguments or use default
def greet(name, age=0):
    return f"Hello {name}, age {age}"

# 2. Type mismatch
result = "5" + 5  # TypeError: can only concatenate str (not "int") to str

# Fix: Convert types
result = "5" + str(5)  # "55"
result = int("5") + 5  # 10

# 3. Unhashable type
my_dict = {[1, 2]: "value"}  # TypeError: unhashable type: 'list'

# Fix: Use tuple instead
my_dict = {(1, 2): "value"}  # OK
```

### IndentationError

**Cause**: Inconsistent indentation

**Examples**:
```python
# Mixed tabs and spaces
def function():
    if True:
        print("hello")  # 4 spaces
	print("world")  # Tab - IndentationError!

# Fix: Use only spaces (PEP 8: 4 spaces)
def function():
    if True:
        print("hello")
        print("world")

# Check for mixed indentation
# python -tt script.py
```

### KeyError

**Cause**: Dictionary key doesn't exist

**Examples**:
```python
user = {"name": "John", "age": 30}
email = user["email"]  # KeyError: 'email'

# Fix 1: Check if key exists
if "email" in user:
    email = user["email"]

# Fix 2: Use .get() with default
email = user.get("email", "no-email@example.com")

# Fix 3: Use defaultdict
from collections import defaultdict
user = defaultdict(lambda: "N/A")
user["name"] = "John"
email = user["email"]  # Returns "N/A" instead of KeyError
```

### IndexError

**Cause**: List index out of range

**Examples**:
```python
items = [1, 2, 3]
item = items[5]  # IndexError: list index out of range

# Fix: Check length
if len(items) > 5:
    item = items[5]

# Or use try-except
try:
    item = items[5]
except IndexError:
    item = None
```

### ValueError

**Cause**: Correct type but inappropriate value

**Examples**:
```python
# 1. Conversion error
number = int("abc")  # ValueError: invalid literal for int() with base 10: 'abc'

# Fix: Validate before converting
try:
    number = int(value)
except ValueError:
    number = 0  # Default value

# 2. Unpacking error
a, b = [1, 2, 3]  # ValueError: too many values to unpack (expected 2)

# Fix: Match number of values
a, b, c = [1, 2, 3]
# Or use * for remaining
a, b, *rest = [1, 2, 3]  # rest = [3]
```

## Python Debugger (pdb)

### Basic Usage

```python
import pdb

def calculate(x, y):
    result = x + y
    pdb.set_trace()  # Breakpoint here
    return result * 2

calculate(5, 10)
```

**pdb Commands**:
```
n (next)     : Execute next line
s (step)     : Step into function
c (continue) : Continue execution
l (list)     : Show code around current line
p variable   : Print variable value
pp variable  : Pretty-print variable
w (where)    : Show stack trace
u (up)       : Go up in stack
d (down)     : Go down in stack
b linenum    : Set breakpoint at line
cl (clear)   : Clear breakpoints
q (quit)     : Quit debugger
```

### Post-Mortem Debugging

```python
import pdb

try:
    risky_function()
except Exception:
    pdb.post_mortem()  # Start debugger at exception point
```

### Breakpoint (Python 3.7+)

```python
# Instead of import pdb; pdb.set_trace()
def calculate(x, y):
    result = x + y
    breakpoint()  # Built-in breakpoint
    return result * 2
```

## Logging

### Basic Logging

```python
import logging

# Configure logging
logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    filename='app.log'
)

logger = logging.getLogger(__name__)

def process_user(user_id):
    logger.debug(f"Processing user {user_id}")

    try:
        user = get_user(user_id)
        logger.info(f"User found: {user.name}")
        return user
    except Exception as e:
        logger.error(f"Error processing user {user_id}", exc_info=True)
        raise
```

### Log Levels

```python
logger.debug("Detailed information for diagnosing problems")
logger.info("Confirmation that things are working as expected")
logger.warning("Something unexpected happened, but still working")
logger.error("Serious problem, function couldn't complete")
logger.critical("Very serious error, program may crash")
```

### Structured Logging

```python
import logging
import json

class JSONFormatter(logging.Formatter):
    def format(self, record):
        log_data = {
            "timestamp": self.formatTime(record),
            "level": record.levelname,
            "message": record.getMessage(),
            "module": record.module,
            "function": record.funcName,
        }
        if record.exc_info:
            log_data["exception"] = self.formatException(record.exc_info)
        return json.dumps(log_data)

handler = logging.StreamHandler()
handler.setFormatter(JSONFormatter())
logger = logging.getLogger()
logger.addHandler(handler)
```

## Async/Await Debugging

### Common Async Issues

```python
import asyncio

# 1. Forgetting await
async def fetch_data():
    return await api_call()

async def main():
    data = fetch_data()  # Wrong! Returns coroutine, not result
    print(data)  # <coroutine object fetch_data at 0x...>

# Fix: Use await
async def main():
    data = await fetch_data()  # Correct
    print(data)

# 2. RuntimeError: Event loop is closed
# Cause: Trying to run after loop closed
loop = asyncio.get_event_loop()
loop.run_until_complete(main())
loop.close()
loop.run_until_complete(other())  # RuntimeError!

# Fix: Use asyncio.run() (Python 3.7+)
asyncio.run(main())
asyncio.run(other())

# 3. Running blocking code in async
async def slow_function():
    time.sleep(10)  # Blocks entire event loop!
    return "done"

# Fix: Use run_in_executor for blocking calls
import concurrent.futures

async def slow_function():
    loop = asyncio.get_event_loop()
    with concurrent.futures.ThreadPoolExecutor() as pool:
        result = await loop.run_in_executor(pool, blocking_function)
    return result
```

### Debugging Async Code

```python
# Enable debug mode
import asyncio

asyncio.run(main(), debug=True)

# Or
import sys
import logging

logging.basicConfig(level=logging.DEBUG)

# Show pending tasks
async def debug_tasks():
    tasks = asyncio.all_tasks()
    print(f"Pending tasks: {len(tasks)}")
    for task in tasks:
        print(f"  - {task.get_name()}: {task}")
```

## Framework-Specific Debugging

### Django

**Debug Toolbar**:
```python
# settings.py
INSTALLED_APPS = [
    ...
    'debug_toolbar',
]

MIDDLEWARE = [
    ...
    'debug_toolbar.middleware.DebugToolbarMiddleware',
]

INTERNAL_IPS = ['127.0.0.1']
```

**Common Django Errors**:
```python
# 1. DoesNotExist
user = User.objects.get(id=999)  # User.DoesNotExist

# Fix: Use get_object_or_404
from django.shortcuts.get_object_or_404
user = get_object_or_404(User, id=999)

# Or handle exception
try:
    user = User.objects.get(id=999)
except User.DoesNotExist:
    user = None

# 2. MultipleObjectsReturned
user = User.objects.get(is_active=True)  # Returns multiple!

# Fix: Use filter
users = User.objects.filter(is_active=True)
```

### Flask

**Debug Mode**:
```python
# app.py
app = Flask(__name__)
app.config['DEBUG'] = True  # Shows detailed errors
app.run(debug=True)

# Never use in production!
```

**Flask Error Handling**:
```python
@app.errorhandler(404)
def not_found(error):
    return {"error": "Not found"}, 404

@app.errorhandler(500)
def internal_error(error):
    db.session.rollback()
    return {"error": "Internal server error"}, 500
```

## Performance Debugging

### Using cProfile

```python
import cProfile
import pstats

# Profile function
profiler = cProfile.Profile()
profiler.enable()

slow_function()

profiler.disable()
stats = pstats.Stats(profiler)
stats.sort_stats('cumulative')
stats.print_stats(20)  # Top 20 slowest functions
```

### Memory Profiling

```python
# Install: pip install memory_profiler

from memory_profiler import profile

@profile
def memory_hungry_function():
    big_list = [i for i in range(1000000)]
    return sum(big_list)

# Run: python -m memory_profiler script.py
```

### Line Profiler

```python
# Install: pip install line_profiler

@profile
def slow_function():
    total = 0
    for i in range(1000000):  # Which line is slow?
        total += i * 2
    return total

# Run: kernprof -l -v script.py
```

## Best Practices

### Use Type Hints

```python
from typing import List, Optional, Dict

def process_users(user_ids: List[int]) -> Dict[int, str]:
    """Type hints help catch errors early."""
    return {uid: f"User {uid}" for uid in user_ids}

# Use mypy for type checking
# mypy script.py
```

### Assertions for Debugging

```python
def calculate_discount(price: float, discount: float) -> float:
    assert 0 <= discount <= 1, f"Discount must be 0-1, got {discount}"
    assert price >= 0, f"Price must be positive, got {price}"

    return price * (1 - discount)

# Assertions are removed in production if run with -O flag
# python -O script.py
```

### Exception Chaining

```python
try:
    result = risky_operation()
except ValueError as e:
    # Chain exceptions to preserve context
    raise ProcessingError("Failed to process data") from e
```

### Context Managers for Cleanup

```python
# Ensure cleanup even if exception occurs
with open('file.txt') as f:
    data = f.read()  # File auto-closed even if exception

# Custom context manager
from contextlib import contextmanager

@contextmanager
def debug_context(name):
    print(f"Entering {name}")
    try:
        yield
    finally:
        print(f"Exiting {name}")

with debug_context("processing"):
    process_data()
```

## Tools

- **pdb**: Built-in Python debugger
- **ipdb**: IPython-enhanced debugger
- **pudb**: Full-screen console debugger
- **PyCharm Debugger**: IDE debugger
- **VS Code Python Debugger**: IDE debugger
- **pytest**: Testing framework with great error messages
- **mypy**: Static type checker
- **pylint/flake8**: Linters to catch common issues

## Quick Reference

| Error | Common Cause | Quick Fix |
|-------|--------------|-----------|
| ImportError | Module not found | pip install, check venv |
| AttributeError | Wrong attribute or None | Check object type, use hasattr() |
| TypeError | Type mismatch | Convert types, check function signature |
| IndentationError | Mixed tabs/spaces | Use 4 spaces consistently |
| KeyError | Missing dict key | Use .get() with default |
| IndexError | List index out of range | Check list length first |
| ValueError | Invalid value | Validate input, use try-except |
| NameError | Variable not defined | Check spelling, scope |
| RecursionError | Infinite recursion | Add base case to recursive function |
