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

**CRITICAL**: Immediately invoke the performance-analyzer tactical agent. DO NOT manually analyze performance yourself.

**Actions**:

1. **Invoke performance-analyzer agent immediately**:
   ```
   Use Task tool:
   - subagent_type: "performance-analyzer"
   - prompt: Complete user request with performance issue
   - description: Short summary (e.g., "Optimize database queries", "Fix memory leak")
   ```

   **Examples**:
   - User: `/perf UserService slow query` → `Task(subagent_type="performance-analyzer", prompt="Analyze and optimize slow database queries in UserService", description="Optimize database queries")`
   - User: `/perf React component re-rendering` → `Task(subagent_type="performance-analyzer", prompt="Analyze React component re-rendering performance issues", description="Fix re-rendering")`
   - User: `/perf memory leak` → `Task(subagent_type="performance-analyzer", prompt="Detect and fix memory leak in application", description="Fix memory leak")`

2. **Agent handles everything**:
   - Identifies performance issue and technology
   - Profiles application (JVM/Python/React)
   - Identifies bottlenecks
   - Analyzes root cause
   - Provides optimized code examples
   - Estimates impact and effort
   - Suggests monitoring metrics

**DO NOT**:
- ❌ Manually profile application
- ❌ Analyze bottlenecks yourself
- ❌ Propose optimizations directly

**ALWAYS**:
- ✅ Invoke performance-analyzer agent immediately
- ✅ Pass complete performance issue description
- ✅ Let agent handle profiling and optimization

## Example

```
User: /perf slow database queries in UserService