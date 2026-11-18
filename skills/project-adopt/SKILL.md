---
name: project-adopt
description: Audit an existing project against your operating-system checklist, merge workflow guardrails without losing project-specific rules, and turn remaining gaps into scored, ready-to-run tickets. Use when adopting an existing repo (even a freshly scaffolded one), porting workflow learnings to another project, retrofitting guardrails mid-flight, or running a project health check. For brand-new empty repos, use project-init instead.
license: MIT
metadata:
  author: non-coder-ai-workflow
  version: "1.2"
---

# Project Adoption

Retrofit an existing project onto the operating system. Most lessons apply mid-flight, not at birth; this skill is the reusable version of that retrofit.

## Precedence Law: Override Conflicting Processes, Preserve Project Identity

When adopting an existing project (or merging [`../project-init/AGENTS-TEMPLATE.md`](../project-init/AGENTS-TEMPLATE.md) into an existing `AGENTS.md` / `CLAUDE.md`), apply this strict two-part rule—**never perform a blind file overwrite**:

### 1. What This Operating System OVERRIDES (Workflow, Verification & Quality Mechanics)
Where the existing project's instructions, habits, or CI setup conflict with this operating system's execution mechanics, **this operating system wins and replaces them**:
- **Planning & Slicing:** Replaces ad-hoc prompting or 8–10 micro-ticket breakdowns with proportional tiers (Tier 1 / Tier 1.5 / Tier 2) and **1–3 coarse vertical feature slices** (`/sharpen` → `/grill-with-docs` → `/to-spec` [with Spec Goldfish] → `/to-tickets`).
- **UI Prototyping Gate:** Replaces unratified in-place UI edits or duplicate styleguide markup with the **3-Tier Surface Gate** (`/canvas` fast loop + `modern-web-guidance` → Production → co-imported `/styleguide`).
- **Build & Review Discipline:** Replaces post-hoc testing, post-PR code review, or self-validating reviews with **TDD (`red → green → refactor`)**, **Anti-Cheating Floor Guards** (blocking `@ts-ignore`, `biome-ignore`, `.skip`, or deleted assertions), and **Pre-PR Blind Adversarial `/code-review`** (`ARTIFACT + CONTRACT` only, run against `origin/main` *before* opening a PR).
- **CI & Quota Architecture:** Replaces multi-job 1-minute-rounding traps, duplicate pre/post-merge E2E runs, and file-writing CI steps with read-only `check:ci` and single-VM job consolidation.
- **Debugging & Performance:** Enforces *Attack the Premise* (2-strike rule), *Explain the Number*, and dual-baseline hillclimbing.

### 2. What This Operating System PRESERVES (Project-Specific Domain, Stack & Rules)
**Never delete, replace, or genericize** the existing project's own identity and domain law:
- **Tech Stack & Tooling:** Keep the project's existing language, framework, package manager, test runner, linter, database, and hosting choices. Adapt gate commands (`npm run check`, `pytest`, `cargo check`, etc.) to the project's stack.
- **Domain Model & Architecture:** Keep all existing `GLOSSARY.md` terms, ADRs (`docs/adr/`), database schemas, RLS/auth models, module boundaries, and API contracts.
- **Visual Design System:** Keep the project's own brand identity, color/typography/spacing tokens (`tokens.css`), `DESIGN.md`, and ratified component library.
- **Project-Specific Non-Negotiables:** Keep every project-specific rule in `AGENTS.md` / `CLAUDE.md` (e.g., third-party API cost guards, environment variable rules, storage/CDN conventions, regulatory/privacy constraints, or custom worktree scripts).

---

## Steps

1. **Read the checklist and template.** Load the shared standard: [`../project-init/checklist.md`](../project-init/checklist.md) and [`../project-init/AGENTS-TEMPLATE.md`](../project-init/AGENTS-TEMPLATE.md) (relative to this skill's folder). They are the single source of truth; do not re-derive criteria from memory.

2. **Harvest the project's state (Read-Only).** Inspect:
   - Existing `AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING.md`, `DESIGN.md`, `GLOSSARY.md`, and `docs/adr/`. Separate **project-specific domain/stack/design rules** (which must be preserved) from **workflow/process rules** (which will be upgraded).
   - Package scripts and CI workflows present vs. the gate they claim; whether any CI variant writes files; multi-job billing traps or duplicate E2E triggers.
   - Branch rulesets and required checks via the tracker API.
   - Test resources for fixed container names, ports, and server-reuse flags; whether a feature map (`docs/verification/features.md`) or anti-cheating floor guard exists.
   - Tracker labels and dependency list against the project's stack. Note anything the repo's own docs claim that the files contradict.

3. **Score each checklist row.** Classify every finding as exactly one of:
   - `missing` — the system does not exist
   - `advisory` — it exists in prose but nothing enforces it mechanically
   - `stale` — docs or comments disagree with the files
   - `contradictory` — existing workflow rules or configs conflict with the operating system (or with each other)
   - `collision-prone` — resources shared across parallel checkouts or runs

4. **Report, ordered by severity, and preview the `AGENTS.md` merge.**
   - Present `contradictory` and `collision-prone` findings first (they produce false results), then `missing` enforcement, then `stale`. Every finding cites evidence: file with line, command output, or API response.
   - Show the owner a clear summary of how `AGENTS.md` / `CLAUDE.md` will be surgically merged: **(a) conflicting workflow processes to be replaced/upgraded** vs. **(b) project-specific rules, stack, and domain docs to be preserved untouched**.
   - State plainly which fixes are owner-actions (settings UI steps, paid plans) versus agent work. Any finding whose world-class tier requires a paid plan names the price and the free alternative, and records the tier decision as the owner's — per checklist §0, the tier is confirmed, never assumed.

5. **Emit tickets (or apply the `AGENTS.md` surgical merge) on approval.** With the user's sign-off, publish one tracker issue per finding cluster, in dependency order, each with acceptance criteria and its owner-action steps flagged (or, if the owner authorizes applying the `AGENTS.md` surgical merge immediately on a dedicated branch, execute that merge preserving 100% of project-specific rules).

## Output shape

A verdict per checklist section: `pass`, `partial` (with the gap named), or `fail` (with the classification and evidence), followed by the **Override vs. Preserve summary**, the ticket list, and the single highest-leverage next action.
