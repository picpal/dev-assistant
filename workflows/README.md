# Workflow Phase Guides

Detailed guides for each phase of the `/build` workflow.

## 7 Phases

1. **Discovery**: Understand the feature request
2. **Exploration**: Parallel code analysis with code-explorer agents
3. **Questions**: Clarify ambiguities with user (approval gate)
4. **Architecture**: Design 3 approaches in parallel (approval gate)
5. **Implementation**: Build the feature (approval gate)
6. **Review**: Quality check with confidence filtering (approval gate)
7. **Summary**: Document and wrap up

## Parallel Execution

Phases 2, 4, and 6 use parallel agent execution for 2.5x-3x speed improvement:
- Phase 2: 2-3 code-explorer agents
- Phase 4: 3 code-architect agents (Minimal/Clean/Pragmatic)
- Phase 6: 3 code-reviewer agents (Simplicity/Bugs/Conventions)

## User Approval Gates

4 critical gates where user must approve before proceeding:
- Gate #1 (Phase 3): Answer clarifying questions
- Gate #2 (Phase 4): Select architecture approach
- Gate #3 (Phase 5): Approve implementation start
- Gate #4 (Phase 6): Decide on review findings

## Confidence-Based Filtering

Phase 6 reviewers only report issues with confidence ≥ 80 to reduce noise.

## Multi-Language Support

All phases automatically adapt to detected project language:
- Java/Spring Boot
- Python/FastAPI
- TypeScript/React

## See Also

- `/commands/workflow/build.md`: Complete workflow definition
- `/agents/workflow/`: Agent specifications
- `/skills/architecture-patterns/`: Design pattern references
