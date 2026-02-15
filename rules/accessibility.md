# Accessibility Rules

Mandatory WCAG 2.1 AA compliance for all user interfaces.

## Target Standard

**WCAG 2.1 AA** — minimum for all UI work.

## Semantic Structure

### HTML Elements

- Use native HTML elements: `<nav>`, `<main>`, `<article>`, `<button>`, `<table>`
- Never use `<div>` or `<span>` for interactive elements
- Landmark regions: `<header>`, `<nav>`, `<main>`, `<footer>`, `<aside>`

### Headings

- Logical hierarchy: h1 → h2 → h3
- No skipped levels
- Single `<h1>` per page
- Descriptive `<title>` for each page

## Keyboard Accessibility

### Requirements

- All interactive elements reachable via Tab/Shift+Tab
- Operable with: Enter, Space, Escape, Arrow keys
- Visible focus indicator on all focusable elements
- Focus order follows logical reading order

### Focus Management

- Never `outline: none` without replacement
- Trap focus in modals
- Return focus on modal close
- Skip-to-content link on pages with navigation

### Custom Widgets

- Implement WAI-ARIA keyboard patterns
- Add `tabIndex` for focusability
- Handle keyboard events (Enter, Space, Escape, Arrows)

## ARIA Usage

### Rules

- Use ARIA only when native HTML insufficient
- Prefer native elements: `<button>` over `<div role="button">`
- All ARIA attributes must be valid for the role

### Required ARIA

| Element | ARIA |
|---------|------|
| Icon button | `aria-label` or `aria-labelledby` |
| Form input | Associated `<label>` or `aria-label` |
| Dynamic content | `aria-live` region |
| Modal dialog | `role="dialog" aria-modal="true"` |
| Current page | `aria-current="page"` |

### Images

- Meaningful images: descriptive `alt` text
- Decorative images: `alt=""`
- Complex images: `aria-describedby` for long description

## Visual Requirements

### Color Contrast

| Text Type | Minimum Ratio |
|-----------|---------------|
| Normal text | 4.5:1 |
| Large text (18pt+) | 3:1 |
| UI components | 3:1 |

### Color Independence

- Never convey information by color alone
- Use text, icons, or patterns as supplements
- Test in grayscale

### Text Sizing

- Resizable to 200% without loss of content
- No horizontal scrolling at 200%
- Relative units (rem, em) for font sizes

### Motion

- No content flashing >3 times/second
- Respect `prefers-reduced-motion`
- Provide pause/stop for animations

## Forms

### Labels

- Visible label for every input
- Associate with `for` attribute or `aria-labelledby`
- Never rely on placeholder alone

### Error Handling

- Specific error messages
- Associate with field: `aria-describedby` or `aria-errormessage`
- Announce errors to screen readers
- Indicate required fields: `required` attribute + visual indicator

### Touch Targets

- Minimum 44×44 CSS pixels
- Adequate spacing between targets

## Tables

### Requirements

- Use `<table>` for tabular data
- `<th>` with `scope` for headers
- `<caption>` for table description
- Avoid layout tables

## Media

### Video

- Captions required
- Audio descriptions for visual content
- Transcript available

### Audio

- Transcript required
- Controls accessible

## Testing Requirements

### Automated

- axe-core or pa11y in CI
- Zero critical/serious violations
- Lighthouse Accessibility audit

### Manual

- Keyboard-only navigation test
- Screen reader test (NVDA, VoiceOver, or JAWS)
- Color contrast verification
- 200% zoom test

### Test Patterns

```javascript
// jest-axe example
import { axe } from 'jest-axe';
expect(await axe(container)).toHaveNoViolations();
```

## Common Patterns

### Accessible Button

```html
<button type="submit" aria-label="Search">
  <svg aria-hidden="true">...</svg>
</button>
```

### Accessible Form Field

```html
<label for="email">Email Address</label>
<input 
  type="email" 
  id="email" 
  name="email"
  required
  aria-describedby="email-error"
>
<span id="email-error" role="alert"></span>
```

### Accessible Modal

```html
<div role="dialog" aria-modal="true" aria-labelledby="modal-title">
  <h2 id="modal-title">Confirm Action</h2>
  <!-- content -->
</div>
```

### Skip Link

```html
<a href="#main-content" class="skip-link">
  Skip to main content
</a>
<!-- navigation -->
<main id="main-content">
  <!-- content -->
</main>
```

## CLI/API Accessibility

### CLI

- `--help` output available
- Structured error messages
- Support `NO_COLOR` environment variable

### API

- Human-readable error messages
- Standard HTTP status codes
- Documented error response format
