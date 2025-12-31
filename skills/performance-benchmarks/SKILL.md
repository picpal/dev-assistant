---
name: performance-benchmarks
description: Performance optimization techniques for JVM, Python, and React applications
trigger: When analyzing or optimizing performance
---

# Performance Benchmarks Skill

Performance optimization patterns and profiling techniques for Java/Spring Boot, Python, and React/TypeScript applications.

## Purpose

Provide practical guidance for identifying and resolving performance bottlenecks across different technology stacks.

## Coverage

- **JVM Tuning**: Heap sizing, GC selection, JVM flags
- **Python Profiling**: cProfile, memory profiling, async optimization
- **React Optimization**: Bundle size, rendering, memoization

## Reference Files

- `jvm-tuning.md`: JVM configuration and garbage collection optimization
- `python-profiling.md`: Python performance analysis and optimization
- `react-optimization.md`: React and TypeScript performance patterns

## Key Metrics

- Response time (< 1s for APIs)
- Memory usage (no leaks)
- CPU utilization (< 80% sustained)
- Bundle size (< 500KB initial load)
- Time to Interactive (< 3s)

## Integration with Performance-Analyzer Agent

Provides optimization knowledge that the `performance-analyzer` agent uses when profiling and optimizing applications.
