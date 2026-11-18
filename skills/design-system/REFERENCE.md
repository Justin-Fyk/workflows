# Design System Skill Reference

Detailed workflows and principles for the three modes of the design system skill.

---

## Tool Guidance: Interacting with the Web

Research, audits, and definition work often need reference URLs, competitor sites, or brand materials.
* **Reading Web Content**: Use the environment's web-fetch tool to read specifications, guidelines (e.g., WCAG 2.2 from w3.org), or competitor sites.
* **Searching the Web**: Use the environment's web-search tool for design system documentation (e.g., Material Design, Apple HIG, IBM Carbon, Atlassian) or trend analyses.
* **Browser Interaction & Screenshots**: Use the environment's browser automation tools to visually inspect components, review rendering behavior, or capture UI screenshots for audits.

---

## Mode 1: Research

**Role:** Design researcher and competitive intelligence analyst. Gather raw material that informs smart design decisions. Do not make final decisions in this phase.

### Research Interview
Before researching, establish scope with the user:
- What are we researching? (Competitors, inspiration, accessibility baseline, or all?)
- Which URLs should be analyzed? (Competitors, reference brands, the user's own site)
- What design category is this product in? (SaaS, e-commerce, mobile app, marketing site, etc.)
- What are we trying to learn? (What to do, what to avoid, where the gaps are?)

### Research Workflow
1. **Fetch & Observe**:
   - Fetch target URLs or open them in the browser.
   - Extract: typography choices (families, weights, scale), color palette, spacing rhythm, layout grid, component patterns, motion cues, iconography style, and overall visual personality.
   - Note what works and what is broken.
2. **Competitive Matrix**:
   - Build a comparison across all analyzed sites covering typography, color strategy, spacing density, component sophistication, accessibility signals, and visual personality.
3. **Trend Context**:
   - Reference patterns from credible sources (WCAG, Nielsen Norman Group, major design systems), not random blogs.
4. **Design Opportunity Map**:
   - Synthesize findings into competitive strengths, visual differentiation opportunities, and accessibility baselines.

---

## Mode 2: Audit

**Role:** Exacting design reviewer. Find what is broken, inconsistent, or below standard. Deliver a clear, evidence-based path to fix.

### Audit Interview
Establish audit boundaries:
- Are we auditing a URL, uploaded screenshots, or described components?
- Is there an existing `design.md` or design token file to audit against?
- What is the audit focus? (Full audit, accessibility only, consistency only, or specific components?)
- What is the output for? (Internal improvement, client deliverable, handoff to developers?)

### Audit Workflow
1. **Fetch & Inventory**:
   - Fetch the page or analyze screenshots to build a visual inventory of elements.
2. **Systematic Review**:
   - **Typography**: Are type scales consistent? Are weights used intentionally? Is hierarchy clear?
   - **Color**: Is the palette coherent? Are there rogue colors? Is contrast WCAG-compliant?
   - **Spacing**: Is there a discernible spacing system, or is it ad hoc?
   - **Components**: Are similar UI elements treated consistently? Are states (hover, focus, disabled, error) defined?
   - **Layout**: Is there a grid? Is alignment consistent?
   - **Motion**: Are transitions purposeful or decorative? Consistent duration and easing?
   - **Accessibility**: Color contrast ratios, focus states, semantic structure, touch target sizes.
   - **Brand Alignment**: Does the visual design match stated brand values or the project's voice document?
3. **Severity Rating**:
   - 🔴 **Critical**: Breaks accessibility, causes user error, or creates legal risk (e.g., WCAG violations).
   - 🟡 **Major**: Significant inconsistency or UX degradation.
   - 🟢 **Minor**: Polish and refinement opportunity.
4. **Patterns, Not Just Problems**:
   - Identify systemic failures. If spacing is inconsistent in 8 places, the problem is the absence of a spacing system, not 8 individual mistakes.

---

## Mode 3: Define

**Role:** Produce a comprehensive, actionable `design.md` that eliminates ambiguity for every designer and developer. Specify tokens, ratios, exact values, and concrete examples.

### Define Interview
Ask what the existing material does not answer:
- **Brand & Product**:
  - What does the company do and for whom?
  - What is the product category? (SaaS dashboard, mobile app, marketing site, etc.)
  - Who is the user (sophistication level, device split, context)?
- **Visual Direction**:
  - Describe the visual personality in 3–5 specific adjectives.
  - What brands do you admire? What should the design look nothing like?
  - Is there a brand-voice or tone-of-voice document? (Visual design must express the same character.)
  - What is the desired emotional response (trust, delight, focus)?
- **Constraints**:
  - Brand assets (logos, colors, licensed typefaces)?
  - Platforms (web only, native mobile, cross-platform)?
  - Tech stack & tooling (CSS framework, component library, design token support)?
  - Accessibility goals (WCAG AA minimum, AAA target)?

### Synthesis Pass
Before writing `design.md`, complete an internal synthesis:
- What is the visual character in one sentence? (Be specific.)
- What are the 3 most important design decisions that everything else flows from?
- What does this system actively reject?
- Where will the system be stressed most (e.g., data-heavy tables, mobile viewports)?

---

## General Principles

* **Tokens over values**: Never hardcode a raw hex or pixel value in a component. Use semantic tokens to make system-wide updates possible without code archaeology.
* **Design for the hard cases**: A system earns its value in error states, empty states, loading states, long content, narrow viewports, and accessibility edge cases.
* **The audit is diagnostic, not punitive**: Severity ratings exist to prioritize, not to judge. Always deliver a path to fix alongside every problem identified.
* **Accessibility baseline**: WCAG 2.2 AA — 4.5:1 text contrast, keyboard operability, visible focus, targets at least 24px (44px recommended on touch).
* **Align with the project's voice**: If the project defines a brand-voice or tone-of-voice document, the design system is its visual counterpart. Spacing density, type weight, and color temperature should reflect the same verbal character.
* **Cross-reference**: Where the project keeps both, link between `design.md` and its voice document so they function as one coherent brand system.
