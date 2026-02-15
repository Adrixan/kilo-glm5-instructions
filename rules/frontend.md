# Frontend Development Rules

Rules for React, Vue, TypeScript, HTML5, and CSS development.

## TypeScript 5.6+

### Configuration

```json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noUncheckedSideEffectImports": true,
    "exactOptionalPropertyTypes": true
  }
}
```

### Standards

- Explicit types for function signatures
- Union types over enums for string literals
- No `any` — use `unknown` and narrow
- `satisfies` operator for type-safe objects
- `using` declarations for resource cleanup

---

## React 19 / Next.js 15

### Components

- Functional components only (no classes)
- React Compiler for automatic memoization
- Remove manual `useMemo`/`useCallback` where compiler handles it

### New Features

- **Actions** for form handling: `useActionState`, `useFormStatus`
- **`use()` hook** for reading promises/context in render
- **React Server Components** as default
- **Partial Prerendering** for hybrid pages
- **Turbopack** as default dev bundler

### State Management

- Context API for simple state
- Zustand for complex state
- Redux only for existing codebases

### Component Patterns

```tsx
// ❌ NEVER
users.push(newUser);

// ✅ ALWAYS
setUsers(prev => [...prev, newUser]);
```

### Keys

```tsx
// ❌ NEVER
{items.map((item, index) => <Item key={index} />)}

// ✅ ALWAYS
{items.map(item => <Item key={item.id} />)}
```

---

## HTML5

### Semantic Elements

- `<header>`, `<nav>`, `<main>`, `<article>`, `<aside>`, `<footer>`
- `<nav aria-label="...">` for navigation landmarks
- `<dialog>` for modals (replaces custom divs)
- Popover API for tooltips/dropdowns

### Headings

- Order: h1 → h2 → h3 (never skip)
- Single `<h1>` per page

---

## CSS

### Architecture

- Mobile-first media queries (`min-width` breakpoints)
- CSS Grid/Flexbox for layout (no floats)
- CSS Variables for theming
- Container queries for component responsiveness
- `@layer` for cascade management

### Modern Features

- `color-mix()` for dynamic theming
- Relative color syntax
- CSS Modules or Tailwind for scoping

### Dark Mode

```css
@media (prefers-color-scheme: dark) {
  :root {
    --bg: #1a1a1a;
    --text: #f5f5f5;
  }
}
```

### Reduced Motion

```css
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

---

## Internationalization (i18n)

### Mandatory

- Never hardcode user-visible strings
- Use i18n keys for all text

```tsx
// ❌ NEVER
<button>Submit</button>

// ✅ ALWAYS
<button>{t('form.submit')}</button>
```

### Libraries

- React: react-i18next
- Vue: vue-i18n
- Next.js: next-intl

### Formatting

- Dates: `Intl.DateTimeFormat`
- Numbers: `Intl.NumberFormat`
- Never manual formatting

---

## Performance

### Code Splitting

- `lazy()` + `<Suspense>` for route-level splitting
- React Server Components for zero-JS server rendering

### Images

- Next.js `<Image>` or `<picture>` with WebP/AVIF
- Always include `alt` and dimensions
- Lazy loading for below-fold images

### Bundle Size

- Initial JS <200KB gzipped
- Tree-shake imports: `import debounce from 'lodash/debounce'`

### Caching

- TanStack Query for server state
- React `cache()` for request deduplication

### Core Web Vitals

| Metric | Target |
|--------|--------|
| LCP | <2.5s |
| INP | <200ms |
| CLS | <0.1 |

---

## Security

### XSS Prevention

- React escapes by default — don't bypass
- Never use `dangerouslySetInnerHTML` without `DOMPurify.sanitize()`
- Sanitize all dynamic content

### CSP

```
Content-Security-Policy: default-src 'self'; script-src 'self' 'nonce-xxx'
```

### Authentication

- JWTs in httpOnly cookies (not localStorage)
- CSRF tokens for state-changing operations
- Auto-logout on inactivity

### Third-Party Scripts

- Audit and pin versions
- Use CSP to restrict scope

---

## Testing

### Coverage

| Type | Tool | Target |
|------|------|--------|
| Unit | Vitest | 100% for utilities |
| Component | React Testing Library | 80% |
| E2E | Playwright | Critical flows |
| A11y | jest-axe | All components |

### Patterns

```tsx
// Component test
render(<UserCard user={mockUser} />);
expect(screen.getByText(mockUser.name)).toBeInTheDocument();

// Accessibility test
const { container } = render(<UserCard user={mockUser} />);
expect(await axe(container)).toHaveNoViolations();
```

---

## Common Pitfalls

| Issue | Solution |
|-------|----------|
| `key={index}` | Use stable unique IDs |
| Prop drilling >2 levels | Context or Zustand |
| Missing deps in useEffect | Include all referenced variables |
| No loading/error states | Always handle async states |
| Manual memoization everywhere | Let React Compiler handle it |

---

## State Management Decision

| Complexity | Solution |
|------------|----------|
| Simple (theme, user) | Context API |
| Medium (forms, filters) | Zustand |
| Complex (real-time, sync) | TanStack Query + Zustand |
| Legacy | Redux (existing only) |
