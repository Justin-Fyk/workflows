---
name: project-init
description: "Walk a brand-new project through the full operating system: gate commands, read-only CI, branch enforcement, planning docs, tracker labels, evidence vocabulary, environment separation. Use when starting a new project, setting up a fresh repo, or initializing workflow guardrails. For repos that already exist (even freshly scaffolded ones), use project-adopt instead."
license: MIT
metadata:
  author: non-coder-ai-workflow
  version: "2.1"
---

# Project Initialization

Onboard a new project onto your operating system: the rules, gates, and conventions crystallized from lessons learned on previous projects. The deep content lives in one place: [checklist.md](checklist.md) — read it first; every step below points into it.

Calibration is a feature, not an omission. For each step, ask the user which depth applies (minimal or world-class) — batched into one question at the start. Tier is the owner's call, made with context: ask about the project's stage and budget before proposing anything, and never default a silent answer into world-class. Every option that needs a paid plan carries its price and the free alternative side by side; the owner picks. A weekend site can decline half the list; a product cannot — but only the owner knows which one this is.

## Steps

1. **Gather context.** Identify: stack and framework, repo owner and name (personal vs org), hosting, whether a database exists, who the owner-actions fall on, and — confirmed with the owner, never assumed — the project's tier and recurring-cost tolerance (checklist §0). Completion: you can name every parameter this checklist depends on, including the tier.

2. **Define the gate.** Choose the commands that mean "done", per checklist §1. Create two script entries: the local `check` (may auto-fix) and a read-only `check:ci` that never writes files. Completion: `check:ci` exits 0 on the clean tree and fails on a deliberately unformatted file without touching it.

3. **Wire CI.** One pull-request workflow running the gate via `check:ci`, with least-privilege token permission, a concurrency group that cancels superseded runs, and pinned action versions (checklist §2). Completion: a deliberately broken PR fails; a clean PR passes.

4. **Turn on enforcement.** Branch ruleset on the default branch: require a PR, require the status checks that now exist, block force-push and deletion, linear history, squash-only merges (checklist §3). Steps in the GitHub settings UI are owner-actions: prepare exact values, hand them over, and verify by API afterward, or proceed only with explicit owner authorization for an API write. Leave an admin bypass on at first and record that removing it is a follow-up. Completion: API read shows the ruleset active; a red check blocks merge.

5. **Seed planning docs and tracker.** Glossary, ADR index with its acceptance bar, the AGENTS.md skeleton below, and the tracker labels (checklist §5–6). Completion: docs exist and AGENTS.md references them; labels visible on the tracker.

6. **Adopt the evidence vocabulary.** Record the four completion states and the PR body fields (checklist §7) in AGENTS.md. Completion: they are written where agents will read them.

7. **Decide environment separation** — only if a database or hosting exists (checklist §8). Data-less preview or dev environment, synthetic fixture identities, privileged keys server-side only, sessions through the product's real auth path. Completion: a written decision, even if the decision is "not yet, because…".

8. **Agree the cadence** (checklist §10): handoff docs on pause, retros that amend the checklist. Completion: the user knows when each fires.

Finish with a verification report: for each step, the depth chosen and the evidence it passed.

## AGENTS.md skeleton

Write the project's AGENTS.md from this shape, pruning nothing structural:

- Header: project name, stack, repo coordinates.
- Non-negotiables: gate commands (both variants); ratified stack with "new dependencies are a ticketed decision"; secrets rules; planning flow with the hand-back point; concurrent-session rules (one checkout per session, no stash, foreign dirt stops work).
- Workflow: trunk-based; branch prefixes; Tier 1 fast-track vs Tier 2 spec-first; review gate on every PR including docs-only.
- Pointers, not copies: glossary, ADR index, checklist location.

The mature universal exemplar of this shape lives alongside this skill in [`AGENTS-TEMPLATE.md`](AGENTS-TEMPLATE.md) — consult and adapt it when initializing or upgrading a project's `AGENTS.md`.
