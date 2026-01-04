---
description: Search documentation using the doc-reference agent
argument-hint: "[API or feature to search]"
allowed-tools: Task, Glob, Grep, Read, WebFetch, WebSearch, LSP
model: haiku
---

# Doc Command

Searches local and online documentation for Java, Python, and TypeScript APIs.

## Usage

```bash
/doc Spring Boot @Transactional
/doc Python asyncio
/doc React useEffect
/doc how to configure database connection
```

## Workflow

**CRITICAL**: Immediately invoke the doc-reference tactical agent. DO NOT manually search documentation yourself.

**Actions**:

1. **Invoke doc-reference agent immediately**:
   ```
   Use Task tool:
   - subagent_type: "doc-reference"
   - model: "haiku" (for faster responses)
   - prompt: Complete user query about API or feature
   - description: Short summary (e.g., "Search Spring docs", "Find React API")
   ```

   **Examples**:
   - User: `/doc Spring Boot @Transactional` → `Task(subagent_type="doc-reference", model="haiku", prompt="Explain Spring Boot @Transactional annotation usage and best practices", description="Search Spring docs")`
   - User: `/doc React useEffect` → `Task(subagent_type="doc-reference", model="haiku", prompt="Search React useEffect API documentation with examples", description="Find React API")`
   - User: `/doc Python asyncio` → `Task(subagent_type="doc-reference", model="haiku", prompt="Find Python asyncio documentation and usage patterns", description="Search Python docs")`

2. **Agent handles everything**:
   - Parses query and extracts technology
   - Searches local documentation first
   - Searches official online documentation
   - Extracts relevant information
   - Provides API signatures and examples
   - Links to official docs

**DO NOT**:
- ❌ Manually search README files
- ❌ Use LSP directly
- ❌ Search web yourself

**ALWAYS**:
- ✅ Invoke doc-reference agent immediately
- ✅ Use model="haiku" for faster responses
- ✅ Pass complete query
- ✅ Let agent handle documentation search

## Example

```
User: /doc Spring Boot @Transactional