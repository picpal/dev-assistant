---
description: Analyze code quality using the code-quality agent
argument-hint: "[file or directory to analyze]"
allowed-tools: Task, Glob, Grep, Read, LSP, Bash, WebSearch
model: sonnet
---

# Quality Command

Analyzes code maintainability, identifies code smells, and suggests refactoring.

## Usage

```bash
/quality UserService.java
/quality src/services/
/quality  # Analyze entire codebase
```

## Workflow

**CRITICAL**: Immediately invoke the code-quality tactical agent. DO NOT manually analyze code yourself.

**Actions**:

1. **Invoke code-quality agent immediately**:
   ```
   Use Task tool:
   - subagent_type: "code-quality"
   - prompt: Complete user request with analysis target
   - description: Short summary (e.g., "Analyze UserService quality", "Check code quality")
   ```

   **Examples**:
   - User: `/quality UserService.java` → `Task(subagent_type="code-quality", prompt="Analyze code quality of UserService.java and suggest improvements", description="Analyze UserService quality")`
   - User: `/quality src/services/` → `Task(subagent_type="code-quality", prompt="Analyze code quality in src/services/ directory", description="Analyze services quality")`
   - User: `/quality` → `Task(subagent_type="code-quality", prompt="Analyze entire codebase quality and identify issues", description="Analyze codebase quality")`

2. **Agent handles everything**:
   - Determines analysis scope
   - Scans code structure
   - Checks file/class sizes and complexity
   - Detects code smells and SOLID violations
   - Generates prioritized report
   - Shows before/after examples

**DO NOT**:
- ❌ Manually find source files
- ❌ Calculate complexity yourself
- ❌ Analyze code structure directly

**ALWAYS**:
- ✅ Invoke code-quality agent immediately
- ✅ Pass complete analysis requirements
- ✅ Let agent handle quality analysis

## Example

```
User: /quality src/services/UserService.java