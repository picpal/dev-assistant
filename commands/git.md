---
description: Manage git operations including commits, branches, and history
argument-hint: "[operation or description]"
allowed-tools: Task, Bash, Grep, Read
model: sonnet
---

# Git Command

Manages git operations with safety checks and best practices. Provides standalone git assistance by analyzing repository state directly.

## Usage

```bash
/git status                    # Comprehensive status analysis
/git commit                    # Generate conventional commit message
/git branch <name>             # Create and switch to new branch
/git cleanup                   # Clean up merged/stale branches
/git analyze                   # Repository health analysis
/git conflict                  # Help resolve merge conflicts
/git history                   # View and analyze commit history
/git sync                      # Sync current branch with main
```

## Workflow

**CRITICAL**: Immediately invoke the git-manager tactical agent. DO NOT manually execute git commands yourself.

**Actions**:

1. **Invoke git-manager agent immediately**:
   ```
   Use Task tool:
   - subagent_type: "git-manager"
   - prompt: Complete user request with operation and arguments
   - description: Short summary (e.g., "Generate commit message", "Create branch")
   ```

   **Examples**:
   - User: `/git commit` → `Task(subagent_type="git-manager", prompt="Generate conventional commit message for current staged changes", description="Generate commit message")`
   - User: `/git branch feature/auth` → `Task(subagent_type="git-manager", prompt="Create and switch to branch feature/auth", description="Create feature branch")`
   - User: `/git status` → `Task(subagent_type="git-manager", prompt="Provide comprehensive repository status analysis", description="Analyze git status")`
   - User: `/git conflict` → `Task(subagent_type="git-manager", prompt="Help resolve current merge conflicts", description="Resolve conflicts")`

2. **Agent handles everything**:
   - Gathers all git repository state independently
   - Analyzes current situation and plans operation
   - Performs comprehensive safety checks
   - Executes git commands with proper error handling
   - Provides guidance and teaches best practices
   - Shows before/after state comparison

**DO NOT**:
- ❌ Manually run git commands (git status, git diff, etc.)
- ❌ Gather repository state yourself
- ❌ Execute git operations directly
- ❌ Present your own git analysis

**ALWAYS**:
- ✅ Invoke git-manager agent immediately
- ✅ Pass complete user request as prompt
- ✅ Let agent handle all git operations
- ✅ Trust agent's comprehensive workflow

## Common Operations

### Commit Message Generation

```bash
/git commit
```

Analyzes staged changes and generates a conventional commit message based on the type and scope of modifications.

### Branch Management

```bash
/git branch feature/user-auth     # Create and switch to new branch
/git branch                       # Show branch status and tracking
/git cleanup                      # Remove merged/stale branches
```

### Conflict Resolution

```bash
/git conflict
```

Detects merge/rebase conflicts, explains the conflict context, and suggests resolution strategies.

### Repository Analysis

```bash
/git analyze       # Repository health check
/git history       # Commit history analysis
/git status        # Comprehensive status overview
```

### Sync with Main

```bash
/git sync         # Sync current branch with main branch
```

Provides options to merge or rebase current branch with latest main branch changes.

## Safety Features

The git agent includes comprehensive safety mechanisms:

- **Pre-flight Checks**: Verifies repository state before destructive operations
- **Uncommitted Changes Warning**: Alerts when changes would be lost
- **Force Operation Confirmation**: Requires explicit approval for force push, hard reset
- **Branch Protection**: Warns when operating on main/master branches
- **History Rewriting Alerts**: Notifies when operations rewrite published history

## Examples

### Example 1: Generate Commit Message

```
User: /git commit

Agent:
1. Checks git status and staged changes
2. Analyzes modified files and changes
3. Determines commit type (feat/fix/docs/etc)
4. Generates conventional commit message
5. Shows message with explanation
```

### Example 2: Clean Up Branches

```
User: /git cleanup

Agent:
1. Lists all local branches
2. Identifies merged branches
3. Identifies branches with deleted remotes
4. Shows safe-to-delete list
5. Executes cleanup with user confirmation
```

### Example 3: Resolve Conflicts

```
User: /git conflict

Agent:
1. Detects conflicted files
2. Shows conflict markers and context
3. Explains "ours" vs "theirs"
4. Suggests resolution strategies
5. Helps complete resolution
```

### Example 4: Repository Analysis

```
User: /git analyze

Agent:
1. Analyzes commit history and patterns
2. Identifies frequent contributors
3. Checks for large files or issues
4. Examines branch structure
5. Generates health report
```

## Best Practices

The git agent follows and teaches these best practices:

### Commits
- Use conventional commit format
- Atomic, logical commits
- Clear, descriptive messages
- Test before committing

### Branches
- Descriptive branch names (feature/, fix/, etc.)
- Delete merged branches
- Keep branches short-lived
- Sync regularly with main

### History
- Keep history clean and linear
- Avoid rewriting published history
- Use meaningful merge messages
- Squash fixup commits before merging

### Safety
- Check status before operations
- Warn on destructive actions
- Explain risks clearly
- Provide safer alternatives

## Notes

- Git agent operates **independently** without requiring conversation context
- All information is gathered directly from **git repository state**
- Language-independent (works with any project language)
- Focuses on **teaching** git concepts, not just executing commands
- Includes **comprehensive safety checks** to prevent data loss
