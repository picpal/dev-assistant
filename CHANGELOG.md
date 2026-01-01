# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-01-01

### Added
- Initial release with 7-step feature development workflow (/build)
- 8 specialized agents (3 workflow + 5 tactical)
  - Workflow agents: code-explorer, code-architect, code-reviewer
  - Tactical agents: debugger, tester, doc-reference, code-quality, performance-analyzer
- 6 comprehensive skills (knowledge base)
  - architecture-patterns
  - debugging-patterns
  - test-automation
  - documentation-guides
  - quality-standards
  - performance-benchmarks
- 6 commands (1 main workflow + 5 quick commands)
  - /build - 7-step feature development workflow
  - /debug - Error analysis and fixes
  - /test - Test generation and execution
  - /doc - Documentation lookup
  - /quality - Code quality analysis
  - /perf - Performance profiling
- Multi-language support (Java/Spring Boot, Python, TypeScript/React)
- Parallel agent execution (2.5x-3x faster in steps 2, 4, 6)
- Confidence-based filtering (≥80 threshold for code reviews)
- 4 user approval gates for controlled development
- Auto-format hooks for Java, Python, TypeScript
- Feature templates for common patterns (CRUD, auth, file upload, etc.)
- Greenfield project templates with best practices
- Korean and English documentation

### Infrastructure
- Hooks system with auto-formatting (PostToolUse)
- Safety warnings for dangerous commands (PreToolUse)
- Multi-language project detection
- Confidence scoring for code reviews (0-100 scale)
- Template system for reusable patterns

### Documentation
- Comprehensive README.md (Korean)
- Detailed INSTALLATION.md
- Feature templates in templates/feature-templates/
- Greenfield templates in templates/greenfield/

[1.0.0]: https://github.com/picpal/dev-assistant/releases/tag/v1.0.0
