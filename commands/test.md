---
description: Create and run tests using the tester agent
argument-hint: "[file or class to test]"
allowed-tools: Task, Glob, Grep, Read, Write, Edit, Bash, LSP
model: sonnet
---

# Test Command

Generates tests and executes test suites for Java, Python, and TypeScript code.

## Usage

```bash
/test UserService.java
/test src/services/user.py
/test UserProfile.tsx
/test  # Run all tests
```

## Workflow

**CRITICAL**: Immediately invoke the tester tactical agent. DO NOT manually create tests yourself.

**Actions**:

1. **Invoke tester agent immediately**:
   ```
   Use Task tool:
   - subagent_type: "tester"
   - prompt: Complete user request with test target and requirements
   - description: Short summary (e.g., "Generate UserService tests", "Run all tests")
   ```

   **Examples**:
   - User: `/test UserService.java` → `Task(subagent_type="tester", prompt="Generate comprehensive tests for UserService.java", description="Generate UserService tests")`
   - User: `/test src/services/user.py` → `Task(subagent_type="tester", prompt="Create pytest tests for user.py", description="Create Python tests")`
   - User: `/test` → `Task(subagent_type="tester", prompt="Run all project tests and report results", description="Run all tests")`

2. **Agent handles everything**:
   - Identifies test target and detects language
   - Finds existing test patterns
   - Generates appropriate tests (JUnit/pytest/Jest)
   - Includes edge cases and mocking
   - Executes test framework
   - Reports results and coverage

**DO NOT**:
- ❌ Manually detect language or patterns
- ❌ Write test code directly
- ❌ Run test commands yourself

**ALWAYS**:
- ✅ Invoke tester agent immediately
- ✅ Pass complete test requirements
- ✅ Let agent handle test generation and execution

## Example

```
User: /test UserService.java