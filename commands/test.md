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

1. **Identify Test Target**
   - Parse target file/class from arguments
   - Detect language (Java/Python/TypeScript)
   - Find existing test patterns

2. **Invoke Tester Agent**
   - Launch `tester` sub-agent
   - Agent analyzes code structure
   - Agent generates appropriate tests (JUnit/pytest/Jest)

3. **Create Tests**
   - Generate test file following conventions
   - Include unit tests for public methods
   - Add edge cases and error scenarios
   - Use mocking for dependencies

4. **Execute Tests**
   - Run test framework (gradle test / pytest / npm test)
   - Display results and coverage
   - Suggest improvements

## Example

```
User: /test UserService.java