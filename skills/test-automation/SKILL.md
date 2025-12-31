---
name: test-automation
description: Testing patterns and best practices for JUnit 5, pytest, and Jest/React Testing Library
trigger: When creating or improving tests
---

# Test Automation Skill

This skill provides comprehensive testing patterns for automated testing across Java, Python, and TypeScript/React environments.

## Purpose

Enable developers to write effective, maintainable tests that provide confidence for refactoring and prevent regressions.

## Coverage

- **Java/JUnit 5**: Unit tests, integration tests, mocking with Mockito
- **Python/pytest**: Fixtures, parametrization, mocking
- **TypeScript/Jest/RTL**: Component tests, hook tests, async testing

## When to Use

- Writing new tests
- Improving test coverage
- Understanding testing best practices
- Debugging test failures
- Structuring test suites

## Reference Files

### junit-patterns.md
JUnit 5 and Spring Boot testing:
- Unit test patterns with Mockito
- Spring Boot integration tests
- Test structure (AAA pattern)
- Assertions with AssertJ
- Parametrized tests
- Test organization

### pytest-patterns.md
pytest testing patterns:
- Fixture usage and scoping
- Parametrized tests
- Mocking and patching
- Async test support
- Marks and test organization
- Django/Flask testing

### jest-patterns.md
Jest and React Testing Library:
- Component testing
- Hook testing
- Async testing
- Mocking (modules, APIs, timers)
- Snapshot testing
- Testing best practices

## Testing Principles

1. **Arrange-Act-Assert (AAA)**: Structure tests consistently
2. **Independence**: Each test should run independently
3. **Fast**: Tests should run quickly
4. **Deterministic**: Same input = same output
5. **Readable**: Tests are documentation

## Integration with Tester Agent

This skill provides knowledge that the `tester` agent uses to:
- Generate appropriate test structures
- Follow framework-specific best practices
- Create meaningful test cases
- Organize tests effectively

## Related Skills

- **debugging-patterns**: Debug failing tests
- **quality-standards**: Improve testability of code
- **documentation-guides**: Document test scenarios
