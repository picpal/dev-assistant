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

1. **Determine Scope**
   - Parse target from arguments (file/directory/all)
   - Find relevant source files
   - Count files and lines

2. **Invoke Code-Quality Agent**
   - Launch `code-quality` sub-agent
   - Agent scans code structure
   - Agent identifies issues

3. **Analyze**
   - Check file/class sizes
   - Calculate cyclomatic complexity
   - Detect code smells
   - Identify SOLID violations

4. **Generate Report**
   - List critical issues (fix immediately)
   - List warnings (fix soon)
   - Provide suggestions (consider)
   - Show before/after examples
   - Prioritize improvements

## Example

```
User: /quality src/services/UserService.java