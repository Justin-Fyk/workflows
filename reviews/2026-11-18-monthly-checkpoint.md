# Monthly CTO Workflow & Verification Checkpoint — November 2026

**Date:** 2026-11-18  
**Scope:** Ecosystem review (Chrome Modern Web Guidance, Poteto's `pstack`, Addy Osmani's `agent-skills` & `web-quality-skills`, multi-tier model routing), upstream skill drift audit, CI quota forensics, and lessons from our last 20 merged PRs.

---

## 1. External Ecosystem Analysis & What We Adopted

### A. Chrome's Modern Web Guidance (`GoogleChrome/modern-web-guidance`)
* **Link:** [developer.chrome.com/docs/modern-web-guidance](https://developer.chrome.com/docs/modern-web-guidance)
* **Finding:** AI models carry strong training-weight bias toward 2020–2023 JavaScript workarounds (custom React state for modals/popovers, fragile `window.history.length` heuristics, JS scroll/resize listeners) where modern Baseline browser APIs (`<dialog>`, Popover API, CSS Anchor Positioning, Container Queries, `@starting-style`, `window.navigation.canGoBack`) solve the problem natively.
* **Action Taken:** Installed [`modern-web-guidance`](../skills/modern-web-guidance/SKILL.md) and wired it into Step 1 of [`canvas`](../skills/canvas/SKILL.md) so any net-new interactive UI primitive or browser behavior queries modern Baseline web patterns before prototyping. Kept it out of routine edits to avoid unnecessary per-turn latency.

### B. Lauren Tan (`@poteto`) — *"All Code Is Slop (Except Mine)"* & `pstack` Updates
* **Link:** [YouTube (`O_zcc6Xl12g`)](https://www.youtube.com/watch?v=O_zcc6Xl12g) · [cursor/plugins/pstack](https://github.com/cursor/plugins/tree/main/pstack)
* **Finding:** Scaling autonomous agent output with a `<0.5%` revert rate requires pushing lessons down **The Trust Pyramid** (Architecture → Types → Lint/Wiring Tests → Runtime Feature Maps → Prose last).
* **Actions Taken:**
  1. Installed [`sharpen`](../skills/sharpen/SKILL.md) to upgrade high-level product prompts into deep Staff-level briefs before `/grill-with-docs`.
  2. Installed [`correct`](../skills/correct/SKILL.md) to systematically mine repeated agent mistakes and turn prose rules in `AGENTS.md` into mechanical wiring tests.
  3. **Evaluated & Skipped `pstack/statechart`:** Inspecting `statechart/SKILL.md` showed it requires installing Java + `mise` + the TLC TLA+ formal model checker (`SPEC.tla`). That is heavy infrastructure overkill for web apps; we achieve the visual benefit directly via standard Mermaid `stateDiagram-v2` diagrams during spec writing.

### C. Rob Shocks — *"Pocock vs Pstack vs Osmani"* & Addy Osmani's Skills
* **Link:** [YouTube (`sU9MW8Ycq2M`)](https://www.youtube.com/watch?v=sU9MW8Ycq2M) · [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) · [addyosmani/web-quality-skills](https://github.com/addyosmani/web-quality-skills)
* **Finding:** Installing multiple full skill packs as competing routers causes slash-command collisions (`/tdd`, `/spec`, `/review`). The optimal architecture is keeping **Matt Pocock (`Define & Plan`) + `pstack` (`Build & Verify`)** as the primary spine, while cherry-picking Addy Osmani's **Governance, Anti-Cheating, and Audit** mechanisms.
* **Actions Taken:**
  1. **Anti-Cheating Floor Guard:** Added Osmani's `floor-guard` rules and reference implementation ([`floor-guard.md`](../skills/security-and-hardening/references/floor-guard.md)) into [`code-review`](../skills/code-review/SKILL.md) and [`project-init/checklist.md`](../skills/project-init/checklist.md) to block new `@ts-ignore`/`biome-ignore` suppressions, `.skip`/`.todo` additions, deleted test assertions, and unimplemented stubs.
  2. **Blind Adversarial Contract Review:** Upgraded [`code-review`](../skills/code-review/SKILL.md) with Osmani's `doubt-driven-development` rule—stripping the author agent's summary/rationale and passing **only `ARTIFACT` (diff) + `CONTRACT` (spec/standards)** with adversarial framing.
  3. **Pre-Launch Quality & Security Audits:** Installed [`web-quality-audit`](../skills/web-quality-audit/SKILL.md) (with bundled `MEASUREMENT.md`) and [`security-and-hardening`](../skills/security-and-hardening/SKILL.md) (with bundled `hardening-patterns.md` and `security-checklist.md`).

### D. Multi-Tier Model Routing (Vendor-Neutral & OpenRouter Safe)
* **Link:** [YouTube (`3tacaSEZM9M`)](https://www.youtube.com/watch?v=3tacaSEZM9M)
* **Finding:** While routing mechanical file/log scouting to a fast/lightweight tier saves time and quota, hardcoding specific model names inside `SKILL.md` breaks multi-partner and OpenRouter setups. Furthermore, within strong architectural rails, a daily-driver workhorse model (such as Gemini 4 Hydrogen, Claude Sonnet, or an OpenRouter workhorse) handles >90% of all engineering tasks without needing a frontier model.
* **Action Taken:** Encoded the **Vendor-Neutral 3-Tier Model Routing** law in [`rules/GEMINI.md`](../rules/GEMINI.md) and [`docs/model-routing-and-ci-economics.md`](../docs/model-routing-and-ci-economics.md):
  * **Tier 1 (Fast Scout):** Optional lightweight tier strictly for mechanical read-only file/log lookups (falls back to `inherit` on OpenRouter).
  * **Tier 2 (Daily-Driver Workhorse — >90% of work):** Always `inherit` the user's active session model.
  * **Tier 3 (Frontier Deep-Reasoning — <10% of work, Human-Triggered):** Agent pauses and recommends switching only when the daily-driver model hits a 2-strike verification failure (*Attack the Premise*).

---

## 2. Upstream Skill Sync Audit

All 23 Matt Pocock skills were compared against `mattpocock/skills@main`:
* **17 skills** were already 100% identical to upstream.
* **6 skills** (`code-review`, `implement-spec`, `improve-codebase-architecture`, `research`, `wayfinder`, `grilling`) were synced with upstream's Oct 29–Nov 12 updates enforcing **fresh context windows for every spawned subagent** (and one fresh implementer subagent per ticket in `implement-spec`).
* **Universalization Pass:** Removed all project-specific references from `canvas/SKILL.md`, `canvas/BRIEF-AND-RUBRIC.md`, and `project-init/SKILL.md`, and added a universal [`AGENTS-TEMPLATE.md`](../rules/AGENTS-TEMPLATE.md).

---

## 3. Empirical Case Study: CI Quota Forensics & Lessons from 20 Production PRs

Analyzing 850 GitHub Actions runs (`3,159 billed minutes` across 15 days) and 20 merged PRs on a production Next.js + Supabase project revealed four universal lessons now baked into [`checklist.md`](../skills/project-init/checklist.md):

| Finding | Measured Impact | Operating-System Fix |
|---|---|---|
| **1. Double/Triple Cloud E2E + Multi-VM Job Splits** | Cloud E2E consumed **54% (`1,710 min`)** of the monthly quota. Splitting `webkit-mobile` and `e2e-alert` into separate VMs saved 40s wall-clock but added **+3 billed minutes (+33%)** per run due to redundant `npm ci` + `next build` and per-job rounding. | Keep `chromium`, `webkit-mobile`, and alerting in **one VM job**; never run duplicate cloud E2E on `main` push when the merged PR's head SHA already passed E2E. |
| **2. GitHub's 1-Minute Minimum Per-Job Tax** | Running 4-second skip/drift checks in separate workflow files and splitting `migrate → deploy → smoke` into 3 jobs burned **~500 billed minutes** on <55 minutes of work. | Consolidate sequential steps (`migrate → deploy → smoke`) into **one job**; fold fast checks (`migration-drift`) into the main `ci.yml` job. |
| **3. Reviewing After Opening the PR (4.2 Pushes/PR)** | Opening PRs before running `code-review` caused 139 PR CI runs across ~35 PRs. | Run Blind `/code-review` locally against `origin/main` **before** `gh pr create` so PRs open clean in 1 push. |
| **4. Hourly Webhook Crons on CI VMs** | An hourly `curl` job (`8s` runtime) bills `1 full minute × 24 × 30 = 720 min/month` (24% of a 3,000-min quota). | Offload HTTP webhook pings to zero-VM schedulers (`pg_cron`, Cloudflare Workers, Vercel Cron) or throttle GHA cadence to ≥4 hours. |
| **5. Coarse Vertical Specs vs. Micro-Tickets** | Multi-surface features sliced into **2–3 vertical PRs** shipped cleanly, whereas 3 separate cosmetic PRs on a single checkbox burned 45 CI minutes in 90 minutes. | Mandate **1–3 coarse vertical feature PRs** for Tier 2 specs, and batch Tier 1 visual/copy tweaks in a live browser before opening a single PR. |

---

## 4. Design System & `/styleguide` Audit: Fixing Drift, Visual Distortion & Bloat

Auditing the project's `/canvas` and `/styleguide` implementation (`49 files`, `~10,000+ lines`, `page.tsx` at `1,734 lines`, `styleguide.module.css` at `1,862 lines`) uncovered three structural root causes behind visual flaws and drift in `/styleguide`:

1. **Legacy Pre-`/canvas` Fake Replicas (~2,800 Lines of Drift):**
   Before `/canvas` existed, whole features (such as `discovery-hierarchy-*.tsx` across 6 files / 2,226 lines, `mobile-shell-specimen.tsx`, and `mobile-nav-specimen.tsx`) were built as hand-coded fake replicas inside `src/app/styleguide/` rather than importing real `src/components/` primitives. When production routes evolved, those replicas froze in time and taught agents outdated markup.
2. **Cramming Full-Page Feature Screens into Narrow `<StateCell>` Boxes:**
   Promoting entire feature views (`Dashboard`, `Messages`, `AccountActivity`) into `/styleguide` forced full-viewport screens (`1200px–1440px` with viewport `@media` queries and `position: sticky` headers) inside narrow `<StateCell>` cards—breaking sticky positioning, preventing mobile media queries from firing, and causing agents to write 1,862 lines of hacky `styleguide.module.css` overrides.
3. **Public Production Exposure:**
   Neither `/canvas` nor `/styleguide` had a production environment gate (`VERCEL_ENV === "production"` → `notFound()`), exposing internal workbenches on the live public site.

### The Upgraded 3-Surface Design Law (Now Encoded in `canvas`, `design-system`, and `checklist.md`)
* **Keep design tokens, `DESIGN.md`, `/canvas`, and `/styleguide` inside the project repo** (so TypeScript and `check:design` verify them atomically), but gate `/canvas` and `/styleguide` to return `notFound()` in public production deployments.
* **`/canvas` is strictly ephemeral:** Deleted in the same PR that ships the production feature.
* **`/styleguide` is strictly for Foundations + Reusable UI Primitives (`2+` screen consumers) + Shared Cards:** Every specimen must import the real component from `src/components/` (enforced by `check:design`), with zero fake replicas and zero full-page feature screens.
* **Full-Page Feature Screens use their Shipped Production Routes as Model Screens:** Locked by deterministic seeded fixtures, `test:visual` baselines at `390px` & `1280px`, and `npm run verify` feature-map journeys—eliminating the redundant "promote feature screen to `/styleguide`" PR tax.
