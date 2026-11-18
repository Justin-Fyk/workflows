# `/canvas` Design Brief Template & 6-Point Perceptual Ergonomics Rubric

Copy the template below into `docs/design/briefs/<slug>.md` in **Step 1** and complete the rubric table in **Step 4**.

---

## Template: `docs/design/briefs/<slug>.md`

```markdown
# Design Brief: <Feature / Surface Name>

- **Status**: Draft | Owner Signed Off (`YYYY-MM-DD`) | Graduated to `/styleguide` (PR #<N>)
- **Canvas Preview URLs**: `/canvas#<section-id>`, `/canvas/preview/<slug>` (`390px` & `1280px`)
- **Related Issues**: #<issue>

## 1. User Flow & 5-State Matrix

- **Target User & Job-to-be-Done**: <Who is acting, from what trigger, to achieve what outcome>
- **Entry Point → Action → Exit Point**: <Exact route/control that opens the surface → primary interaction → where the user lands after>

| State | Trigger / Condition | Visible UI & Copy |
|---|---|---|
| **Empty** | Zero items | <Exact heading, helper line, and primary CTA> |
| **Loading** | Initial fetch / transition | <Skeleton or inline pending state> |
| **Populated** | Normal active items | <Row/card anatomy, primary & secondary metadata> |
| **Actionable / Locked** | Pending decision or permission gate | <Inline action buttons or lock banner copy> |
| **Error / Overflow** | Network failure or 120+ char text / 99+ count | <Inline `.field-error` / `.form-notice` and truncation/wrapping rule> |

## 2. External Reference Teardown

| Reference Product & Surface | What We Borrow (Structural / Interaction Mechanic) | What We Reject (Why It Conflicts with Our Design System) |
|---|---|---|
| <e.g. Facebook Desktop Messenger Drawer> | <e.g. 420px right-anchored floating overlay triggered from top-right header icon> | <e.g. Multi-window bottom chat tabs that cover card grids> |
| <e.g. Linear Inbox> | <e.g. Single-line scannable rows with left-aligned action pills on actionable items> | <e.g. Keyboard-only command palette required for basic triage> |

## 3. Component & Token Inventory

| UI Element | Existing Primitive / Token (`src/components/`, `tokens.css`) | New Candidate? (Requires 1-line justification) |
|---|---|---|
| Host shell & header | Primary site chrome component, real brand logo, `--container-site`, `--container-content` | Reuse |
| Primary controls | `Button`, `IconButton`, `FilterChips`, `CountBadge`, `SearchField` (or repo equivalents) | Reuse |
| Domain cards / rows | Existing domain card/row components + realistic fixture dataset | Reuse |
| <Net-new surface> | <Tokens consumed: `--color-surface-*`, `--spacing-*`, `--z-overlay`> | New: <why existing `/styleguide` components cannot express this> |

## 4. 6-Point Perceptual Ergonomics Critique (`390px` & `1280px`)

| # | Ergonomic Axis | Check Criteria | 390px Verdict | 1280px Verdict |
|---|---|---|---|---|
| 1 | **Left-axis scan alignment** | Avatars, primary titles, body lines, and inline action buttons share clean vertical left axes; no ragged indentation across sibling rows. | PASS / FAIL | PASS / FAIL |
| 2 | **Right-edge axis alignment** | Row timestamps and unread `<CountBadge />` pills sit in a dedicated right-aligned column (`align-items: flex-end`) sharing one vertical right axis. | PASS / FAIL | PASS / FAIL |
| 3 | **Proportional sizing & typography** | Header/nav icons, body copy, and headings use the project's semantic size and font-weight tokens; WCAG 2.2 AA contrast holds on every surface. | PASS / FAIL | PASS / FAIL |
| 4 | **Chrome budget & zero redundancy** | Mobile `390px` stacks at most **2** top header/control bars; filter chips never duplicate parent tab unread counts; zero redundant status tags when row prose already names the actor; zero filler subtitles. | PASS / FAIL | PASS / FAIL |
| 5 | **Overlay reflow isolation** | Opening/closing drawers, sheets, or popovers (`position: fixed` / `absolute`, `--z-overlay`) causes **0px** width shift or reflow on the underlying `--container-content` page. | PASS / FAIL | PASS / FAIL |
| 6 | **100% System fidelity** | Real brand logo, real site shell, real domain cards, real fixture media, and semantic tokens from `tokens.css` (zero black-and-white wireframes, zero hardcoded hex/px). | PASS / FAIL | PASS / FAIL |
```

