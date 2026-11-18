# `Justin-Fyk/workflows` — Instructions for Agents Updating This Repository

This repository is the **universal central source of truth** for global agent rules (`rules/`), portable engineering and UX skills (`skills/`), architectural playbooks (`docs/`), and monthly CTO workflow reviews (`reviews/`).

Any agent reading, applying, or updating this repository **MUST** obey the four non-negotiable laws below.

---

## 1. Universal & Project-Agnostic Law (Zero Single-Project Coupling)

Everything under `skills/`, `rules/`, and `docs/` must remain **100% universal and applicable to any software project**:
- **Never hardcode single-project artifacts** (such as project-specific repository names, local drive paths like `D:\PROJECTS\...`, domain-specific component names like `DjCard`, or bespoke routes) inside `skills/` or `rules/`.
- When a lesson is learned on a specific project (during `/retro`, `/correct`, or a monthly checkpoint), record the empirical case study in `reviews/YYYY-MM-DD-*.md` if helpful, **then generalize the principle** before encoding it into `skills/project-init/checklist.md`, `rules/GEMINI.md`, `rules/AGENTS-TEMPLATE.md`, or individual `SKILL.md` files.

---

## 2. The Adoption Precedence Law: Override Conflicting Processes, Preserve Project Identity

Whenever an agent uses this repository to onboard or upgrade a target project (via [`/project-init`](skills/project-init/SKILL.md) or [`/project-adopt`](skills/project-adopt/SKILL.md)), or whenever a future agent edits our onboarding skills and templates, this strict two-part boundary must be preserved and emphasized:

### A. OVERRIDE Conflicting Workflow, Verification & Quality Mechanics
If an existing target project has weaker, ad-hoc, or conflicting *development processes*, **this operating system overrides and replaces them**:
- **Planning & Slicing:** Overrides ungrilled implementation or 8–10 micro-ticket breakdowns with proportional tiers (Tier 1 / 1.5 / 2) and **1–3 coarse vertical feature slices** (`/sharpen` → `/grill-with-docs` → `/to-spec` [with Spec Goldfish] → `/to-tickets`).
- **UI Prototyping Gate:** Overrides unratified in-place UI edits or duplicate styleguide markup with the **3-Tier Surface Gate** (`/canvas` fast loop + `modern-web-guidance` → Production → co-imported `/styleguide`).
- **Build, Floor Guard & Review Order:** Overrides post-hoc testing, post-PR code reviews, and self-justifying reviews with **TDD (`red → green → refactor`)**, **Anti-Cheating Floor Guards** (blocking `@ts-ignore`, `biome-ignore`, `eslint-disable`, `.skip`, `.todo`, or deleted test assertions), **Feature-Map Runtime Verification** (`npm run verify`), and **Pre-PR Blind Adversarial `/code-review`** (`ARTIFACT + CONTRACT` only, run locally against `origin/main` *before* opening a PR).
- **CI & Quota Discipline:** Overrides multi-VM 1-minute-rounding traps, duplicate pre/post-merge E2E runs, and file-writing CI jobs with read-only `check:ci` and single-VM job consolidation.

### B. PRESERVE 100% of the Target Project's Identity, Stack, Domain & Custom Rules
**Never instruct an agent to blindly overwrite an existing project's `AGENTS.md`, `CLAUDE.md`, or architecture docs.** Always perform a **surgical merge** that preserves 100% of the target project's:
- **Tech Stack & Tooling:** Language, framework, package manager, test runner, linter, database, and hosting choices (adapting gate commands to match the project's stack).
- **Domain Model & Architecture:** Existing `GLOSSARY.md` vocabulary, ratified ADRs (`docs/adr/`), database schemas, RLS/auth models, module boundaries, and API contracts.
- **Visual Design System:** Brand identity, color/typography/spacing tokens (`tokens.css`), `DESIGN.md`, and ratified component library.
- **Project-Specific Non-Negotiables:** Any custom business, compliance, security, billing/egress, or environment rules already defined by that project.

---

## 3. Vendor-Neutral Model Routing Law (Multi-Provider & OpenRouter Safe)

- **Never hardcode vendor-specific model names or slugs** (e.g., `gemini-4-carbon`, `claude-opus`, `gpt-5`) inside any `SKILL.md` file.
- Skills must default to **inheriting the active session model (`inherit`)** so they work without error across Google Antigravity, Claude Code, Cursor, Codex, OpenCode, Kilo, and **OpenRouter**.
- Keep model routing governed by the three vendor-neutral capability tiers in [`rules/GEMINI.md`](rules/GEMINI.md) and [`docs/model-routing-and-ci-economics.md`](docs/model-routing-and-ci-economics.md):
  1. **Fast Scout Tier (Optional):** Generic `"flash"` / `"fast"` flag strictly for mechanical, zero-judgment read-only lookups when supported by the native harness; omit (`inherit`) on OpenRouter.
  2. **Daily-Driver Workhorse Tier (`inherit` — >90% of work):** Always inherits the user's active session model.
  3. **Deep-Reasoning Frontier Tier (<10% of work — Human-Triggered Only):** Never auto-invoked; recommended to the human only after a 2-strike verification failure (*Attack the Premise*).

---

## 4. Self-Contained Skills & Sync Hygiene

1. **Zero Broken Relative Links:** Every skill under `skills/<name>/` must bundle its own required reference files (`references/*.md`, templates, or checklists) or point to a sibling skill inside `skills/` that is guaranteed to exist in this repository.
2. **Checklist as Single Source of Truth:** When adding a new project guardrail, update [`skills/project-init/checklist.md`](skills/project-init/checklist.md) and [`rules/AGENTS-TEMPLATE.md`](rules/AGENTS-TEMPLATE.md) together so [`project-init`](skills/project-init/SKILL.md) and [`project-adopt`](skills/project-adopt/SKILL.md) stay in sync.
3. **Sync Local Machine After Updating Repo:** Whenever you modify `skills/` or `rules/` in this repository, run `scripts/sync.ps1 -Pull` (Windows) or `scripts/sync.sh --pull` (macOS/Linux) so the local machine's `~/.gemini/config/skills/` and `~/.gemini/GEMINI.md` reflect the committed state immediately.
