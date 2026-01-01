# dev-assistant

> AI-powered development assistant combining structured feature workflows with tactical development tools for Java/Spring Boot, Python, and TypeScript/React

## Overview

**dev-assistant** is a comprehensive Claude Code plugin that combines:
- **Structured 7-phase feature development workflow** with parallel agent execution and user approval gates
- **Quick tactical commands** for debugging, testing, documentation, quality analysis, and performance profiling
- **Multi-language support** with automatic detection and language-specific patterns

### Supported Languages & Frameworks

- **Java**: Spring Boot, Gradle, Maven, JUnit 5
- **Python**: Flask, FastAPI, Django, pytest
- **TypeScript/React**: Next.js, Jest, React Testing Library

---

## Features

### 🏗️ Main Workflow: `/build`

A comprehensive 7-phase workflow for feature development:

```
1. Discovery → 2. Exploration → 3. Questions → 4. Architecture → 5. Implementation → 6. Review → 7. Summary
              (2-3 agents)      (Gate #1)    (3 agents)       (Gate #3)       (3 agents)
                                              (Gate #2)                        (Gate #4)
```

#### The 7 Phases:

1. **Discovery** - Clarify requirements and detect project language
2. **Exploration** - Parallel code analysis with 2-3 code-explorer agents
3. **Questions** - Fill gaps with clarifying questions (**User Approval Gate #1**)
4. **Architecture** - Design 3 approaches in parallel: Minimal/Clean/Pragmatic (**User Selection Gate #2**)
5. **Implementation** - Build the feature with auto-formatting (**User Approval Gate #3**)
6. **Review** - Multi-perspective code review with confidence ≥80 filtering (**User Decision Gate #4**)
7. **Summary** - Document what was built and next steps

#### Key Capabilities:

- ⚡ **Parallel agent execution**: 2.5x-3x faster in Phases 2, 4, 6
- 🎯 **Confidence-based filtering**: Only show findings with ≥80% confidence (reduces noise)
- 🚪 **4 user approval gates**: Careful, deliberate development with user control
- 🎨 **Auto-format hooks**: Automatic formatting for Java, Python, TypeScript
- 🌍 **Multi-language aware**: Detects and adapts to project language
- 🏛️ **3 architectural approaches**: Choose between Minimal (fast), Clean (maintainable), or Pragmatic (balanced)

---

### ⚡ Quick Commands

Perfect for daily development tasks without the full workflow overhead.

#### `/debug` - Error Analysis & Fixing
```bash
/debug "NullPointerException in UserService.java:42"
/debug <paste stack trace>
```
- Multi-language error analysis (Java/Python/TypeScript)
- Stack trace interpretation with file:line references
- Root cause identification
- Immediate fix suggestions with before/after code
- Prevention strategies

#### `/test` - Test Generation & Execution
```bash
/test UserService.java
/test LoginForm.tsx
```
- Framework-aware test generation (JUnit 5, pytest, Jest)
- AAA pattern (Arrange-Act-Assert)
- Mocking and fixtures
- Coverage reporting
- Run tests automatically

#### `/doc` - Documentation Search
```bash
/doc "Spring Boot connection pooling"
/doc "React useEffect cleanup"
```
- Local documentation search (README, docstrings)
- Online official docs (spring.io, python.org, react.dev)
- API signatures and examples
- Fast results (haiku model for speed)

#### `/quality` - Code Quality Analysis
```bash
/quality src/services/
/quality UserController.java
```
- SOLID principle checking
- Code smell detection
- Cyclomatic complexity calculation
- Refactoring suggestions
- Prioritized improvement roadmap

#### `/perf` - Performance Profiling
```bash
/perf database queries
/perf React component rendering
```
- Language-specific profiling (JVM, cProfile, React DevTools)
- Bottleneck identification (N+1 queries, re-renders, memory leaks)
- Optimization suggestions with impact estimates
- Monitoring metrics recommendations

---

## Architecture

### 8 Specialized Agents

#### Workflow Agents (Parallelized for Speed)
- **code-explorer** - Codebase discovery and pattern recognition
  - Launched 2-3 in parallel during Phase 2
  - Returns 5-10 key files to read
  - Language-specific exploration patterns

- **code-architect** - Multi-approach architecture design
  - Launched 3 in parallel during Phase 4 (Minimal/Clean/Pragmatic)
  - Provides implementation blueprints
  - Trade-off analysis for each approach

- **code-reviewer** - Quality review with confidence scoring
  - Launched 3 in parallel during Phase 6 (Simplicity/Bugs/Conventions)
  - Confidence-based filtering (≥80 only)
  - Multi-perspective analysis

#### Tactical Agents (Quick Single-Instance Execution)
- **debugger** - Error analysis and fixing for Java/Python/TypeScript
- **tester** - Test automation and generation
- **doc-reference** - Documentation search (uses haiku for speed)
- **code-quality** - Maintainability and SOLID analysis
- **performance-analyzer** - Performance profiling and optimization

### 6 Skills (Knowledge Bases)

Comprehensive reference material for all agents:

- **`architecture-patterns`** - Design approaches (Minimal/Clean/Pragmatic), trade-off analysis, multi-language patterns
- **`debugging-patterns`** - Multi-language error patterns and debugging techniques
- **`test-automation`** - Testing framework best practices (JUnit/pytest/Jest)
- **`documentation-guides`** - Documentation standards (Javadoc/Sphinx/JSDoc)
- **`quality-standards`** - SOLID principles and best practices
- **`performance-benchmarks`** - Optimization techniques and profiling

### 6 Commands

- **1 Main Workflow**: `/build` (7-phase feature development)
- **5 Quick Commands**: `/debug`, `/test`, `/doc`, `/quality`, `/perf`

---

## Installation

### Prerequisites

- **Claude Code CLI** (version ≥1.0.0)
- **Git** (for cloning and updates)
- **Language-specific formatters** (optional but recommended):
  - Java: `google-java-format` or Gradle Spotless
  - Python: `black`, `isort`
  - TypeScript: `prettier`

### Install Plugin

```bash
# Clone the plugin to your home directory
cd ~
git clone <repository-url> dev-assistant

# Configure Claude to use the plugin
mkdir -p ~/.claude
cat >> ~/.claude/settings.json << 'EOF'
{
  "pluginDirectories": [
    "~/dev-assistant"
  ]
}
EOF

# Restart Claude Code
```

**If `~/.claude/settings.json` already exists:**

Edit the file manually and add `~/dev-assistant` to the `pluginDirectories` array:

```json
{
  "pluginDirectories": [
    "~/dev-assistant",
    "~/other-plugin"
  ]
}
```

For detailed installation instructions, troubleshooting, and team setup, see [INSTALLATION.md](./INSTALLATION.md).

---

## Quick Start

### Example 1: Building a New Feature

```bash
/build Add user authentication with JWT tokens
```

**The workflow will:**
1. ✅ Detect your project language (Java/Python/TypeScript)
2. ⚡ Launch 2-3 code-explorer agents in parallel to understand your codebase
3. ❓ Ask clarifying questions about auth requirements (wait for your answers)
4. 🏛️ Present 3 architecture approaches:
   - **Minimal**: Quick JWT implementation with session storage (2-3 hours)
   - **Clean**: Full auth service with strategy pattern (2-3 days)
   - **Pragmatic**: Balanced approach with easy extensibility (1-2 days)
5. 🛠️ Implement your chosen approach with auto-formatting
6. 🔍 Review with 3 parallel reviewers (Simplicity/Bugs/Conventions, confidence ≥80)
7. 📄 Summarize changes and suggest next steps

### Example 2: Quick Debugging

```bash
/debug "NullPointerException at UserService.java:42"
```

**You'll get:**
- Root cause analysis (e.g., "Optional.get() called on empty Optional")
- Immediate fix with before/after code
- Prevention strategy (e.g., "Use Optional.map() or orElseThrow()")
- Recommended tests to add

### Example 3: Generate Tests

```bash
/test src/services/UserService.java
```

**You'll get:**
- JUnit 5 tests with @Test annotations
- Mocking setup with Mockito
- AAA pattern (Arrange-Act-Assert)
- Edge case coverage
- Ready to run tests

---

## When to Use What?

### Use `/build` workflow when:
- ✅ Building complete new features
- ✅ Initializing greenfield projects
- ✅ Complex changes requiring architectural decisions
- ✅ You want structured guidance and code review
- ✅ You need to evaluate multiple approaches (Minimal/Clean/Pragmatic)

### Use quick commands when:
- ⚡ Debugging specific errors (`/debug`)
- ⚡ Adding tests to existing code (`/test`)
- ⚡ Looking up documentation (`/doc`)
- ⚡ Analyzing specific modules (`/quality`)
- ⚡ Profiling specific performance issues (`/perf`)

**Rule of thumb**: Use `/build` for strategic work, quick commands for tactical work.

---

## Key Features

### 🌍 Multi-Language Support

Automatically detects and adapts to your project:

**Java/Spring Boot:**
- Layered architecture (Controller → Service → Repository)
- Spring annotations and dependency injection
- JUnit 5 + Mockito tests
- Google Java Format or Spotless

**Python:**
- FastAPI/Flask/Django patterns
- Type hints and Pydantic validation
- pytest with fixtures
- Black + isort formatting

**TypeScript/React:**
- Functional components with hooks
- TypeScript strict mode
- Jest + React Testing Library
- Prettier formatting

### ⚡ Parallel Agent Execution

Phases 2, 4, and 6 run multiple agents simultaneously:

```
Phase 2: 2-3 code-explorer agents    → 2.5x faster
Phase 4: 3 code-architect agents     → 3x faster
Phase 6: 3 code-reviewer agents      → 3x faster
```

### 🎯 Confidence-Based Filtering

Code reviewers score findings 0-100. Only issues with confidence ≥80 are shown:

```
0-25:  Not confident / False positive
25-50: Might be real / Minor nitpick
50-75: Real but not critical
75-90: Highly confident / Important
90-100: Absolutely certain / Critical
```

This reduces noise and focuses on real problems.

### 🚪 User Approval Gates

4 critical decision points where you stay in control:

1. **Gate #1 (Phase 3)**: Answer clarifying questions
2. **Gate #2 (Phase 4)**: Select architecture approach (Minimal/Clean/Pragmatic)
3. **Gate #3 (Phase 5)**: Approve implementation start
4. **Gate #4 (Phase 6)**: Decide on review findings (fix now/later/proceed)

### 🎨 Auto-Format Hooks

Code is automatically formatted after Edit/Write operations:

- **Java**: Spotless or google-java-format
- **Python**: black + isort
- **TypeScript**: prettier

Configure formatters via project config files (`.prettierrc`, `pyproject.toml`, etc.).

---

## Templates

### Greenfield Project Templates

Start new projects with best practices:

- **Java/Spring Boot**: Gradle, JPA, Security, Flyway migrations
- **Python/FastAPI**: Poetry, SQLAlchemy, Alembic, async support
- **TypeScript/React**: Vite, React Router, TypeScript strict mode

See `templates/greenfield/` for project structures.

### Feature Templates

Common feature patterns with multi-language examples:

- CRUD operations
- Authentication & Authorization
- File upload & storage
- Pagination & filtering
- Background jobs
- Real-time updates (WebSocket/SSE)
- Search functionality
- Caching layer
- Rate limiting
- Audit logging

See `templates/feature-templates/` for implementation guides.

---

## Development Status

### ✅ Completed (v1.0)

- ✅ **Week 1**: Core infrastructure (hooks, utils, plugin config)
- ✅ **Week 2-3**: Workflow agents (code-explorer, code-architect, code-reviewer)
- ✅ **Week 4**: Tactical agents (debugger, tester, doc-reference, code-quality, performance-analyzer)
- ✅ **Week 5**: Commands (`/build` workflow + 5 tactical commands)
- ✅ **Week 6**: Templates (greenfield + feature templates)

### 🚧 Ongoing

- 🚧 **Week 7**: Integration testing and real-world validation
- 🚧 **Week 8**: Extended documentation and examples

### 📊 Statistics

- **46 files** created
- **11,435 lines** of code
- **8 specialized agents** (3 workflow + 5 tactical)
- **6 commands** (1 main + 5 quick)
- **6 comprehensive skills**
- **3 languages** fully supported

---

## Key Differentiators

### vs feature-dev Plugin

- ✅ **Multi-language support**: Java/Python/TypeScript (feature-dev is language-agnostic)
- ✅ **Quick tactical commands**: 5 fast commands for daily tasks
- ✅ **Auto-format hooks**: Automatic code formatting
- ✅ **Skills system**: Organized knowledge bases
- ✅ **Feature templates**: Reusable patterns for common features

### vs chatops-plugin

- ✅ **Structured 7-phase workflow**: Systematic feature development
- ✅ **Parallel agent execution**: 2.5x-3x faster in key phases
- ✅ **User approval gates**: 4 decision points for careful development
- ✅ **Greenfield templates**: Start new projects with best practices
- ✅ **Confidence-based filtering**: ≥80 threshold reduces review noise

### Best of Both Worlds

dev-assistant combines:
- **feature-dev's** systematic workflow and multi-perspective analysis
- **chatops-plugin's** multi-language expertise and tactical tools
- **New innovations**: Parallel execution, confidence filtering, 3-approach architecture

---

## Examples

### Example Workflow: Adding User Management

```bash
/build Add user CRUD operations with role-based permissions
```

**Phase 1 (Discovery)**: Detects Java/Spring Boot project

**Phase 2 (Exploration)**: Launches 3 explorers in parallel:
- Explorer 1: Finds similar CRUD features (Product, Order)
- Explorer 2: Maps security and auth patterns
- Explorer 3: Analyzes testing conventions
- **Returns**: 8 key files to read

**Phase 3 (Questions)**: Asks you:
- Should we reuse existing User entity or create new?
- What roles do we need? (ADMIN, USER, GUEST?)
- RESTful API or GraphQL?
- Pagination needed?

**Phase 4 (Architecture)**: Presents 3 approaches:
- **Minimal**: Extend UserController, add CRUD endpoints (3 hours)
- **Clean**: New UserService + DTOs + validation + tests (2 days)
- **Pragmatic**: Service layer + basic DTOs + integration tests (1 day) ⭐ Recommended

**Phase 5 (Implementation)**: You choose Pragmatic, it builds:
- `UserService.java` with business logic
- `CreateUserRequest.java`, `UserResponse.java` DTOs
- Updated `UserController.java` with new endpoints
- `UserServiceTest.java` with mocking
- Auto-formatted with Spotless

**Phase 6 (Review)**: 3 reviewers find:
- **Simplicity**: No issues ≥80 confidence ✅
- **Bugs**: Missing null check in update (confidence 90) ⚠️
- **Conventions**: Should use `@Valid` on DTOs (confidence 85) ⚠️
- **You decide**: Fix now → both issues resolved

**Phase 7 (Summary)**: Documents:
- Created 4 files, modified 2
- Added user CRUD with role validation
- Pragmatic approach chosen
- Next steps: Add integration tests, update API docs

---

## Contributing

Contributions welcome! This plugin combines patterns from feature-dev and chatops-plugin.

### Areas for Contribution

- Additional language support (Go, Rust, etc.)
- More feature templates
- Enhanced skills content
- Integration tests
- Documentation and examples

---

## License

MIT License

---

## Support

- **Issues**: [GitHub Issues](https://github.com/your-repo/dev-assistant/issues)
- **Documentation**: See `INSTALLATION.md` and files in this repository
- **Templates**: See `templates/` directory
- **Skills Reference**: See `skills/` directory

---

## Credits

Built with ⚡ by combining the best patterns from:
- **feature-dev**: Systematic workflow and architecture focus
- **chatops-plugin**: Multi-language expertise and tactical tools

Enhanced with:
- Parallel agent execution
- Confidence-based filtering
- Multiple architectural approaches
- Comprehensive skills system
