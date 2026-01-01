---
description: Analyze and optimize performance using the performance-analyzer agent
argument-hint: "[component or issue to analyze]"
allowed-tools: Task, Glob, Grep, Read, Bash, LSP, WebSearch
model: sonnet
---

# Perf Command

Profiles application performance and suggests optimizations.

## Usage

```bash
/perf UserService slow query
/perf React component re-rendering
/perf memory leak
/perf  # General performance analysis
```

## Workflow

1. **Identify Performance Issue**
   - Parse performance concern from arguments
   - Determine technology (Java/Python/React)
   - Identify symptoms (slow, memory, CPU)

2. **Invoke Performance-Analyzer Agent**
   - Launch `performance-analyzer` sub-agent
   - Agent profiles application
   - Agent identifies bottlenecks

3. **Analyze**
   - JVM: Check heap, GC, N+1 queries, connection pools
   - Python: CPU profiling, memory profiling, async issues
   - React: Bundle size, rendering, memoization

4. **Generate Optimization Plan**
   - Show current performance metrics
   - Identify root cause
   - Provide optimized code examples
   - Estimate impact and effort
   - Suggest monitoring metrics

## Example

```
User: /perf slow database queries in UserService