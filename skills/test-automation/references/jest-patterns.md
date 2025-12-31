# Jest and React Testing Library Patterns

## Component Testing

```typescript
import { render, screen, fireEvent } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { UserProfile } from './UserProfile';

describe('UserProfile', () => {
    it('should display user information', () => {
        const user = { id: 1, name: 'John Doe', email: 'john@example.com' };

        render(<UserProfile user={user} />);

        expect(screen.getByText('John Doe')).toBeInTheDocument();
        expect(screen.getByText('john@example.com')).toBeInTheDocument();
    });

    it('should handle button click', async () => {
        const onSave = jest.fn();
        const user = userEvent.setup();

        render(<UserForm onSave={onSave} />);

        await user.type(screen.getByLabelText(/name/i), 'John');
        await user.click(screen.getByRole('button', { name: /save/i }));

        expect(onSave).toHaveBeenCalledWith({ name: 'John' });
    });
});
```

## Async Testing

```typescript
import { waitFor } from '@testing-library/react';

it('should load user data', async () => {
    const mockUser = { id: 1, name: 'John' };
    jest.spyOn(api, 'fetchUser').mockResolvedValue(mockUser);

    render(<UserProfile userId={1} />);

    expect(screen.getByText(/loading/i)).toBeInTheDocument();

    await waitFor(() => {
        expect(screen.getByText('John')).toBeInTheDocument();
    });
});
```

## Mocking

```typescript
// Mock module
jest.mock('../api/userApi', () => ({
    fetchUser: jest.fn(),
}));

// Mock implementation
import { fetchUser } from '../api/userApi';
const mockFetchUser = fetchUser as jest.MockedFunction<typeof fetchUser>;

mockFetchUser.mockResolvedValue({ id: 1, name: 'John' });

// Mock timers
jest.useFakeTimers();
jest.advanceTimersByTime(1000);
jest.runAllTimers();
```

## Hook Testing

```typescript
import { renderHook, act } from '@testing-library/react';
import { useCounter } from './useCounter';

describe('useCounter', () => {
    it('should increment counter', () => {
        const { result } = renderHook(() => useCounter());

        act(() => {
            result.current.increment();
        });

        expect(result.current.count).toBe(1);
    });
});
```
