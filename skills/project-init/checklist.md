# Operating-system checklist

Single source of truth shared by `project-init` (walk it forward) and `project-adopt` (score a repo against it). One row per system. "Owner-action" marks steps only the repository owner can perform.

## 0. Tier calibration (decides every other section)

Tier is a property of the project's context, chosen by the owner — never inferred from repo signals, and never defaulted. Ask which level fits (e.g. solo passion project, growing product, funded team) and confirm before recommending anything. Two rules follow:

- Every recommendation that requires a paid plan or subscription carries its price next to it, plus the best free alternative, before it enters any plan or spec. The owner chooses; agents never silently assume affordability or silently skip world-class steps.
- A paid option the owner declines is a calibration input, not an obstacle: re-plan at the owner's tier instead of proposing workarounds they did not ask for.

## 1. Gate & Verification

| Aspect | Minimal | World-class | Verify |
|---|---|---|---|
| Done commands | typecheck + build | typecheck + lint (non-writing) + unit tests + design/floor-guard wiring tests + build | Running them on a clean tree exits 0 |
| Local vs CI check | one `check` script | local `check` may auto-fix; separate `check:ci` that never writes files | `check:ci` on a tree with an unformatted file fails and leaves the file untouched |
| Red-green rule | bugs fixed with tests | every behavior change ships a test that fails on the pre-change commit; docs-only changes are exempt and say so in the PR body | git history shows test-first fixes |
| Anti-cheating floor guard | manual diff inspection | diff-scoped guard test blocks new `@ts-ignore`/`biome-ignore` suppressions, `.skip`/`.todo` or deleted assertions on existing tests, and `TODO`/empty `catch {}` stubs | deliberate suppression or `.skip` fails `npm test` |
| Feature-map runtime proof | manual smoke test | maintained `docs/verification/features.md` + `npm run verify` recipe + wiring tests locking every user-facing capability to a runnable journey | `npm test` fails if a capability has no journey or the doc table drifts |
| Premise & measurement discipline | ad-hoc debugging | *Attack the Premise* (test shared premise directly after 2 failed fixes) + *Explain the Number* (dual baseline + bottleneck identification + decision log for perf/CI claims) | `AGENTS.md` encodes both; perf/CI PRs cite dual baselines and decision log |

## 2. Continuous integration & Quota efficiency

| Aspect | Minimal | World-class | Verify |
|---|---|---|---|
| Workflow | gate runs on every PR | least-privilege token permission, concurrency group cancelling superseded runs, pinned action versions | a deliberately broken PR goes red |
| No silent repair | CI never writes files | same, plus failure traces/diagnostics uploaded on red runs | `git status` clean after CI on a dirty tree; red E2E runs upload artifacts |
| Quota & 1-minute floor discipline | separate workflows per check | consolidate fast sequential steps (`migrate → deploy → smoke`, or `chromium → webkit → alert`) into single-VM jobs to avoid GitHub's 1-minute per-job rounding tax; never run high-frequency `curl` crons on CI VMs; de-duplicate pre-merge vs post-merge E2E runs | monthly billed minutes stay <50% of included quota |
| Runner resilience & self-testing | bare setup commands | cache E2E browser binaries by OS + browser tuple + exact package version; bound `apt`/container stack boot steps with short step `timeout-minutes`, retry backoff, and valid unused-container exclusions; include each workflow file in its own path/diff filter so workflow edits self-test on PRs | setup stalls fail fast (<8m) instead of burning job timeout; workflow PRs trigger their own check |
| Pre-PR review order | review after opening PR | run `code-review` (Blind Adversarial Contract) locally against `origin/main` *before* `gh pr create` so PRs open clean in 1 push | average PR push count stays near 1–1.5 |

## 3. Enforcement

| Aspect | Minimal | World-class | Verify |
|---|---|---|---|
| Branch ruleset on default branch | require PR; block force-push and deletion | require the CI status checks (only checks that exist and report on every PR); linear history; squash-only merges | API read shows the ruleset active with those checks |
| Bypass lifecycle | admin bypass while onboarding | bypass removed once the required checks report green across code, docs-only, and schema PRs | a failing required check blocks merge for everyone |
| Owner-action | GitHub settings UI (or explicit owner authorization for an API write) | same | owner performed it, or authorization is on record |

## 4. Parallel safety

| Aspect | Minimal | World-class | Verify |
|---|---|---|---|
| Test resources | no fixed container names or ports shared across checkouts | container names and ports derived per run/worktree; server reuse disabled | two worktrees run the suite simultaneously, both green |
| Session hygiene | one checkout per agent session; no `git stash`; foreign dirt stops work | plus per-worktree setup/run scripts so installs and ports never collide | no cross-session collisions in history |

## 5. Planning docs, Surface Gate & Ticket Slicing

| Aspect | Minimal | World-class | Verify |
|---|---|---|---|
| Domain docs | glossary file with exact vocabulary | glossary + ADR index with a stated bar for when an ADR is required; contradictions surfaced, never silently resolved | docs exist and are referenced by AGENTS.md |
| Planning flow & coarse slicing | gate + review only | `/sharpen` (when broad) → `/grill-with-docs` → `/to-spec` (with Spec Goldfish check) → `/to-tickets` sliced into **1–3 coarse vertical feature PRs** (never 6–10 micro-tickets) → hand back to user | tracker shows specs sliced into 1–3 vertical tickets |
| 3-Tier UX Surface Gate & Lean `/styleguide` | direct production edits | (1) prototype new screens/primitives in dev-only `/canvas` (`390px` + `1280px` + `modern-web-guidance` check, `npm run check` fast loop) → owner sign-off; (2) build production feature and **delete graduated `/canvas` mock**; (3) `/styleguide` holds **ONLY Foundations + Reusable UI Primitives (2+ screens) + Shared Cards** via 100% real `src/components/` imports (zero fake replicas, zero full-page feature screens); full feature screens use their real production routes as Model Screens (`test:visual` + `verify`); both `/canvas` and `/styleguide` return `404` in production (`VERCEL_ENV === "production"`) | `check:design` bans mock components in `/styleguide`; `/canvas` & `/styleguide` gated off public production |
| Tier 1 visual batching | one PR per tweak | preview and batch cosmetic/copy tweaks in live browser (`390px` + `1280px`) with owner before opening a single PR | no multi-PR churn on the same UI element |

## 6. Tracker

| Aspect | Minimal | World-class | Verify |
|---|---|---|---|
| Labels | one agent-ready label | small triage vocabulary (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`), applied consistently | labels exist on the tracker |
| Duplication guard | search before creating issues | same | no duplicate spec/tickets |

## 7. Evidence

| Aspect | Minimal | World-class | Verify |
|---|---|---|---|
| Completion vocabulary | "done" means gate commands passed | four distinct states: implemented / verified / merged / live | docs define them; PRs use them |
| PR evidence | PR states what changed | PR body carries revision SHA, exact gate commands, pass counts, explicit not-covered list | recent PR bodies show the fields |

## 8. Environment separation (only if the project has a database or hosting)

| Aspect | Minimal | World-class | Verify |
|---|---|---|---|
| Isolation | tests never target production data | data-less preview/dev environment spun from migrations; suite refuses production/non-local credentials | test runs against an isolated env; guard test proves refusal |
| Test identities | synthetic accounts | seeded fixture accounts per role; privileged keys used only server-side for setup; sessions acquired through the product's real auth path; browser sessions gitignored | no production rows touched by tests; secrets never client-side or logged |

## 9. Dependency hygiene & Security

| Aspect | Minimal | World-class | Verify |
|---|---|---|---|
| Stack discipline | mainstream packages only | a ratified stack; any new dependency or config is a ticketed decision; periodic `security-and-hardening` and `web-quality-audit` passes | dependency PRs reviewed against the ratified list |

## 10. Learning cadence

| Aspect | Minimal | World-class | Verify |
|---|---|---|---|
| Handoff | long pauses produce a handoff doc | handoff names suggested skills and points at trackers, never duplicating them | handoff docs exist for paused work |
| Retros & `/correct` | after milestones; retro findings amend the checklist, not just the project | same, plus `/correct` pass converting repeated prose rules into architecture, types, or wiring tests, and dated commit-cited history in docs | checklist has a revision history; prose rules pair with mechanical checks |
