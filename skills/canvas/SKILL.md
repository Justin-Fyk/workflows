---
name: canvas
description: >-
  Prototype new screens, shell changes, or unratified UI compositions on the
  /canvas workbench. Use when the user invokes /canvas, asks to explore or mock
  a UI layout, or when a task hits a 3-Tier Surface Gate trigger (adding a
  control bar above a section body, changing a control's responsive shape/size,
  or composing UI with no /styleguide precedent).
---

# `/canvas` — UX Research, Host-Chrome Prototyping & Visual Critique

Run this sequence whenever a task introduces a new screen concept, modifies site shell navigation, or hits a **3-Tier Surface Gate** trigger (`docs/design/patterns.md`). Complete each step's **Done when** criterion before starting the next step.

> **Dev-Only Surface Law:** `/canvas` (and `/styleguide`) are internal development and verification workbenches. They must be gated out of public production deployments (e.g., returning `notFound()` when `VERCEL_ENV === "production"`) while remaining active in local development and local visual/E2E test runs.

## Step 1 — Frame & Research (`docs/design/briefs/<slug>.md`)

Before editing any file under the `/canvas` route (`src/app/canvas/`), write or update `docs/design/briefs/<slug>.md` using the structure in [`BRIEF-AND-RUBRIC.md`](BRIEF-AND-RUBRIC.md):

1. **Flow & 5-State Matrix**: Map the user, entry point, action, exit point, and explicit behavior for all five states: **Empty**, **Loading**, **Populated**, **Actionable / Permission-locked**, and **Error / Long-text overflow**.
2. **External Reference Teardown**: Name 2–3 proven industry products (Linear, Instagram/TikTok mobile nav, Facebook desktop drawer, LinkedIn mobile search, Supabase Studio, Stripe Dashboard, Shadcn/Radix) and state for each:
   - **Borrow**: the exact structural or interaction mechanic adapted for this product.
   - **Reject**: the parts of that reference that conflict with the product's visual density or scope.
3. **Component & Token Inventory + Graduation Target**: Map every UI element in the concept to an existing shared primitive (`src/components/ui/`), domain card (`src/components/`), or semantic token (`src/styles/tokens.css`). For every net-new element, classify its **Graduation Target**:
   - **`Reusable Primitive` (Promote to `/styleguide`)**: An atomic control, input, picker, dialog, or card reused across **2+ screens**.
   - **`Feature Screen Composition` (Production Route Only — Do NOT Add to `/styleguide`)**: A page-level layout or single-route view (e.g., Dashboard, Inbox, Profile, Discovery page). Full-page feature screens never get copied into `/styleguide`.
4. **Modern Web Platform Check (`modern-web-guidance`)**: When any element is a `New candidate` involving modals/dialogs/popovers, drawers, responsive data tables, custom selects/forms, scroll/history restoration, or CSS animations, invoke the `modern-web-guidance` skill (`npx -y modern-web-guidance@latest search "<capability>"`) so the prototype uses modern Baseline HTML/CSS/DOM APIs instead of legacy JS workarounds.

**Done when**: `docs/design/briefs/<slug>.md` is written to disk with all three tables populated, graduation targets classified, and zero placeholder cells.

## Step 2 — Build in Host Chrome (`src/app/canvas/`)

Build the interactive prototype in `src/app/canvas/` (and full-viewport preview routes under `src/app/canvas/preview/<slug>/page.tsx` with `robots: { index: false, follow: false }`):

1. **Host-page context**: Mount the concept inside the project's real site shell (primary layout/chrome component, brand header, container tokens, mobile navigation bar) alongside the project's real domain cards/rows and seeded fixture data.
2. **Production visual fidelity**: Consume semantic tokens from `src/styles/tokens.css`, ratified font weights, and real seeded fixture media. Scope `canvas.module.css` strictly to the net-new composition under exploration.
3. **Overlay isolation**: Position drawers, sheets, and popovers with `position: fixed` or `position: absolute` and `--z-overlay` so opening and closing leaves the underlying `--container-content` width unchanged.
4. **Structural variants (`?variant=`)**: When layout structure is an open question (e.g. right-anchored drawer vs. split-pane), wire 2–3 structural variants behind a `?variant=` query parameter on the preview route so the owner can compare them in-browser.

**Done when**: Both `390px` (mobile) and `1280px` (desktop) stages render in `/canvas` using the inventory's existing chrome, primitives, and tokens.

## Step 3 — Fast-Loop Mechanical Check

Run only the project's fast static check (typecheck + lint/format) on `/canvas` work:

```powershell
npm run check
```

`/canvas` diffs (`src/app/canvas/**` and `docs/design/briefs/**`) are exempt from full unit test suites (`npm test`), production builds (`npm run build`), E2E (`test:e2e`), visual regression (`test:visual`), and `code-review`.

**Done when**: `npm run check` exits `0`.

## Step 4 — Live Screenshot Self-Critique (`390px` & `1280px`)

Start or connect to the local dev server, open the `/canvas` preview route in `chrome-devtools-mcp`, capture rendered screenshots at **`390px`** and **`1280px`**, and score them against the **6-Point Perceptual Ergonomics Rubric** in [`BRIEF-AND-RUBRIC.md`](BRIEF-AND-RUBRIC.md).

If any rubric item fails, fix the CSS/JSX in `src/app/canvas/`, re-run `npm run check`, and re-capture the screenshot before presenting to the owner.

**Done when**: Every item in the 6-Point Rubric is recorded as `PASS` in `docs/design/briefs/<slug>.md` against the rendered `390px` and `1280px` screenshots.

## Step 5 — Owner Sign-Off & Graduation Rules (Primitive vs. Feature Screen)

Present to the owner:
1. The link to `docs/design/briefs/<slug>.md` (decisions, reference trade-offs, graduation targets, and any `?variant=` options).
2. The exact `/canvas` preview URLs to inspect at `390px` and `1280px`.
3. Any open product questions.

Stop and wait for explicit owner sign-off before running `to-spec`, `to-tickets`, or writing production components in `src/components/`.

### How Concepts Graduate When Production Ships
Once the production feature is implemented and verified on its live route:
1. **Always delete the graduated `/canvas` prototype** (`src/app/canvas/**` and unused `canvas.module.css` rules) in the production PR so `/canvas` stays an ephemeral workbench.
2. **Promote ONLY Reusable Primitives (`2+` screen consumers) to `/styleguide`:**
   - If the feature introduced a reusable UI primitive (e.g., a shared picker, input, uploader, dialog, or card), co-import that exact shared component from `src/components/ui/` into `/styleguide` inside a `<Specimen>` / `<StateCell>` matrix—with **zero duplicate mock markup** and **zero container-distorting CSS overrides** in `styleguide.module.css`.
3. **Never Put Full-Page Feature Screens Into `/styleguide`:**
   - Page-level compositions and single-route views (e.g., Dashboard, Discovery feed, Inbox, Profile page) **do not belong in `/styleguide`**—stuffing full-width screens with viewport media queries and sticky headers into narrow `<StateCell>` boxes distorts their layout and creates maintenance bloat.
   - Instead, the **shipped production route itself** (backed by deterministic seeded fixtures, `test:visual` baselines at `390px` & `1280px`, and `npm run verify` feature-map journeys) serves as the canonical **Model Screen**.
