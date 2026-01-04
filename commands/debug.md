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

**CRITICAL**: Immediately invoke the debugger tactical agent. DO NOT manually analyze errors yourself.

**Actions**:

1. **Invoke debugger agent immediately**:
   ```
   Use Task tool:
   - subagent_type: "debugger"
   - prompt: Complete user request with error description and context
   - description: Short summary (e.g., "Debug NullPointerException", "Fix runtime error")
   ```

   **Examples**:
   - User: `/debug NullPointerException in UserService.java line 42` → `Task(subagent_type="debugger", prompt="Analyze NullPointerException in UserService.java:42", description="Debug NullPointerException")`
   - User: `/debug "TypeError: Cannot read property 'id' of undefined"` → `Task(subagent_type="debugger", prompt="Debug TypeError: Cannot read property 'id' of undefined", description="Fix TypeError")`

2. **Agent handles everything**:
   - Gathers error context and stack traces
   - Reads relevant files and code
   - Analyzes using language-specific patterns
   - Identifies root cause
   - Presents solution with code examples
   - Suggests prevention strategies and tests

**DO NOT**:
- ❌ Manually read error files
- ❌ Analyze stack traces yourself
- ❌ Propose fixes directly

**ALWAYS**:
- ✅ Invoke debugger agent immediately
- ✅ Pass complete error information
- ✅ Let agent handle root cause analysis

## Example

```
User: /debug NullPointerException in UserService.java line 42