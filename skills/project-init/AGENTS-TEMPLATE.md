# <PROJECT_NAME> — Agent Instructions

## Non-Negotiable Rules

1. **Coding standards**: Single responsibility per module and function (target functions ≤40 lines, files ≤300 lines). Separate pure domain logic from boundary side effects (DB, network, storage, framework I/O). Strict type checking (`noImplicitAny`, no unsafe casts). Ship complete, production-ready code — zero `TODO`s, placeholders, or silent suppressions (`@ts-ignore`, `biome-ignore`, `eslint-disable`).
2. **Issue Tracker & Git Host**: Default to native MCP tools where available (passing `<OWNER>/<REPO>`), falling back to CLI (`gh` / `glab`) for read-only queries, watching CI checks, or inside CI runners. Local `git` CLI is permitted.
3. **Domain concepts**: Use exact vocabulary from `GLOSSARY.md` (and never its `_Avoid_` terms). Surface contradictions between code, docs, and glossary before proceeding. Load architecture, spec, design, and ADR docs on demand per **On-Demand Context Routing** below.
4. **Planning & spec changes**: Changes to a ratified spec go in as an ADR (when hard to reverse, surprising without context, or carrying a real trade-off) plus a spec update — never silently.
5. **Design system & tokens**: Consume semantic tokens (`src/styles/tokens.css`) and shared UI primitives (`src/components/ui/`) — no hardcoded colors, fonts, easing, or spacing values; no inline `style` design values. Z-index only via `--z-*` tokens.
6. **Visual source of truth & 3-Tier Surface Gate (`/canvas` → Production → `/styleguide`)**:
   - Precedence: Ratified ADR/issue → `DESIGN.md` & `docs/design/` + `tokens.css` → `/styleguide` catalog & approved model screens → all other references.
   - Routine UI tasks build strictly from ratified `/styleguide` primitives.
   - New screen concepts, shell changes, or compositions with no `/styleguide` precedent trigger the **3-Tier Surface Gate**:
     1. Invoke the `canvas` skill (and `modern-web-guidance` for new interactive primitives), write `docs/design/briefs/<slug>.md`, build in `/canvas` inside real site chrome, run `npm run check` only, and self-critique live `390px` + `1280px` screenshots.
     2. Obtain owner live sign-off on `/canvas` before running `to-spec` / `to-tickets`.
     3. Build production feature with shared components in `src/components/`.
     4. Owner verifies live production screen.
     5. Promote to `/styleguide` by **co-importing those exact shared components** (zero duplicate markup in `/styleguide`) and remove the graduated `/canvas` prototype in the same PR.
7. **Secrets & environment**: `.env*` files are never committed. Privileged/service-role keys are server-only — never imported into client components, never logged, never behind public client env prefixes.
8. **Implementation entry point**: `implement` and `implement-spec` are user-invoked skills. After `to-tickets` publishes tickets, **stop and hand back**: report the ticket list and tell the user to run `/implement` or `/implement-spec`. When authorized to build, invoke `tdd` (`red → green → refactor`) at the highest behavioral seam and pass the Verification Gate.

## On-Demand Context Routing (Read Only What Your Task Touches)

| Task Scope | Read Before Working | Skip Unless Needed |
|---|---|---|
| **Naming, domain terms, copy, or test/issue titles** | `GLOSSARY.md` | `docs/architecture.md`, `docs/spec.md`, `docs/design/*`, `docs/adr/*` |
| **Navigation, site shell, or cross-domain triggers** | `docs/architecture.md` + `GLOSSARY.md` | `docs/design/foundations.md`, unrelated `docs/adr/*` |
| **UI, CSS, `/canvas` spikes, components, or page layout** | `DESIGN.md` + `canvas` skill + relevant `docs/design/*` layer | `docs/spec.md`, `docs/adr/*` |
| **Feature planning (`grill-with-docs`, `to-spec`, `to-tickets`)** | `GLOSSARY.md` + `docs/architecture.md` + relevant `docs/spec.md` + `docs/adr/` | `docs/design/*` (unless UI composition is changing) |
| **Database migrations, RLS, or RPCs** | Relevant database/security ADRs + `docs/architecture.md` | All UI/design docs |
| **Issue tracker, triage, or Wayfinder** | `docs/agents/issue-tracker.md`, `docs/agents/triage-labels.md` | All product/design docs |

## Workflow, Verification & Proportional Tiers (Trunk-Based)

`main` is the sole source of truth. No direct commits to `main`.

1. **Pre-flight (All Tasks)**:
   - Verify clean tree (`git status`); stop immediately on foreign dirt from another session.
   - Sync `main` (`git checkout main && git pull origin main`) and branch (`fix/*`, `style/*`, `content/*`, `feat/*`).
2. **Verification Gate (Mandatory before PR)**:
   - **`/canvas`-only diffs**: Run `npm run check` + live `390px`/`1280px` screenshot self-critique via `canvas` skill only.
   - **All production & `/styleguide` diffs**: Must pass `npm run check && npm test && npm run build` (plus SQL/E2E/visual suites when touching schema, end-to-end flows, or rendered UI).
   - **Feature-Map Law**: Every user-facing capability owns a row in `docs/verification/features.md` and a runnable journey in `npm run verify`.
   - **Premise & Measurement Discipline**:
     - *Attack the Premise*: When two fixes sharing one premise fail the same gate, write the premise down and test it directly before writing a third fix.
     - *Explain the Number*: Before trusting or reporting a measured number (speedup, CI duration, pass count, billing cost), find what limits it (including per-job CI billing rounding) and rule out measuring the wrong work.
     - *Measured Improvement*: Performance and CI work requires a dual baseline on the same green SHA, a target, a decision log, one commit per accepted win, and a revert for anything that does not measurably help.
3. **Pre-PR Review & Merge Gate**:
   - **Run `code-review` BEFORE opening the PR**: For Tier 1.5 and Tier 2 changes, run `code-review` (Standards + Spec axes, Blind Adversarial Contract) locally against `origin/main` *before* `gh pr create`, fix findings, and re-verify so the PR opens clean on its first push.
   - **Merge & Go-Live**: Once required checks are green, squash-merge, record evidence (`implemented` / `verified` / `merged` / `live`), and smoke-probe production.
4. **Proportional Workflow Tiers**:
   - **Tier 1 — Fast-Track (Docs, Copy, Tokens, Localized CSS)**: Preview and batch cosmetic tweaks in live browser (`390px` + `1280px`) first → `npm run check` → self-review diff → single PR → squash merge.
   - **Tier 1.5 — Express Feature & Bug Fix (Clear Scope, 1–4 Files, No New Tables/Auth Models)**: Branch → `tdd` → Verification Gate → Pre-PR `code-review` → PR → squash merge (skips `grill → spec → tickets`).
   - **Tier 2 — Standard Architecture & Multi-Surface Features**: `/canvas` fast loop (when UI composition changes) → `grill-with-docs → to-spec → to-tickets` sliced into **1–3 coarse vertical feature PRs** → hand back to user for `/implement` or `/implement-spec`.
