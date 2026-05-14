# Frontend Design System

## Color System - Teal Primary with shadcn/ui

The project uses **shadcn/ui** standard color variables with **oklch()** color format. Primary color is **teal** (`oklch(0.5982 0.10687 182.4689)`).

**Key CSS Variables** (defined in `src/index.css`):

```css
:root {
  --radius: 0.625rem;                         /* Border radius (10px) */
  --background: oklch(1 0 0);                 /* Page background (white) */
  --foreground: oklch(0.145 0 0);             /* Primary text (near-black) */
  --card: oklch(1 0 0);                       /* Card background (white) */
  --primary: oklch(0.5982 0.10687 182.4689);  /* Teal primary */
  --primary-foreground: oklch(0.985 0 0);     /* Text on primary (white) */
  --muted-foreground: oklch(0.556 0 0);       /* Secondary/muted text */
  --border: oklch(0.922 0 0);                 /* Borders */
  --destructive: oklch(0.577 0.245 27.325);   /* Error/destructive (red) */
}
```

**Tailwind Usage** (standard shadcn/ui classes):

```tsx
className="bg-background text-foreground"      // Page background + text
className="bg-card border-border"              // Card/panel
className="bg-primary text-primary-foreground" // Primary button
className="text-muted-foreground"              // Secondary/muted text
```

## Button Variants

Available variants from `src/components/ui/button.tsx`:

| Variant | Usage |
|---|---|
| `default` | Primary action button (teal background) |
| `destructive` | Delete/danger actions (red) |
| `outline` | Secondary actions, bordered |
| `secondary` | Alternative secondary (gray background) |
| `ghost` | Minimal, hover-only background |
| `link` | Text-only with underline on hover |

```tsx
// Primary action uses variant="default" (NOT variant="primary")
<Button onClick={onSave}>Save</Button>
<Button variant="outline" onClick={onCancel}>Cancel</Button>
<Button variant="destructive" onClick={onDelete}>Delete</Button>
```

## Typography

| Element | Class |
|---|---|
| Page title (H1) | `text-2xl font-bold tracking-tight` |
| Section heading (H2/H3) | `text-lg font-semibold` |
| Body text | `text-sm` |
| Small/muted text | `text-xs text-muted-foreground` |

## Responsive Breakpoints

- Mobile: `max-width: 767px` (breakpoint 768)
- Tablet: `768px - 1023px`
- Desktop: `min-width: 1024px`

```tsx
import { useIsMobile } from "@/hooks/useMobile"

const isMobile = useIsMobile() // true if window.innerWidth < 768
```

> Note: Only `useIsMobile` hook exists. For desktop detection, use `!isMobile`.
