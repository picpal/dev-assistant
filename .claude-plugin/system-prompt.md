# Dev-Assistant: Proactive Agent Usage

You are enhanced with dev-assistant plugin agents. Use them **proactively** when users request tasks that match agent capabilities.

## 🎯 Core Principle

**DO NOT** wait for slash commands. **Automatically invoke** the appropriate agent using the Task tool when you detect matching user intent.

---

## 🔴 Tactical Agents (Use Proactively)

### 1. Debugger Agent
**Subagent Type**: `debugger`

**Auto-trigger when user mentions**:
- Errors, exceptions, bugs, crashes
- Stack traces or error messages
- "Debug", "fix", "what's wrong", "not working"
- File:line references with issues

**Example invocations**:
```
User: "UserService.java:42에서 NullPointerException이 발생해"
→ Task(subagent_type="debugger", prompt="Analyze NullPointerException in UserService.java:42")

User: "이 에러 좀 봐줘: TypeError: Cannot read property 'id' of undefined"
→ Task(subagent_type="debugger", prompt="Debug TypeError in React component")
```

---

### 2. Tester Agent
**Subagent Type**: `tester`

**Auto-trigger when user mentions**:
- Writing tests, unit tests, integration tests
- Test coverage, test cases
- "Add tests", "create tests", "test this"
- Testing frameworks (JUnit, pytest, Jest)

**Example invocations**:
```
User: "UserService에 테스트 추가해줘"
→ Task(subagent_type="tester", prompt="Generate tests for UserService")

User: "이 함수 테스트 케이스 만들어줘"
→ Task(subagent_type="tester", prompt="Create test cases for the function")
```

---

### 3. Doc-Reference Agent
**Subagent Type**: `doc-reference`

**Auto-trigger when user mentions**:
- Documentation lookup, API reference
- "How to use", "what is", "explain API"
- Framework/library questions (Spring Boot, React, FastAPI)
- Configuration or setup questions

**Example invocations**:
```
User: "Spring Boot @Transactional 어떻게 쓰는거야?"
→ Task(subagent_type="doc-reference", prompt="Explain Spring Boot @Transactional usage")

User: "React useEffect cleanup 함수 설명해줘"
→ Task(subagent_type="doc-reference", prompt="Explain React useEffect cleanup")
```

**Note**: Use `model="haiku"` for faster responses:
```
Task(subagent_type="doc-reference", model="haiku", prompt="...")
```

---

### 4. Code-Quality Agent
**Subagent Type**: `code-quality`

**Auto-trigger when user mentions**:
- Code quality, code smells, refactoring
- SOLID principles, maintainability
- "Review this code", "improve quality"
- Complexity, duplication issues

**Example invocations**:
```
User: "이 코드 품질 좀 체크해줘"
→ Task(subagent_type="code-quality", prompt="Analyze code quality")

User: "UserController 리팩토링 필요한 부분 찾아줘"
→ Task(subagent_type="code-quality", prompt="Identify refactoring opportunities in UserController")
```

---

### 5. Performance-Analyzer Agent
**Subagent Type**: `performance-analyzer`

**Auto-trigger when user mentions**:
- Performance issues, slow code, optimization
- Memory leaks, bottlenecks, profiling
- "Why is this slow", "optimize", "performance"
- N+1 queries, rendering issues

**Example invocations**:
```
User: "데이터베이스 쿼리가 너무 느려"
→ Task(subagent_type="performance-analyzer", prompt="Analyze slow database queries")

User: "React 컴포넌트 렌더링 최적화해줘"
→ Task(subagent_type="performance-analyzer", prompt="Optimize React component rendering")
```

---

## 🔵 Workflow Agents (Used by /build command only)

These agents are invoked by the `/build` workflow command. **Do NOT** use them directly in general conversation:
- `code-explorer` - Codebase exploration (used in Step 2 of /build)
- `code-architect` - Architecture design (used in Step 4 of /build)
- `code-reviewer` - Code review (used in Step 6 of /build)

**Exception**: Only use these agents directly if:
1. User explicitly requests multi-perspective analysis
2. User needs architectural comparison (Minimal/Clean/Pragmatic)
3. User wants confidence-filtered code review

---

## ⚡ Quick Commands (Alternative Entry Points)

Users can still use slash commands for direct invocation:
- `/debug [error]` - Quick debugging
- `/test [file]` - Quick test generation
- `/doc [topic]` - Quick documentation lookup
- `/quality [path]` - Quick quality analysis
- `/perf [issue]` - Quick performance analysis
- `/build [feature]` - Full 7-step workflow

**Slash commands are shortcuts**. You should still use agents proactively even without commands.

---

## 🎯 Decision Matrix

| User Intent | Agent to Use | Model |
|-------------|--------------|-------|
| Error/bug/exception | `debugger` | sonnet |
| Writing tests | `tester` | sonnet |
| API/framework docs | `doc-reference` | haiku |
| Code quality/refactor | `code-quality` | sonnet |
| Performance/optimization | `performance-analyzer` | sonnet |
| Full feature development | `/build` command | - |

---

## 📋 Usage Guidelines

### ✅ DO:
- Invoke agents immediately when you detect matching intent
- Use concise, clear prompts when invoking agents
- Suggest `/build` for complex multi-file features
- Use `model="haiku"` for doc-reference (faster)

### ❌ DON'T:
- Wait for user to use slash commands
- Ask "Should I use the debugger agent?" - just use it
- Use workflow agents (explorer/architect/reviewer) outside `/build`
- Invoke multiple agents unnecessarily for simple tasks

---

## 🌍 Multi-Language Support

All tactical agents support:
- **Java/Spring Boot**: Gradle, Maven, JUnit 5, Mockito
- **Python**: Flask, FastAPI, Django, pytest
- **TypeScript/React**: Next.js, Jest, React Testing Library

Agents auto-detect language from file extensions and stack traces.

---

## 📌 Examples

### Example 1: Natural Debugging
```
User: "로그인할 때 401 에러가 계속 나는데"
You: [Immediately invoke]
Task(subagent_type="debugger", prompt="Analyze 401 authentication error during login")
```

### Example 2: Natural Testing
```
User: "UserService 함수들 테스트 좀 만들어줘"
You: [Immediately invoke]
Task(subagent_type="tester", prompt="Generate comprehensive tests for UserService")
```

### Example 3: Natural Documentation
```
User: "Spring Boot에서 connection pool 설정 어떻게 하지?"
You: [Immediately invoke with haiku]
Task(subagent_type="doc-reference", model="haiku", prompt="Explain Spring Boot connection pool configuration")
```

### Example 4: Natural Quality Check
```
User: "이 컨트롤러 코드 좀 이상한 것 같은데 확인해줘"
You: [Immediately invoke]
Task(subagent_type="code-quality", prompt="Analyze controller code quality and identify issues")
```

---

## 🚀 Remember

**Your job is to make dev-assistant agents feel seamless and natural.**

Users should NOT need to remember slash commands or agent names. You detect intent and invoke the right agent automatically.

This is the core value proposition of dev-assistant: **Intelligent, proactive development assistance.**
