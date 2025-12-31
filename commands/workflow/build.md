---
description: Complete 7-phase feature development workflow with multi-language support (Java/Spring Boot, Python, TypeScript/React)
argument-hint: Optional feature description
---

# Feature Development Workflow (/build)

You are helping a developer implement a new feature using a systematic 7-phase approach. This workflow supports Java/Spring Boot, Python, and TypeScript/React projects.

## Core Principles

- **Multi-language aware**: Detect project language and apply appropriate patterns
- **Ask clarifying questions**: Identify all ambiguities before designing
- **Understand before acting**: Read and comprehend existing code patterns first
- **Read files identified by agents**: When agents complete, read those files before proceeding
- **Simple and elegant**: Prioritize readable, maintainable code
- **Use TodoWrite**: Track all progress throughout
- **Parallel execution**: Launch multiple agents simultaneously for speed
- **User approval gates**: Wait for explicit user confirmation at key decision points

---

## Phase 1: Discovery

**Goal**: Understand what needs to be built

Initial request: $ARGUMENTS

**Actions**:
1. Create todo list with all 7 phases
2. Detect project language(s):
   - Java/Spring Boot: Look for `build.gradle`, `pom.xml`, `.java` files
   - Python: Look for `requirements.txt`, `pyproject.toml`, `.py` files
   - TypeScript/React: Look for `package.json`, `tsconfig.json`, `.tsx` files
3. If feature unclear, ask user for:
   - What problem are they solving?
   - What should the feature do?
   - Any constraints or requirements?
   - Is this greenfield or adding to existing project?
4. Summarize understanding and confirm with user

---

## Phase 2: Codebase Exploration

**Goal**: Understand relevant existing code and patterns

**Actions**:
1. **Launch 2-3 code-explorer agents in PARALLEL**. Each agent should:
   - Focus on different aspects (similar features / architecture / testing patterns)
   - Trace through code comprehensively
   - Return list of 5-10 key files to read
   - Apply language-specific exploration patterns

   **Example agent prompts**:
   - "Find features similar to [feature] in this [Java/Python/TypeScript] codebase and trace implementation"
   - "Map the architecture and abstractions for [feature area], focusing on [Spring Boot/FastAPI/React] patterns"
   - "Analyze testing patterns and conventions in this [Java/Python/TypeScript] project"

2. **After agents complete**: Read ALL files identified by agents to build deep understanding
3. **Present comprehensive summary**:
   - Key patterns found (language-specific: Spring annotations, FastAPI decorators, React hooks)
   - Project structure and conventions
   - Testing approach
   - Similar features that can be referenced

---

## Phase 3: Clarifying Questions

**Goal**: Fill in gaps and resolve all ambiguities before designing

**CRITICAL**: This is one of the most important phases. DO NOT SKIP.

**Actions**:
1. Review codebase findings and original feature request
2. Identify underspecified aspects:
   - Edge cases and error handling
   - Integration points
   - Scope boundaries
   - Design preferences (Minimal/Clean/Pragmatic)
   - Backward compatibility
   - Performance needs
   - Language-specific considerations (e.g., async/sync in Python, lazy loading in Java)
3. **Present all questions to user in a clear, organized list**
4. **WAIT FOR ANSWERS** before proceeding to architecture design

**USER APPROVAL GATE #1**: Questions must be answered before proceeding

If user says "whatever you think is best", provide your recommendation and get explicit confirmation.

---

## Phase 4: Architecture Design

**Goal**: Design three implementation approaches with different trade-offs

**Actions**:
1. **Launch 3 code-architect agents in PARALLEL**, each focusing on one approach:
   - **Agent 1 - Minimal**: Fastest path, minimal changes, low abstraction
   - **Agent 2 - Clean**: Best practices, SOLID principles, full abstraction
   - **Agent 3 - Pragmatic**: Balanced trade-off, practical approach

   Each agent should design for the detected language (Java/Python/TypeScript) and include:
   - Component design
   - File structure
   - Implementation steps
   - Estimated effort
   - Trade-offs

2. **After agents complete**: Review all three approaches and form your opinion
3. **Present to user**:
   - Brief summary of each approach (Minimal/Clean/Pragmatic)
   - Trade-offs comparison table
   - **Your recommendation with reasoning** (consider: feature complexity, timeline, team context)
   - Concrete implementation differences

4. **USER APPROVAL GATE #2**: Ask user which approach they prefer

---

## Phase 5: Implementation

**Goal**: Build the feature following chosen architecture

**DO NOT START WITHOUT USER APPROVAL**

**USER APPROVAL GATE #3**: Wait for explicit user approval to start implementation

**Actions**:
1. **Wait for user approval** before writing any code
2. Read all relevant files identified in previous phases
3. Implement following chosen architecture approach
4. Follow codebase conventions strictly:
   - **Java**: Spring annotations, constructor injection, package structure
   - **Python**: Type hints, Pydantic validation, PEP 8 style
   - **TypeScript**: Strict types, React hooks patterns, interface definitions
5. Write clean, well-documented code
6. **Auto-format is enabled**: Edit/Write operations will auto-format files based on detected language
7. Update todos as you progress

**Language-Specific Implementation Notes**:
- **Java**: Use Lombok for boilerplate, prefer constructor injection, follow repository pattern
- **Python**: Use type hints, async where appropriate, Pydantic for validation
- **TypeScript/React**: Use functional components, custom hooks for logic, proper TypeScript interfaces

---

## Phase 6: Quality Review

**Goal**: Ensure code meets quality standards

**Actions**:
1. **Launch 3 code-reviewer agents in PARALLEL**, each with different perspective:
   - **Reviewer 1 - Simplicity**: Focus on code complexity, readability, DRY
   - **Reviewer 2 - Bugs**: Focus on logic errors, null handling, security
   - **Reviewer 3 - Conventions**: Focus on language idioms, framework patterns, project guidelines

   **CRITICAL**: Each reviewer uses confidence-based filtering
   - Only report issues with confidence ≥ 80
   - This reduces noise and focuses on real problems

2. **After reviewers complete**: Consolidate findings
   - Group by severity (Critical 90-100 vs Important 80-89)
   - Identify highest priority issues
   - Filter out duplicate findings across reviewers

3. **USER APPROVAL GATE #4**: Present findings to user and ask what they want to do:
   - Fix now (you'll address all high-confidence issues)
   - Fix some (user selects which to address)
   - Proceed as-is (defer fixes)

4. Address issues based on user decision

**Confidence Threshold**: Only issues with ≥80 confidence are shown to reduce false positives

---

## Phase 7: Summary

**Goal**: Document what was accomplished

**Actions**:
1. Mark all todos complete
2. Provide comprehensive summary:
   - **What was built**: Feature description and capabilities
   - **Approach used**: Which architecture (Minimal/Clean/Pragmatic)
   - **Language/framework**: Java/Spring Boot, Python/FastAPI, or TypeScript/React
   - **Files created**: List with brief descriptions
   - **Files modified**: List with changes made
   - **Key decisions**: Important choices made during implementation
   - **Testing**: What tests were added
   - **Next steps**: Recommended follow-up actions (e.g., integration tests, documentation)

3. Offer to:
   - Create git commit with structured message
   - Generate documentation
   - Add more tests
   - Create pull request

---

## Workflow Summary

```
Phase 1: Discovery           → Understand feature request
         ↓
Phase 2: Exploration         → 2-3 code-explorer agents (parallel)
         ↓
Phase 3: Questions          → User answers (GATE #1) ✋
         ↓
Phase 4: Architecture       → 3 code-architect agents (parallel, Minimal/Clean/Pragmatic)
         ↓                   → User selects approach (GATE #2) ✋
Phase 5: Implementation     → User approves start (GATE #3) ✋
         ↓                   → Code with auto-format
Phase 6: Review             → 3 code-reviewer agents (parallel, confidence ≥80)
         ↓                   → User decides on fixes (GATE #4) ✋
Phase 7: Summary            → Document and wrap up
```

## Language Detection & Adaptation

The workflow automatically adapts based on detected project language:

**Java/Spring Boot**:
- Use Spring conventions (annotations, dependency injection)
- Apply layered architecture patterns
- Generate JUnit 5 tests
- Format with google-java-format or Spotless

**Python**:
- Use FastAPI/Flask/Django patterns
- Apply type hints throughout
- Generate pytest tests
- Format with black + isort

**TypeScript/React**:
- Use functional components and hooks
- Apply React best practices
- Generate Jest + RTL tests
- Format with prettier

## Best Practices

1. **Always use TodoWrite** to track progress through all phases
2. **Launch agents in parallel** whenever possible (phases 2, 4, 6)
3. **Read files before proceeding** - don't rely solely on agent summaries
4. **Wait at approval gates** - never proceed without explicit user confirmation
5. **Trust the confidence scores** - only show review findings ≥80
6. **Follow detected language conventions** - don't mix patterns from different languages
7. **Leverage auto-format** - let hooks handle formatting, focus on logic

## Error Handling

If anything goes wrong:
- **Agent fails**: Re-launch with refined prompt
- **User unclear**: Ask more specific questions
- **Patterns conflict**: Present options and ask user to choose
- **Language unknown**: Ask user which language/framework to use

## Time Estimates

Based on approach chosen and feature complexity:

| Approach | Simple Feature | Medium Feature | Complex Feature |
|----------|---------------|----------------|-----------------|
| Minimal | 1-2 hours | 3-5 hours | 1 day |
| Pragmatic | 2-4 hours | 0.5-1 day | 2-3 days |
| Clean | 4-8 hours | 1-2 days | 3-5 days |

## Success Criteria

- [ ] All 4 user approval gates passed
- [ ] Code follows detected language conventions
- [ ] Tests added (appropriate to approach)
- [ ] Auto-formatted code
- [ ] No high-confidence (≥80) review issues remaining (or user accepted them)
- [ ] User understands what was built and why
