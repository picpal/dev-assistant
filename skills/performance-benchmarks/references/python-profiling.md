# Python Performance Optimization

## CPU Profiling with cProfile

```python
import cProfile
import pstats

profiler = cProfile.Profile()
profiler.enable()

# Your code here
result = expensive_function()

profiler.disable()
stats = pstats.Stats(profiler)
stats.sort_stats('cumulative')
stats.print_stats(20)  # Top 20 slowest
```

## Memory Profiling

```python
from memory_profiler import profile

@profile
def memory_intensive():
    data = [i for i in range(1000000)]
    return sum(data)

# Run: python -m memory_profiler script.py
```

## Common Optimizations

### Use Generators
```python
# Memory efficient for large datasets
def process_large_file(filename):
    with open(filename) as f:
        for line in f:  # Generator
            yield process_line(line)
```

### List Comprehensions Over Loops
```python
# Fast
squares = [x**2 for x in range(1000)]

# Slower
squares = []
for x in range(1000):
    squares.append(x**2)
```

### Use Appropriate Data Structures
```python
# O(1) lookup
if item in my_set:  # Fast
    pass

# O(n) lookup
if item in my_list:  # Slow for large lists
    pass
```

## Async Optimization

```python
import asyncio

# Sequential (slow)
async def fetch_all_sequential():
    data1 = await fetch1()
    data2 = await fetch2()
    return data1, data2

# Parallel (fast)
async def fetch_all_parallel():
    data1, data2 = await asyncio.gather(
        fetch1(),
        fetch2()
    )
    return data1, data2
```

## Django ORM Optimization

```python
# Avoid N+1 queries
users = User.objects.select_related('profile').all()
users = User.objects.prefetch_related('orders').all()

# Index database fields
class User(models.Model):
    email = models.EmailField(db_index=True)
```
