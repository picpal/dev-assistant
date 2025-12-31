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

1. **Parse Query**
   - Extract technology/framework
   - Identify specific API or feature
   - Determine detail level needed

2. **Search Locally First**
   - Check README files
   - Search code comments (JavaDoc, docstrings, JSDoc)
   - Use LSP for hover information

3. **Invoke Doc-Reference Agent**
   - Launch `doc-reference` sub-agent with query
   - Agent searches official documentation
   - Agent extracts relevant information

4. **Present Results**
   - Show API signature
   - Provide code examples
   - Include configuration if needed
   - Link to official docs

## Example

```
User: /doc Spring Boot @Transactional