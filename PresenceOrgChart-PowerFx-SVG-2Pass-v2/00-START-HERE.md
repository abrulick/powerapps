# Presence-Aware Org Chart — Power Fx + SVG

This package implements a full-tree, presence-aware organization chart in a standard Microsoft Power Apps Canvas App **without PCF, custom code components, or changes to the existing SharePoint list structure**.

## Two-pass delivery model

### Pass 1 — Functional full-tree renderer

Build and validate the core pipeline:

- selected-week / selected-day SharePoint projection
- Person + Choice field handling
- full hierarchy construction
- root detection
- levels 0–6
- deterministic sibling ordering
- leaf-based X positions
- managers centered by average descendant-leaf position
- SVG connectors and employee cards
- presence-aware status/location display
- native Image-control rendering
- hierarchy/data-quality warnings

**Do not start Pass 2 until Pass 1 renders the real department correctly.**

### Pass 2 — Production UX and hardening

Add:

- employee search and highlighting
- office/location highlighting
- previous/next weekday navigation
- presence summary counters
- zoom, Fit All, and Center Selection
- selected employee details
- data-quality panel
- empty/error/loading states
- responsive behavior
- accessibility checks
- performance instrumentation
- UAT and deployment controls

## Recommended reading order

1. `01-ARCHITECTURE-AND-ASSUMPTIONS.md`
2. `02-CONTROL-MAP.md`
3. `03-PASS-1-IMPLEMENTATION.md`
4. `04-PASS-1-POWERFX.txt`
5. `05-PASS-2-IMPLEMENTATION.md`
6. `06-PASS-2-POWERFX.txt`
7. `07-TEST-PLAN.md`
8. `08-TROUBLESHOOTING.md`
9. `09-DEPLOYMENT-CHECKLIST.md`
10. `10-OFFICIAL-MICROSOFT-REFERENCES.md`
11. `11-IMPLEMENTATION-SEQUENCE.md`
12. `12-DATA-CONTRACT.md`

## Source list assumptions

One row represents one employee for one week.

- Employee Name — Person
- Manager Name — Person
- Work Type (Mon–Fri) — Choice
- Date (Mon–Fri) — Date
- Location (Mon–Fri) — Choice

Work Type values:

- In-Person
- Remote
- Vacation
- Sick
- Holiday

When In-Person is selected, Location contains one of the office choices.

## Design boundary

SharePoint remains the source. Power Apps builds a small selected-day projection, then performs all hierarchy/layout/SVG work locally.

No dependency on PCF, JavaScript, Dataverse, premium custom connectors, or external chart libraries.
