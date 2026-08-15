# Recommended Implementation Sequence

## Pass 1

### Session 1 — Source projection
1. Connect SharePoint.
2. Add controls.
3. Implement selected date/week.
4. Build `colPresence` and `colPresenceValid`.
5. Inspect data manually.

**Gate:** selected-day data correct.

### Session 2 — Hierarchy
1. Build Level 0.
2. Build Levels 1–6.
3. Build `colOrgNodes`.
4. Add unplaced warning.
5. Compare to known org.

**Gate:** hierarchy correct.

### Session 3 — Layout
1. Build leaves.
2. assign LeafX.
3. build `colLayout`.
4. inspect NodeX/NodeY.
5. validate manager centering.

**Gate:** layout correct.

### Session 4 — SVG
1. connectors.
2. cards.
3. SVG wrapper.
4. Image control.
5. tune spacing.
6. Mon–Fri test.

**Gate:** Pass 1 checklist complete.

## Pass 2

### Session 1 — Search/selection
Combo Box, selected variable, highlight, detail panel.

### Session 2 — Operational view
Location highlighting, counters, previous/next weekday.

### Session 3 — Navigation
viewBox, zoom, Fit All, Center Selection.

### Session 4 — Hardening
Data issues, empty/error/loading states, responsive layout, diagnostics, accessibility.

### Session 5 — UAT/release
Test plan, stakeholder UAT, fixes, publish, production smoke test.

## Change-control rule

During Pass 1, avoid feature polish that changes hierarchy formulas. During Pass 2, avoid changing SharePoint structure. Keep `colPresenceValid` as the stable source-to-render contract.
