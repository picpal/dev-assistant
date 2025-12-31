# TypeScript/React Greenfield Template

Starter template for new React projects with TypeScript and Vite.

## Project Structure

```
my-react-app/
├── public/
├── src/
│   ├── features/
│   │   └── [feature]/
│   │       ├── components/
│   │       ├── hooks/
│   │       ├── services/
│   │       └── types/
│   ├── shared/
│   │   ├── components/
│   │   ├── hooks/
│   │   ├── services/
│   │   ├── types/
│   │   └── utils/
│   ├── App.tsx
│   └── main.tsx
├── .env.example
├── package.json
├── tsconfig.json
├── vite.config.ts
└── README.md
```

## Included Features

- React 18+
- TypeScript 5+
- Vite for build tool
- React Router for routing
- Axios for HTTP client
- ESLint + TypeScript ESLint
- Vitest for testing
- React Testing Library
- Path aliases (@/* for src/*)

## Getting Started

1. Copy `.env.example` to `.env` and configure
2. Install dependencies: `npm install`
3. Start dev server: `npm run dev`
4. Build for production: `npm run build`

## Conventions

- **Feature-based structure**: Group by feature, not by type
- **Functional components**: Use functions, not classes
- **Custom hooks**: Extract reusable logic
- **TypeScript strict mode**: Full type safety
- **Component props**: Always define interfaces
- **API layer**: Separate service functions
- **Testing**: Jest + RTL for components

## Reference

See `skills/architecture-patterns/references/typescript-react-architecture.md` for detailed patterns.
