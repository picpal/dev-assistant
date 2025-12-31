---
name: debugging-patterns
description: Multi-language debugging patterns and best practices for Java/Spring Boot, Python, and TypeScript/React
trigger: When debugging errors or analyzing stack traces
---

# Debugging Patterns Skill

This skill provides comprehensive debugging patterns and troubleshooting guides for multi-language environments.

## Purpose

Help developers quickly identify and fix bugs using language-specific debugging techniques and common error patterns.

## Coverage

- **Java/Spring Boot**: Exception patterns, Spring-specific issues, JVM debugging
- **Python**: Error types, debugging tools, common pitfalls
- **JavaScript/TypeScript/React**: Browser debugging, async issues, React-specific bugs

## When to Use

- Analyzing stack traces and error messages
- Debugging runtime exceptions
- Troubleshooting framework-specific issues
- Understanding common error patterns
- Learning debugging best practices

## Reference Files

### java-debugging.md
Comprehensive guide for Java and Spring Boot debugging:
- Common exception types and solutions
- Spring Boot specific issues (bean injection, configuration)
- JVM debugging techniques
- IDE debugging tips
- Logging best practices

### python-debugging.md
Python debugging patterns and techniques:
- Common Python errors (ImportError, AttributeError, etc.)
- pdb debugger usage
- Logging and tracing
- Async/await debugging
- Framework-specific issues (Django, Flask)

### javascript-debugging.md
JavaScript/TypeScript/React debugging guide:
- Browser DevTools usage
- Common JavaScript errors
- TypeScript type errors
- React debugging (hooks, state, props)
- Async debugging
- Performance debugging

## Usage Examples

### Debugging a NullPointerException in Spring Boot
```
1. Read stack trace to identify location
2. Check java-debugging.md for NPE patterns
3. Look for null returns, missing @Autowired, or Optional misuse
4. Apply appropriate fix (null checks, Optional, or dependency injection)
```

### Debugging ImportError in Python
```
1. Check error message for module name
2. Consult python-debugging.md for import issues
3. Verify virtual environment, PYTHONPATH, and package installation
4. Check for circular imports
```

### Debugging React useEffect infinite loop
```
1. Identify which useEffect is causing the issue
2. Check javascript-debugging.md for React patterns
3. Review dependency array
4. Apply fix (add dependencies, memoize, or restructure)
```

## Best Practices

1. **Read Error Messages Carefully**: Error messages contain critical information
2. **Use Stack Traces**: Navigate from error to root cause
3. **Reproduce Consistently**: Understand conditions that trigger the bug
4. **Use Debuggers**: Step through code rather than guessing
5. **Log Strategically**: Add logging at decision points
6. **Test Hypotheses**: Make one change at a time and verify

## Integration with Debugger Agent

This skill complements the `debugger` agent by providing:
- Language-specific debugging knowledge
- Common error pattern recognition
- Debugging tool usage guides
- Best practice recommendations

The debugger agent uses this skill's knowledge to analyze errors and suggest fixes.

## Related Skills

- **test-automation**: Create tests to prevent regression
- **quality-standards**: Improve code to prevent bugs
- **documentation-guides**: Document debugging solutions

## Maintenance

Update reference files when:
- New language versions introduce changes
- Framework versions have breaking changes
- New common error patterns emerge
- Better debugging techniques are discovered
