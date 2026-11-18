---
name: design-system
description: Define, document, audit, or improve a project's visual design system on request — tokens, typography, color, spacing, components, states, and accessibility. Run only when the user explicitly asks for design-system work; not for routine CSS/UI edits.
---

# Design System

Codify or evaluate a project's visual design system. Three modes; the request determines which one runs.

## Modes

1. **Research** — analyze competitor or reference designs and accessibility baselines. Output: research report.
2. **Audit** — evaluate an existing product for consistency, accessibility, and quality. Output: audit report.
3. **Define** — produce or update the project's design specification (`design.md` or equivalent). Output: the specification.

Detailed workflows for each mode live in [REFERENCE.md](REFERENCE.md); output templates in [EXAMPLES.md](EXAMPLES.md).

## Core Principles

- **Tokens over values** — semantic tokens, never raw hex or pixel values in components.
- **Hard cases first** — specify error, empty, loading, and narrow-viewport states.
- **Actionable audits** — every identified issue gets a path to fix.
- **Accessibility baseline** — WCAG 2.2 AA: 4.5:1 text contrast, keyboard operability, visible focus, targets at least 24px (44px recommended on touch).

## Integration

If the project has a brand-voice or tone-of-voice document, align the visual direction with it: the design system and the voice express one character.
