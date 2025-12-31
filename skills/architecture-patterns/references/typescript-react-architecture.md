# TypeScript/React Architecture Patterns

## Component Architecture

### Directory Structure (Feature-Based)
```
src/
├── features/
│   └── users/
│       ├── components/
│       │   ├── UserList.tsx
│       │   ├── UserCard.tsx
│       │   └── UserForm.tsx
│       ├── hooks/
│       │   ├── useUsers.ts
│       │   └── useUserForm.ts
│       ├── services/
│       │   └── userService.ts
│       ├── types/
│       │   └── user.types.ts
│       └── index.ts
├── shared/
│   ├── components/
│   ├── hooks/
│   ├── utils/
│   └── types/
└── App.tsx
```

### Minimal Approach
```typescript
// UserList.tsx - everything in one component
import { useState, useEffect } from 'react';

export function UserList() {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    setLoading(true);
    fetch('/api/users')
      .then(r => r.json())
      .then(setUsers)
      .finally(() => setLoading(false));
  }, []);

  if (loading) return <div>Loading...</div>;

  return (
    <div>
      {users.map(u => (
        <div key={u.id}>{u.name}</div>
      ))}
    </div>
  );
}
```

### Clean Approach
```typescript
// types/user.types.ts
export interface User {
  id: number;
  name: string;
  email: string;
}

export interface UserListProps {
  onUserSelect?: (user: User) => void;
}

// services/userService.ts
import type { User } from '../types/user.types';

export class UserService {
  private baseUrl = '/api/users';

  async getAll(): Promise<User[]> {
    const response = await fetch(this.baseUrl);
    if (!response.ok) {
      throw new Error('Failed to fetch users');
    }
    return response.json();
  }

  async getById(id: number): Promise<User> {
    const response = await fetch(`${this.baseUrl}/${id}`);
    if (!response.ok) {
      throw new Error(`User ${id} not found`);
    }
    return response.json();
  }
}

export const userService = new UserService();

// hooks/useUsers.ts
import { useState, useEffect } from 'react';
import { userService } from '../services/userService';
import type { User } from '../types/user.types';

interface UseUsersReturn {
  users: User[];
  loading: boolean;
  error: Error | null;
  refetch: () => void;
}

export function useUsers(): UseUsersReturn {
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<Error | null>(null);

  const fetchUsers = async () => {
    setLoading(true);
    setError(null);
    try {
      const data = await userService.getAll();
      setUsers(data);
    } catch (err) {
      setError(err as Error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchUsers();
  }, []);

  return { users, loading, error, refetch: fetchUsers };
}

// components/UserList.tsx
import { useUsers } from '../hooks/useUsers';
import { UserCard } from './UserCard';
import type { UserListProps } from '../types/user.types';

export function UserList({ onUserSelect }: UserListProps) {
  const { users, loading, error } = useUsers();

  if (loading) return <LoadingSpinner />;
  if (error) return <ErrorMessage error={error} />;

  return (
    <div className="user-list">
      {users.map(user => (
        <UserCard
          key={user.id}
          user={user}
          onClick={() => onUserSelect?.(user)}
        />
      ))}
    </div>
  );
}

// components/UserCard.tsx
import type { User } from '../types/user.types';

interface UserCardProps {
  user: User;
  onClick?: () => void;
}

export function UserCard({ user, onClick }: UserCardProps) {
  return (
    <div className="user-card" onClick={onClick}>
      <h3>{user.name}</h3>
      <p>{user.email}</p>
    </div>
  );
}
```

### Pragmatic Approach
```typescript
// types/user.types.ts
export interface User {
  id: number;
  name: string;
  email: string;
}

// hooks/useUsers.ts
import { useState, useEffect } from 'react';
import type { User } from '../types/user.types';

export function useUsers() {
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    setLoading(true);
    fetch('/api/users')
      .then(r => r.json())
      .then(setUsers)
      .catch(console.error)
      .finally(() => setLoading(false));
  }, []);

  return { users, loading };
}

// components/UserList.tsx
import { useUsers } from '../hooks/useUsers';

export function UserList() {
  const { users, loading } = useUsers();

  if (loading) return <div>Loading...</div>;

  return (
    <div>
      {users.map(user => (
        <div key={user.id}>
          <h3>{user.name}</h3>
          <p>{user.email}</p>
        </div>
      ))}
    </div>
  );
}
```

## State Management

### Local State (Minimal)
```typescript
function UserProfile() {
  const [user, setUser] = useState<User | null>(null);
  return <div>{user?.name}</div>;
}
```

### Context API (Pragmatic)
```typescript
// contexts/UserContext.tsx
import { createContext, useContext, useState, ReactNode } from 'react';

interface UserContextType {
  currentUser: User | null;
  setCurrentUser: (user: User | null) => void;
}

const UserContext = createContext<UserContextType | undefined>(undefined);

export function UserProvider({ children }: { children: ReactNode }) {
  const [currentUser, setCurrentUser] = useState<User | null>(null);

  return (
    <UserContext.Provider value={{ currentUser, setCurrentUser }}>
      {children}
    </UserContext.Provider>
  );
}

export function useUserContext() {
  const context = useContext(UserContext);
  if (!context) {
    throw new Error('useUserContext must be used within UserProvider');
  }
  return context;
}

// Usage
function App() {
  return (
    <UserProvider>
      <UserProfile />
    </UserProvider>
  );
}

function UserProfile() {
  const { currentUser } = useUserContext();
  return <div>{currentUser?.name}</div>;
}
```

### Redux (Clean - for complex state)
```typescript
// store/userSlice.ts
import { createSlice, PayloadAction } from '@reduxjs/toolkit';
import type { User } from '../types/user.types';

interface UserState {
  currentUser: User | null;
  users: User[];
  loading: boolean;
}

const initialState: UserState = {
  currentUser: null,
  users: [],
  loading: false,
};

const userSlice = createSlice({
  name: 'user',
  initialState,
  reducers: {
    setCurrentUser(state, action: PayloadAction<User | null>) {
      state.currentUser = action.payload;
    },
    setUsers(state, action: PayloadAction<User[]>) {
      state.users = action.payload;
    },
    setLoading(state, action: PayloadAction<boolean>) {
      state.loading = action.payload;
    },
  },
});

export const { setCurrentUser, setUsers, setLoading } = userSlice.actions;
export default userSlice.reducer;
```

## API Layer Design

### Minimal: Direct fetch in components
```typescript
const response = await fetch('/api/users');
const users = await response.json();
```

### Pragmatic: Simple service functions
```typescript
// services/api.ts
export async function getUsers(): Promise<User[]> {
  const response = await fetch('/api/users');
  if (!response.ok) throw new Error('Failed to fetch');
  return response.json();
}

export async function createUser(user: CreateUserDto): Promise<User> {
  const response = await fetch('/api/users', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(user),
  });
  if (!response.ok) throw new Error('Failed to create');
  return response.json();
}
```

### Clean: API client class with interceptors
```typescript
// services/apiClient.ts
class ApiClient {
  private baseUrl: string;

  constructor(baseUrl: string = '/api') {
    this.baseUrl = baseUrl;
  }

  private async request<T>(
    endpoint: string,
    options?: RequestInit
  ): Promise<T> {
    const url = `${this.baseUrl}${endpoint}`;
    const response = await fetch(url, {
      ...options,
      headers: {
        'Content-Type': 'application/json',
        ...options?.headers,
      },
    });

    if (!response.ok) {
      throw new ApiError(response.status, await response.text());
    }

    return response.json();
  }

  async get<T>(endpoint: string): Promise<T> {
    return this.request<T>(endpoint);
  }

  async post<T>(endpoint: string, data: unknown): Promise<T> {
    return this.request<T>(endpoint, {
      method: 'POST',
      body: JSON.stringify(data),
    });
  }

  async put<T>(endpoint: string, data: unknown): Promise<T> {
    return this.request<T>(endpoint, {
      method: 'PUT',
      body: JSON.stringify(data),
    });
  }

  async delete<T>(endpoint: string): Promise<T> {
    return this.request<T>(endpoint, { method: 'DELETE' });
  }
}

export const apiClient = new ApiClient();

// services/userService.ts
export const userService = {
  getAll: () => apiClient.get<User[]>('/users'),
  getById: (id: number) => apiClient.get<User>(`/users/${id}`),
  create: (user: CreateUserDto) => apiClient.post<User>('/users', user),
  update: (id: number, user: UpdateUserDto) =>
    apiClient.put<User>(`/users/${id}`, user),
  delete: (id: number) => apiClient.delete(`/users/${id}`),
};
```

## Error Handling

### Error Boundary
```typescript
// components/ErrorBoundary.tsx
import { Component, ReactNode } from 'react';

interface Props {
  children: ReactNode;
  fallback?: ReactNode;
}

interface State {
  hasError: boolean;
  error: Error | null;
}

export class ErrorBoundary extends Component<Props, State> {
  state: State = { hasError: false, error: null };

  static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error, errorInfo: React.ErrorInfo) {
    console.error('Error caught by boundary:', error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      return this.props.fallback || (
        <div>
          <h2>Something went wrong</h2>
          <p>{this.state.error?.message}</p>
        </div>
      );
    }

    return this.props.children;
  }
}

// Usage
<ErrorBoundary>
  <UserList />
</ErrorBoundary>
```

## Testing

### Minimal
```typescript
import { render, screen } from '@testing-library/react';
import { UserList } from './UserList';

test('renders users', () => {
  render(<UserList />);
  expect(screen.getByText(/users/i)).toBeInTheDocument();
});
```

### Clean
```typescript
// UserList.test.tsx
import { render, screen, waitFor } from '@testing-library/react';
import { rest } from 'msw';
import { setupServer } from 'msw/node';
import { UserList } from './UserList';

const mockUsers = [
  { id: 1, name: 'John', email: 'john@example.com' },
  { id: 2, name: 'Jane', email: 'jane@example.com' },
];

const server = setupServer(
  rest.get('/api/users', (req, res, ctx) => {
    return res(ctx.json(mockUsers));
  })
);

beforeAll(() => server.listen());
afterEach(() => server.resetHandlers());
afterAll(() => server.close());

describe('UserList', () => {
  it('displays loading state initially', () => {
    render(<UserList />);
    expect(screen.getByText(/loading/i)).toBeInTheDocument();
  });

  it('displays users after loading', async () => {
    render(<UserList />);
    await waitFor(() => {
      expect(screen.getByText('John')).toBeInTheDocument();
      expect(screen.getByText('Jane')).toBeInTheDocument();
    });
  });

  it('displays error on fetch failure', async () => {
    server.use(
      rest.get('/api/users', (req, res, ctx) => {
        return res(ctx.status(500));
      })
    );

    render(<UserList />);
    await waitFor(() => {
      expect(screen.getByText(/error/i)).toBeInTheDocument();
    });
  });
});
```

## Trade-offs Summary

| Aspect | Minimal | Pragmatic | Clean |
|--------|---------|-----------|-------|
| Component Size | Large (100-200 LOC) | Medium (50-100 LOC) | Small (20-50 LOC) |
| State Management | useState only | Context for shared | Redux/Zustand |
| API Layer | Inline fetch | Service functions | API client class |
| Type Safety | Basic types | Interfaces for main types | Full type coverage |
| Error Handling | try-catch | Error boundaries | Global error handling |
| Testing | Basic smoke tests | Critical path tests | Full coverage |
| File Count | 1-3 | 5-8 | 10-15 |
| Time to Implement | Hours | 1-2 days | 2-4 days |
