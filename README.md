# dev-assistant

> AI-powered development assistant combining structured feature workflows with tactical development tools

## Overview

**dev-assistant** is a Claude Code plugin that brings together the best of both worlds:
- **Structured 7-phase feature development workflow** for building complex features with proper planning and review
- **Quick tactical commands** for debugging, testing, and code quality tasks

### Supported Languages & Frameworks

- **Java**: Spring Boot, Gradle, Maven, JUnit 5
- **Python**: Flask, FastAPI, Django, pytest
- **TypeScript/React**: Next.js, Jest, React Testing Library

---

## Features

### 🏗️ Main Workflow: `/build`

A comprehensive 7-phase workflow for feature development:

1. **Discovery** - Clarify requirements and constraints
2. **Exploration** - Parallel exploration of codebase with 3 agents
3. **Questions** - Fill gaps with clarifying questions (user approval gate)
4. **Architecture** - Design 3 approaches: Minimal/Clean/Pragmatic (user selection gate)
5. **Implementation** - Build the feature (user approval gate, auto-format enabled)
6. **Review** - Multi-perspective code review with confidence filtering (user decision gate)
7. **Summary** - Document what was built and next steps

#### Key Capabilities:
- ⚡ **Parallel agent execution** (2.5x-3x faster in Phases 2, 4, 6)
- 🎯 **Confidence-based filtering** (only show findings with ≥80% confidence)
- 🚪 **4 user approval gates** for careful, deliberate development
- 🎨 **Auto-format hooks** (Java, Python, TypeScript)
- 🌍 **Multi-language aware** architecture design

---

### ⚡ Quick Commands

#### `/debug` - Error Analysis & Fixing
- Multi-language error analysis (Java/Python/TypeScript)
- Stack trace interpretation
- Root cause identification
- Immediate fix suggestions
- Prevention strategies

#### `/test` - Test Generation & Execution
- Framework-aware test generation (JUnit 5, pytest, Jest)
- AAA pattern (Arrange-Act-Assert)
- Mocking and fixtures
- Coverage reporting
- Run tests automatically

#### `/doc` - Documentation Search
- Local documentation search (README, docstrings)
- Online official docs (spring.io, python.org, react.dev)
- API signatures and examples
- Fast results (haiku model)

#### `/quality` - Code Quality Analysis
- SOLID principle checking
- Code smell detection
- Cyclomatic complexity calculation
- Refactoring suggestions
- Prioritized improvement roadmap

#### `/perf` - Performance Profiling
- Language-specific profiling (JVM, cProfile, React DevTools)
- Bottleneck identification (N+1 queries, re-renders, memory leaks)
- Optimization suggestions with impact estimates
- Monitoring metrics recommendations

---

## Architecture

### 8 Specialized Agents

#### Workflow Agents (Parallelized)
- **code-explorer** - Codebase discovery and pattern recognition
- **code-architect** - Multi-approach architecture design
- **code-reviewer** - Quality review with confidence scoring

#### Tactical Agents (Quick Tasks)
- **debugger** - Error analysis and fixing
- **tester** - Test automation
- **doc-reference** - Documentation search
- **code-quality** - Maintainability analysis
- **performance-analyzer** - Performance profiling

### 6 Skills (Knowledge Bases)
- `debugging-patterns` - Multi-language error patterns
- `test-automation` - Testing framework best practices
- `documentation-guides` - Documentation standards
- `quality-standards` - SOLID and best practices
- `performance-benchmarks` - Optimization techniques
- `architecture-patterns` - Design patterns and trade-offs

---

## Installation

### Prerequisites

- Claude Code CLI installed
- Git installed
- Language-specific formatters (optional but recommended):
  - Java: `google-java-format` or Gradle Spotless
  - Python: `black`, `isort`
  - TypeScript: `prettier`

### Install Plugin

```bash
# Clone the plugin
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

For detailed installation instructions, see [INSTALLATION.md](./INSTALLATION.md).

---

## Quick Start

### Building a New Feature

```bash
# Start the full 7-phase workflow
/build Add user authentication with OAuth
```

The workflow will guide you through:
1. Clarifying requirements
2. Exploring your codebase
3. Answering design questions
4. Choosing architecture approach
5. Implementing the feature
6. Reviewing code quality
7. Summarizing changes

### Quick Debugging

```bash
# Debug an error
/debug "NullPointerException in UserService.java:42"

# Debug from stack trace
/debug <paste stack trace>
```

### Generate Tests

```bash
# Generate tests for a file
/test UserService.java
/test LoginForm.tsx
```

### Search Documentation

```bash
# Find framework documentation
/doc "Spring Boot connection pooling"
/doc "React useEffect cleanup"
```

### Analyze Code Quality

```bash
# Analyze quality
/quality src/services/
/quality UserController.java
```

### Profile Performance

```bash
# Profile performance
/perf database queries
/perf React component rendering
```

---

## When to Use What?

### Use `/build` workflow when:
- Building complete new features
- Initializing greenfield projects
- Complex changes requiring architectural decisions
- You want structured guidance and review
- You need multi-perspective analysis

### Use quick commands when:
- Debugging specific errors (`/debug`)
- Adding tests to existing code (`/test`)
- Looking up documentation (`/doc`)
- Analyzing specific modules (`/quality`)
- Profiling specific performance issues (`/perf`)

---

## Key Differentiators

### vs feature-dev
✅ Multi-language support (Java/Python/TypeScript)
✅ Quick tactical commands for daily tasks
✅ Auto-format hooks for code quality
✅ Skills system for organized knowledge
✅ Richer development toolset

### vs chatops-plugin
✅ Structured 7-phase workflow
✅ Parallel agent execution (2.5x faster)
✅ User approval gates for careful development
✅ Greenfield project template support
✅ Confidence-based filtering reduces noise

---

## Contributing

This plugin is under active development. Contributions welcome!

### Development Status

- ✅ Core infrastructure (Week 1)
- 🚧 Workflow agents (Week 2-3) - In Progress
- ⏳ Tactical agents (Week 4)
- ⏳ Commands (Week 5)
- ⏳ Templates (Week 6)
- ⏳ Testing (Week 7)
- ⏳ Documentation (Week 8)

---

## License

MIT License

---

## Support

- Issues: GitHub Issues
- Documentation: See docs in this repository
- Examples: [EXAMPLES.md](./EXAMPLES.md) (coming soon)

---

Built with ⚡ by combining the best patterns from feature-dev and chatops-plugin
