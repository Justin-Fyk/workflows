---
name: project-adopt
description: Audit an existing project against your operating-system checklist and turn the findings into scored, ready-to-run tickets. Use when adopting an existing repo (even a freshly scaffolded one), porting workflow learnings to another project, retrofitting guardrails mid-flight, or running a project health check. For brand-new empty repos, use project-init instead.
license: MIT
metadata:
  author: non-coder-ai-workflow
  version: "1.1"
---

# Project Adoption

Retrofit an existing project onto the operating system. Most lessons apply mid-flight, not at birth; this skill is the reusable version of that retrofit. It is read-only by default: findings become tickets, and fixing is separate, approved work.

## Steps

1. **Read the checklist.** Load the shared standard: `../project-init/checklist.md` (relative to this skill's folder). It is the single source of truth; do not re-derive criteria from memory.

2. **Harvest the project's state.** Read-only: package scripts and CI workflows present vs the gate they claim; whether any CI variant writes files; branch rulesets and required checks via the tracker API; pre-commit hook configuration; test resources for fixed names, ports, and server-reuse flags; planning docs (glossary, ADR index) and whether AGENTS.md references them; tracker labels; dependency list against any ratified stack. Note anything the repo's own docs claim that the files contradict.

3. **Score each checklist row.** Classify every finding as exactly one of:
   - `missing` - the system does not exist
   - `advisory` - it exists but nothing enforces it
   - `stale` - docs or comments disagree with the files
   - `contradictory` - two rules or configs conflict
   - `collision-prone` - resources shared across parallel checkouts or runs

4. **Report, ordered by severity.** Contradictory and collision-prone first (they produce false results), then missing enforcement, then stale. Every finding cites evidence: file with line, command output, or API response. State plainly which fixes are owner-actions (settings UI steps, paid plans) versus agent work. Any finding whose world-class tier requires a paid plan names the price and the free alternative, and records the tier decision as the owner's — per checklist §0, the tier is confirmed, never assumed.

5. **Emit tickets on approval.** With the user's sign-off, publish one tracker issue per finding cluster, in dependency order, each with acceptance criteria and its owner-action steps flagged. No fixes, branches, or config changes in this skill - the tickets are the deliverable.

## Output shape

A verdict per checklist section: pass, partial (with the gap named), or fail (with the classification and evidence). End with the ticket list and the single highest-leverage next action.
