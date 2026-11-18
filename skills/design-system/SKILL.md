---
name: design-system
description: Define, document, audit, or improve a project's visual design system on request — tokens, typography, color, spacing, components, states, and accessibility. Run only when the user explicitly asks for design-system work; not for routine CSS/UI edits.
---

# Design System

Codify or evaluate a project's visual design system. Three modes; the request determines which one runs.

## Modes

1. **Research** — analyze competitor or reference designs and accessibility baselines. Output: research report.
2. **Audit** — evaluate an existing product (and its `/styleguide` catalog) for consistency, drift, accessibility, and quality. Output: audit report.
3. **Define** — produce or update the project's design specification (`DESIGN.md` / `docs/design/`). Output: the specification.

Detailed workflows for each mode live in [REFERENCE.md](REFERENCE.md); output templates in [EXAMPLES.md](EXAMPLES.md).

## Core Principles

- **Tokens over values** — semantic tokens (`tokens.css`), never raw hex or pixel values in components.
- **Hard cases first** — specify error, empty, loading, actionable/permission-locked, and narrow-viewport (`390px`) states.
- **Actionable audits** — every identified issue gets a path to fix.
- **Accessibility baseline** — WCAG 2.2 AA: 4.5:1 text contrast, keyboard operability, visible focus, targets at least 24px (44px on touch).

## The 3-Surface Design Architecture (Never Conflate Primitives with Feature Screens)

Keep design tokens, `DESIGN.md`, `/canvas`, and `/styleguide` **inside the project repository** so TypeScript imports and design-law checks verify them atomically, while splitting visual surfaces into three strict roles:

1. **`/canvas` (Ephemeral Prototyping Workbench — Dev Only):**
   - Used via the `canvas` skill to prototype new screens, shell changes, or unratified primitives inside real site chrome at `390px` and `1280px` on the fast loop (`npm run check` only).
   - **Deleted immediately** once the production feature ships.
2. **`/styleguide` (Lean Atomic Primitive Catalog — Dev Only):**
   - Holds **ONLY Foundations** (Colors, Typography, Spacing, Radii, Elevation) + **Reusable UI Primitives** (`src/components/ui/*`, `controls.css`, `SaveBand`) + **Shared Domain Cards** reused across **2+ screens**.
   - **Zero Full-Page Feature Screens:** Page-level feature views (e.g., Dashboard, Inbox, Discovery page, Profile page) never belong in `/styleguide`. Stuffing full-width screens with viewport media queries and `position: sticky` headers into narrow `<StateCell>` boxes distorts their layout and creates massive maintenance bloat.
   - **Zero Fake Replicas (100% Real Imports):** Every `/styleguide` specimen must import the real shared component from `src/components/`—defining fake copy-pasted mock components or layout-distorting CSS overrides inside `src/app/styleguide/` is a defect (and should be blocked by `check:design`).
3. **Live Model Screens (Shipped Production Routes):**
   - Once a feature screen ships on its real route, **that production route** (backed by deterministic seeded fixtures, `test:visual` baselines at `390px` & `1280px`, and `npm run verify` journeys) is the canonical reference for page composition and is listed in `DESIGN.md`'s Model Screens table.

> **Production Environment Gate:** Both `/canvas` and `/styleguide` must return `notFound()` in public production deployments (`VERCEL_ENV === "production"`) so internal sandboxes and catalogs never ship on the live customer-facing website.

## Integration

If the project has a brand-voice or tone-of-voice document (`docs/design/content.md`, `GLOSSARY.md`), align the visual direction with it: the design system and the voice express one character.
