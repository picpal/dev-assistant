# JavaScript/TypeScript/React Debugging Guide

## Common JavaScript Errors

### TypeError: Cannot read property 'X' of undefined

**Cause**: Accessing property of undefined or null

**Examples**:
```javascript
// 1. Undefined variable
let user;
console.log(user.name);  // TypeError: Cannot read property 'name' of undefined

// Fix: Check before access
if (user) {
    console.log(user.name);
}

// Or use optional chaining (ES2020)
console.log(user?.name);  // undefined instead of error

// 2. Missing object property
const data = { name: "John" };
console.log(data.address.city);  // TypeError

// Fix: Optional chaining
console.log(data.address?.city);  // undefined

// Fix: Provide defaults
const address = data.address || {};
console.log(address.city);

// 3. Async timing issue
let userData;
fetchUser().then(data => userData = data);
console.log(userData.name);  // undefined! Async not finished

// Fix: Use await
const userData = await fetchUser();
console.log(userData.name);
```

### ReferenceError: X is not defined

**Cause**: Variable used before declaration

**Examples**:
```javascript
// 1. Typo in variable name
const userName = "John";
console.log(username);  // ReferenceError: username is not defined

// Fix: Check spelling
console.log(userName);

// 2. Scope issue
function outer() {
    const x = 10;
}
console.log(x);  // ReferenceError: x is not defined

// Fix: Return value or use wider scope
function outer() {
    const x = 10;
    return x;
}
const x = outer();
console.log(x);

// 3. Hoisting issue
console.log(myVar);  // ReferenceError with let/const
let myVar = 5;

// With var: undefined (hoisted)
console.log(myVar);  // undefined
var myVar = 5;
```

### SyntaxError: Unexpected token

**Cause**: Invalid JavaScript syntax

**Examples**:
```javascript
// 1. Missing comma
const obj = {
    name: "John"
    age: 30  // SyntaxError: Unexpected identifier
};

// Fix: Add comma
const obj = {
    name: "John",
    age: 30
};

// 2. Incorrect async usage
const fetchData = async => {  // SyntaxError
    await getData();
};

// Fix: Use async keyword correctly
const fetchData = async () => {
    await getData();
};

// 3. JSON parsing error
const data = JSON.parse('{"name": "John",}');  // Trailing comma

// Fix: Valid JSON
const data = JSON.parse('{"name": "John"}');
```

## TypeScript Errors

### Type 'X' is not assignable to type 'Y'

**Examples**:
```typescript
// 1. Type mismatch
interface User {
    name: string;
    age: number;
}

const user: User = {
    name: "John",
    age: "30"  // Type 'string' is not assignable to type 'number'
};

// Fix: Use correct type
const user: User = {
    name: "John",
    age: 30
};

// 2. Missing properties
const user: User = {
    name: "John"  // Property 'age' is missing
};

// Fix: Add property or make it optional
interface User {
    name: string;
    age?: number;  // Optional
}

// 3. Strict null checks
let value: string = null;  // Type 'null' is not assignable to type 'string'

// Fix: Use union type
let value: string | null = null;
```

### Object is possibly 'undefined'

**Examples**:
```typescript
interface User {
    name: string;
    profile?: {
        bio: string;
    };
}

const user: User = { name: "John" };
const bio = user.profile.bio;  // Object is possibly 'undefined'

// Fix 1: Optional chaining
const bio = user.profile?.bio;

// Fix 2: Null check
if (user.profile) {
    const bio = user.profile.bio;
}

// Fix 3: Non-null assertion (use sparingly!)
const bio = user.profile!.bio;  // Tells TS "I know it's not undefined"
```

### any Type Abuse

```typescript
// Problem: Defeats TypeScript's purpose
function processData(data: any): any {
    return data.map((item: any) => item.value);  // No type safety
}

// Fix: Use proper types
interface DataItem {
    value: number;
}

function processData(data: DataItem[]): number[] {
    return data.map(item => item.value);
}

// Or use generics
function processData<T extends { value: number }>(data: T[]): number[] {
    return data.map(item => item.value);
}
```

## React-Specific Issues

### Maximum update depth exceeded

**Cause**: Infinite re-render loop

**Examples**:
```typescript
// 1. setState in render
function Counter() {
    const [count, setCount] = useState(0);

    setCount(count + 1);  // Infinite loop! Renders cause setState

    return <div>{count}</div>;
}

// Fix: Use useEffect or event handlers
function Counter() {
    const [count, setCount] = useState(0);

    useEffect(() => {
        setCount(count + 1);
    }, []);  // Runs once on mount

    return <div>{count}</div>;
}

// 2. useEffect without dependencies
function UserProfile({ userId }) {
    const [user, setUser] = useState(null);

    useEffect(() => {
        fetchUser(userId).then(setUser);
        // Missing dependency array - runs on every render
    });  // Infinite loop if fetchUser causes re-render

    return <div>{user?.name}</div>;
}

// Fix: Add dependency array
useEffect(() => {
    fetchUser(userId).then(setUser);
}, [userId]);  // Only runs when userId changes
```

### Objects are not valid as a React child

**Cause**: Trying to render an object directly

**Examples**:
```typescript
function UserProfile({ user }) {
    return <div>{user}</div>;  // Error if user is object
}

// Fix: Render specific properties
function UserProfile({ user }) {
    return <div>{user.name}</div>;
}

// Or stringify for debugging
function UserProfile({ user }) {
    return <div>{JSON.stringify(user)}</div>;
}
```

### Hooks called conditionally

**Problem**:
```typescript
function Component({ isSpecial }) {
    if (isSpecial) {
        const [value, setValue] = useState(0);  // Error! Hook in condition
    }

    return <div>...</div>;
}

// Fix: Always call hooks
function Component({ isSpecial }) {
    const [value, setValue] = useState(0);  // Always called

    if (!isSpecial) {
        return <div>Regular component</div>;
    }

    return <div>Special: {value}</div>;
}
```

### Stale Closure in useEffect

**Problem**:
```typescript
function Timer() {
    const [count, setCount] = useState(0);

    useEffect(() => {
        const interval = setInterval(() => {
            setCount(count + 1);  // Stale closure! Always uses initial count (0)
        }, 1000);

        return () => clearInterval(interval);
    }, []);  // Empty deps - captures count = 0

    return <div>{count}</div>;
}

// Fix 1: Include dependency
useEffect(() => {
    const interval = setInterval(() => {
        setCount(count + 1);
    }, 1000);

    return () => clearInterval(interval);
}, [count]);  // Re-creates interval when count changes

// Fix 2: Use functional update (better)
useEffect(() => {
    const interval = setInterval(() => {
        setCount(c => c + 1);  // Uses current value
    }, 1000);

    return () => clearInterval(interval);
}, []);  // Can keep empty deps
```

### Missing key prop

```typescript
// Problem: No keys in list
function UserList({ users }) {
    return (
        <div>
            {users.map(user => (
                <div>{user.name}</div>  // Warning: Each child should have key
            ))}
        </div>
    );
}

// Fix: Add unique key
function UserList({ users }) {
    return (
        <div>
            {users.map(user => (
                <div key={user.id}>{user.name}</div>
            ))}
        </div>
    );
}

// Never use index as key if list can change:
{users.map((user, index) => (
    <div key={index}>{user.name}</div>  // Bad if list reorders
))}
```

## Browser DevTools Debugging

### Console Methods

```javascript
// Basic logging
console.log("Message");
console.error("Error message");
console.warn("Warning");
console.info("Info");

// Grouping
console.group("User Details");
console.log("Name:", user.name);
console.log("Age:", user.age);
console.groupEnd();

// Table view
console.table([
    { name: "John", age: 30 },
    { name: "Jane", age: 25 }
]);

// Timing
console.time("fetchData");
await fetchData();
console.timeEnd("fetchData");  // fetchData: 123.45ms

// Trace stack
console.trace("Function called from:");

// Conditional logging
console.assert(value > 0, "Value must be positive");
```

### Breakpoints

**Types**:
1. **Line Breakpoint**: Click line number
2. **Conditional Breakpoint**: Right-click line, add condition
3. **Logpoint**: Log without stopping execution
4. **XHR/Fetch Breakpoint**: Break on network requests
5. **Event Listener Breakpoint**: Break on DOM events
6. **Exception Breakpoint**: Break when error thrown

**Debugger Statement**:
```javascript
function processData(data) {
    debugger;  // Execution pauses here if DevTools open
    return data.map(x => x * 2);
}
```

### React DevTools

**Components Tab**:
- Inspect component tree
- View props and state
- Search for components
- Highlight component updates

**Profiler Tab**:
- Record rendering performance
- Identify slow components
- View component render counts
- Flame graph visualization

## Async Debugging

### Promise Rejection

```javascript
// Unhandled promise rejection
fetch('/api/data')
    .then(res => res.json());  // No error handling

// Fix: Add catch
fetch('/api/data')
    .then(res => res.json())
    .catch(err => {
        console.error('Fetch failed:', err);
    });

// Or use async/await with try-catch
async function fetchData() {
    try {
        const res = await fetch('/api/data');
        const data = await res.json();
        return data;
    } catch (err) {
        console.error('Fetch failed:', err);
        throw err;
    }
}
```

### Race Conditions

```javascript
// Problem: Multiple async calls, last to finish wins
let currentUserId;

function loadUser(userId) {
    currentUserId = userId;
    fetch(`/api/users/${userId}`)
        .then(res => res.json())
        .then(user => {
            // What if a newer request finished earlier?
            displayUser(user);
        });
}

// Fix: Check if request is still current
function loadUser(userId) {
    currentUserId = userId;
    const requestUserId = userId;

    fetch(`/api/users/${userId}`)
        .then(res => res.json())
        .then(user => {
            if (requestUserId === currentUserId) {  // Still current?
                displayUser(user);
            }
        });
}

// Better: Use AbortController
let controller;

function loadUser(userId) {
    // Cancel previous request
    if (controller) {
        controller.abort();
    }

    controller = new AbortController();

    fetch(`/api/users/${userId}`, { signal: controller.signal })
        .then(res => res.json())
        .then(displayUser)
        .catch(err => {
            if (err.name !== 'AbortError') {
                console.error(err);
            }
        });
}
```

## Performance Debugging

### Identifying Slow Code

```javascript
// Mark performance
performance.mark('start-processing');

processLargeDataset(data);

performance.mark('end-processing');
performance.measure('Processing Time', 'start-processing', 'end-processing');

const measures = performance.getEntriesByName('Processing Time');
console.log(`Processing took ${measures[0].duration}ms`);
```

### React Performance

```typescript
// 1. Avoid inline functions in JSX (creates new function each render)
// Bad
<button onClick={() => handleClick(id)}>Click</button>

// Good
const handleButtonClick = useCallback(() => {
    handleClick(id);
}, [id]);

<button onClick={handleButtonClick}>Click</button>

// 2. Memoize expensive computations
const expensiveValue = useMemo(() => {
    return data.reduce((acc, item) => acc + item.value, 0);
}, [data]);

// 3. Memoize components
const UserCard = React.memo(({ user }) => {
    return <div>{user.name}</div>;
});

// 4. Use key properly for lists
{items.map(item => (
    <Item key={item.id} item={item} />  // Stable key = better performance
))}
```

## Source Maps

**Enable in production (with caution)**:
```javascript
// webpack.config.js
module.exports = {
    devtool: 'source-map',  // Or 'hidden-source-map' for production
};
```

**Debugging Minified Code**:
- Upload source maps to error tracking service (Sentry, Rollbar)
- Maps minified errors back to original code

## Error Boundaries

```typescript
import React, { Component, ReactNode } from 'react';

interface Props {
    children: ReactNode;
    fallback?: ReactNode;
}

interface State {
    hasError: boolean;
    error?: Error;
}

class ErrorBoundary extends Component<Props, State> {
    state: State = { hasError: false };

    static getDerivedStateFromError(error: Error): State {
        return { hasError: true, error };
    }

    componentDidCatch(error: Error, errorInfo: React.ErrorInfo) {
        console.error('Error caught by boundary:', error, errorInfo);
        // Send to error tracking service
    }

    render() {
        if (this.state.hasError) {
            return this.props.fallback || <div>Something went wrong</div>;
        }

        return this.props.children;
    }
}

// Usage
<ErrorBoundary fallback={<ErrorDisplay />}>
    <App />
</ErrorBoundary>
```

## Tools

- **Chrome DevTools**: Browser debugging
- **React DevTools**: React component debugging
- **Redux DevTools**: State debugging
- **VS Code Debugger**: IDE debugging
- **ESLint**: Catch common errors
- **TypeScript**: Static type checking
- **Jest**: Testing framework
- **Sentry/Rollbar**: Error tracking in production

## Quick Reference

| Error | Common Cause | Quick Fix |
|-------|--------------|-----------|
| Cannot read property 'X' of undefined | Accessing undefined | Optional chaining (?.) |
| X is not defined | Typo or scope issue | Check variable name |
| Maximum update depth | Infinite re-render | Check useEffect deps |
| Objects are not valid React child | Rendering object | Render specific properties |
| Hook called conditionally | Hook in if/loop | Always call hooks |
| Missing key prop | No key in list | Add unique key |
| Promise rejection | No error handling | Add .catch() or try-catch |
| CORS error | Server config issue | Enable CORS on server |
| Network error | API down or wrong URL | Check network tab |
