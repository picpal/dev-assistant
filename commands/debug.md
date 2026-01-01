---
description: Analyze and fix errors using the debugger agent
argument-hint: "[error description or file path]"
allowed-tools: Task, Glob, Grep, Read, Bash, LSP
model: sonnet
---

# Debug Command

Analyzes errors, exceptions, and stack traces to identify root causes and suggest fixes.

## Usage

```bash
/debug [error description]
/debug path/to/file.java:42
/debug "NullPointerException in UserService"
```

## Workflow

1. **Collect Error Information**
   - Read user-provided error message or stack trace
   - If file path provided, read the file
   - Gather context (recent changes, related files)

2. **Invoke Debugger Agent**
   - Launch `debugger` sub-agent with error information
   - Agent analyzes error using language-specific patterns
   - Agent identifies root cause

3. **Present Solution**
   - Show immediate fix with code examples
   - Explain prevention strategies
   - Suggest tests to prevent regression

4. **Verify (Optional)**
   - Offer to apply fix
   - Run tests if available
   - Confirm error is resolved

## Example

```
User: /debug NullPointerException in UserService.java line 42