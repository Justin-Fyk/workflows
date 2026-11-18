---
name: code-review
description: "Review the changes since a fixed point (commit, branch, tag, or merge-base) along two axes: Standards (does the code follow this repo's documented coding standards?) and Spec (does the code match what the originating issue/spec asked for?). Runs both reviews in parallel sub-agents and reports them side by side. Use when the user wants to review a branch, a PR, work-in-progress changes, or asks to \"review since X\"."
---

Two-axis adversarial review of the diff between `HEAD` and a fixed point the user supplies:

- **Standards**: does the code conform to this repo's documented coding standards and preserve the quality bar without silent suppressions?
- **Spec**: does the code faithfully implement the originating issue / spec?

Both axes run as **parallel sub-agents** so they don't pollute each other's context, then this skill aggregates their findings. Start every sub-agent with a fresh context window, and inherit the active session model (never hardcode vendor-specific model names).

> **When to run in the PR lifecycle:** Always run `code-review` locally against `origin/main` **before** opening a pull request (`gh pr create`), fix any actionable findings, and re-verify gates so the PR opens clean on its first push without burning duplicate CI runs.

> **Blind Contract Rule (No Author Rationale):** Pass **ONLY** the `ARTIFACT` (the diff command and commit list) and the `CONTRACT` (the spec/issue text or standards files) to each reviewer sub-agent. **Never pass the author agent's summary, explanation, or self-justification**—handing conclusions to a reviewer biases it toward agreement.

The issue tracker should have been provided to you. If not, tell the user to run `/setup-matt-pocock-skills`.

## Process

### 1. Pin the fixed point

Whatever the user said is the fixed point (a commit SHA, branch name, tag, `origin/main`, `main`, `HEAD~5`, etc.). If they didn't specify one, default to `origin/main` when on a feature branch, or ask if ambiguous.

Capture the diff command once: `git diff <fixed-point>...HEAD` (three-dot, so the comparison is against the merge-base). Also note the list of commits via `git log <fixed-point>..HEAD --oneline`.

Before going further, confirm the fixed point resolves (`git rev-parse <fixed-point>`) and the diff is non-empty. A bad ref or empty diff should fail here, not inside two parallel sub-agents.

### 2. Identify the spec source

Look for the originating spec, in this order:

1. Issue references in the commit messages (`#123`, `Closes #45`, GitLab `!67`, etc.), fetched via the workflow in the tracker doc.
2. A path the user passed as an argument.
3. A spec file under `docs/`, `specs/`, or `.scratch/` matching the branch name or feature.
4. If nothing is found, ask the user where the spec is. If they say there isn't one, the **Spec** sub-agent will skip and report "no spec available".

### 3. Identify the standards sources

Search the repo for every file that documents how code should be written (`AGENTS.md`, `CLAUDE.md`, `CODING_STANDARDS.md`, `CONTRIBUTING.md`, `CONSTRAINTS.md`, `DESIGN.md`).

On top of whatever the repo documents, the Standards axis always enforces two baselines:

#### A. Anti-Cheating Floor Guard (Hard Violations)
Flag as a **hard violation** any place the diff lowers the project's verification bar without explicit owner authorization:
- **Silenced checker**: Added `@ts-ignore`, `@ts-expect-error`, `@ts-nocheck`, `biome-ignore`, `eslint-disable`, `istanbul ignore`, or `nosemgrep`.
- **Weakened tests**: Added `.skip` or `.todo`, deleted a test file, or removed `expect`/`assert` calls from an existing test without replacing them with stronger behavioral assertions.
- **Unfinished work**: Added `TODO`/`FIXME` placeholders, `throw new Error("Not implemented")`, or empty `catch {}` blocks that swallow errors silently.
- **Weakened thresholds**: Relaxed a lint rule, design-law check, or coverage/performance threshold to make the branch pass.

#### B. Fowler Code Smell Baseline (Judgement Calls)
A fixed set of Fowler code smells (_Refactoring_, ch.3) that applies even when a repo documents nothing. Two rules bind it:
- **The repo overrides.** A documented repo standard always wins; where it endorses something the baseline would flag, suppress the smell.
- **Always a judgement call.** Each smell is a labelled heuristic ("possible Feature Envy"), never a hard violation. Skip anything tooling already enforces.

Each smell reads *what it is* → *how to fix*; match it against the diff:
- **Mysterious Name**: a function, variable, or type whose name doesn't reveal what it does or holds. → rename it; if no honest name comes, the design's murky.
- **Duplicated Code**: the same logic shape appears in more than one hunk or file in the change. → extract the shared shape, call it from both.
- **Feature Envy**: a method that reaches into another object's data more than its own. → move the method onto the data it envies.
- **Data Clumps**: the same few fields or params keep travelling together (a type wanting to be born). → bundle them into one type, pass that.
- **Primitive Obsession**: a primitive or string standing in for a domain concept that deserves its own type. → give the concept its own small type.
- **Repeated Switches**: the same `switch`/`if`-cascade on the same type recurs across the change. → replace with polymorphism, or one map both sites share.
- **Shotgun Surgery**: one logical change forces scattered edits across many files in the diff. → gather what changes together into one module.
- **Divergent Change**: one file or module is edited for several unrelated reasons. → split so each module changes for one reason.
- **Speculative Generality**: abstraction, parameters, or hooks added for needs the spec doesn't have. → delete it; inline back until a real need shows.
- **Message Chains**: long `a.b().c().d()` navigation the caller shouldn't depend on. → hide the walk behind one method on the first object.
- **Middle Man**: a class or function that mostly just delegates onward. → cut it, call the real target direct.
- **Refused Bequest**: a subclass or implementer that ignores or overrides most of what it inherits. → drop the inheritance, use composition.

### 4. Spawn both sub-agents in parallel (Fresh Context, Blind Contract)

Issue both sub-agent calls together, each starting with a fresh context window. Pass **only** the artifact (`git diff` command + commit list) and the contract (standards or spec)—never your own summary or rationale.

**Standards sub-agent prompt** should include:

- The full diff command and commit list.
- The list of standards-source files you found in step 3, **plus the Anti-Cheating Floor Guard and Fowler Smell Baseline from step 3** pasted in full.
- The adversarial brief: "Adversarial Standards Review. Assume the author was overconfident. Do NOT validate or summarize. Report, per file/hunk where relevant: (a) every place the diff violates a documented repo standard or the Anti-Cheating Floor Guard (hard violations: cite the file, hunk, and exact rule); and (b) any Fowler baseline smell you spot (judgement calls: name it and quote the hunk). Confirm unit tests assert observable results against literal expected values rather than tautologies. Skip anything tooling already enforces. Under 400 words."

**Spec sub-agent prompt** should include:

- The diff command and commit list.
- The path or fetched contents of the spec (and `docs/verification/features.md` if the repo maintains a feature map).
- The adversarial brief: "Adversarial Spec Review. Assume the author was overconfident. Do NOT validate or summarize. Report: (a) requirements or acceptance criteria the spec asked for that are missing or partial (including missing feature-map entries if a new user-facing capability was added); (b) behaviour in the diff that wasn't asked for (scope creep); (c) requirements that look implemented but where the implementation fails an edge case or breaks the contract. Quote the spec line and diff hunk for each finding, and prove any bug claim with a concrete execution trace or test gap. Under 400 words."

If the spec is missing, skip the Spec sub-agent and note this in the final report.

### 5. Aggregate

Present the two reports under `## Standards` and `## Spec` headings, verbatim or lightly cleaned. Do **not** merge or rerank findings, because the two axes are deliberately separate (see _Why two axes_).

End with a one-line summary: total findings per axis, and the worst issue _within each axis_ (if any). Don't pick a single winner across axes: that's the reranking the separation exists to prevent.

## Why two axes

A change can pass one axis and fail the other:

- Code that follows every standard but implements the wrong thing → **Standards pass, Spec fail.**
- Code that does exactly what the issue asked but breaks the project's conventions → **Spec pass, Standards fail.**

Reporting them separately stops one axis from masking the other.
