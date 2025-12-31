# React Performance Optimization

## Memoization

```typescript
// Memo component to prevent re-renders
const UserCard = React.memo(({ user }) => {
    return <div>{user.name}</div>;
});

// Memoize expensive computations
const total = useMemo(() => {
    return items.reduce((sum, item) => sum + item.price, 0);
}, [items]);

// Memoize callbacks
const handleClick = useCallback(() => {
    doSomething(id);
}, [id]);
```

## Code Splitting

```typescript
// Lazy load components
const HeavyComponent = React.lazy(() => import('./HeavyComponent'));

function App() {
    return (
        <Suspense fallback={<Loading />}>
            <HeavyComponent />
        </Suspense>
    );
}
```

## Virtualization for Long Lists

```typescript
import { FixedSizeList } from 'react-window';

function BigList({ items }) {
    return (
        <FixedSizeList
            height={600}
            itemCount={items.length}
            itemSize={50}
        >
            {({ index, style }) => (
                <div style={style}>{items[index].name}</div>
            )}
        </FixedSizeList>
    );
}
```

## Bundle Size Optimization

```typescript
// Import only what you need
import { debounce } from 'lodash-es';

// Avoid importing entire library
import _ from 'lodash';  // Imports everything
```

## Image Optimization

```typescript
import Image from 'next/image';

<Image
    src="/photo.jpg"
    width={500}
    height={300}
    loading="lazy"
    placeholder="blur"
/>
```

## Avoid Inline Functions

```typescript
// Bad: Creates new function each render
<button onClick={() => handleClick(id)}>Click</button>

// Good: Memoized callback
const onClick = useCallback(() => handleClick(id), [id]);
<button onClick={onClick}>Click</button>
```

## Bundle Analysis

```bash
# Analyze bundle size
npm run build
npx webpack-bundle-analyzer build/static/js/*.js
```
