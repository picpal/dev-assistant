# TypeScript/React Best Practices

## TypeScript Strict Mode

```typescript
// tsconfig.json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true
  }
}
```

## Avoid 'any' Type

```typescript
// Bad
function process(data: any): any {
    return data.value;
}

// Good
interface DataItem {
    value: number;
}

function process(data: DataItem): number {
    return data.value;
}
```

## React Functional Components

```typescript
// Good: Functional component with TypeScript
interface UserProps {
    user: User;
    onSave: (user: User) => void;
}

export function UserProfile({ user, onSave }: UserProps): JSX.Element {
    return <div>{user.name}</div>;
}
```

## Use Hooks Correctly

```typescript
// Good: Dependencies declared
useEffect(() => {
    fetchData(userId);
}, [userId]);

// Good: Functional setState
setCount(prevCount => prevCount + 1);

// Good: Memoize expensive computations
const total = useMemo(() =>
    items.reduce((sum, item) => sum + item.price, 0),
    [items]
);
```

## Const Over Let

```typescript
// Good
const user = getUser();
const items = [1, 2, 3];

// Avoid let when possible
let value = 10;  // Only if value needs to change
```

## Optional Chaining

```typescript
// Good: Safe property access
const city = user?.address?.city;

// Avoid multiple null checks
const city = user && user.address && user.address.city;
```

## Proper Key Props

```typescript
// Good: Stable unique keys
{users.map(user => (
    <UserCard key={user.id} user={user} />
))}

// Avoid index as key if list can change
{users.map((user, index) => (
    <UserCard key={index} user={user} />  // Bad!
))}
```
