# Pass 2 — Production UX and Hardening

## Objective

Keep the validated Pass 1 hierarchy/layout engine and add daily-use interaction, navigation, resilience, accessibility, and deployment controls.

## Workstream 1 — Employee search and selection

Add `cmbEmployee` and `conEmployeeDetail`.

Populate the Combo Box from `colPresenceValid`, sorted by EmployeeName. Configure single select.

On selection set `varSelectedEmployeeKey`, rebuild only the SVG styling (or use the single build button initially), and highlight the selected node with a thicker blue border.

The detail panel should show:

- employee name;
- manager name;
- selected-day Work Type;
- office when In-Person;
- direct-report count.

Acceptance:

- [ ] employee found by typing name
- [ ] selected node highlighted
- [ ] detail panel correct
- [ ] selection survives date change if employee still exists

## Workstream 2 — Office/location highlighting

Do not filter nonmatching employees out of the tree; doing so destroys organizational context.

Use `ddLocationFilter`:

```text
All Locations
<office choices>
```

Rendering behavior:

```text
All Locations                -> opacity 1.0
Employee at selected office  -> opacity 1.0
Selected employee            -> opacity 1.0
All other nodes              -> opacity about 0.30
```

Connectors can remain visible at normal or slightly reduced opacity.

## Workstream 3 — Weekday navigation

Add Previous/Next buttons that skip weekends:

```text
Friday -> Next -> Monday
Monday -> Previous -> Friday
```

Each updates `varSelectedDate` and rebuilds.

## Workstream 4 — Presence summary

Add native labels/cards for:

- In Person
- Remote
- Vacation
- Sick
- Holiday
- Data Issues

Counts come directly from `colPresenceValid`.

## Workstream 5 — Zoom / Fit / Center

Because the SVG is hosted in one Image control, zoom by changing SVG `viewBox`.

Variables:

```text
varZoom
varViewCenterX
varViewCenterY
varViewportWidth
varViewportHeight
varViewLeft
varViewTop
```

### Fit All

Reset zoom to 1 and chart center.

### Zoom In/Out

Example factor 1.2, with floor 0.5 and ceiling 3.0.

### Center Selection

Look up selected employee's NodeX/NodeY in `colLayout`, set the view center, optionally set minimum zoom around 1.5.

## Workstream 6 — Data-quality panel

Create `galDataIssues` for:

- blank employee email;
- In-Person missing location;
- duplicate employee weekly rows;
- self-manager;
- unexpected external/missing manager;
- unplaced hierarchy records;
- hierarchy depth beyond supported level.

Do not silently hide these conditions.

## Workstream 7 — Loading/error/empty states

Use variables such as:

```text
varChartBuilding
varChartError
```

Native labels/containers should handle:

- loading schedule;
- building hierarchy;
- empty selected week;
- weekend selected;
- hierarchy issue;
- source error.

A blank SVG should never be the only error indication.

## Workstream 8 — Responsive behavior

Primary target: desktop/tablet landscape.

Recommendations:

- responsive containers for header/filter bars;
- chart gets maximum available width;
- Fit All default;
- fixed node dimensions initially;
- zoom via viewBox rather than resizing every card;
- phone experience may use a summary/detail alternative if full tree is too dense.

## Workstream 9 — Accessibility

Do not rely on SVG or status color alone for essential information.

Use native controls for search, counts, selected-person details, warnings, and filters.

Every presence color also has text.

## Workstream 10 — Performance hardening

Measure:

```text
employee count
hierarchy depth
leaf count
SVG text length
build start/end timestamps
```

If performance needs work:

1. remove SVG whitespace;
2. truncate overly long visible labels;
3. avoid expensive effects/shadows;
4. keep selected-day source set small;
5. separate layout rebuild from style-only SVG rendering;
6. index `Date (Mon)`;
7. do not rebuild hierarchy for selection/location/zoom if not necessary.

## Optional optimization — split layout and render

After correctness is proven, replace one build button with:

```text
btnBuildLayout
btnRenderSvg
```

Rebuild layout only when date or org structure changes.

Re-render SVG only when selection, office highlight, or zoom changes.

## Pass 2 exit gate

- [ ] search works
- [ ] selected node highlight works
- [ ] detail panel correct
- [ ] location highlight preserves tree
- [ ] weekday navigation skips weekends
- [ ] counters match data
- [ ] zoom in/out works
- [ ] Fit All works
- [ ] Center Selection works
- [ ] data issues surfaced
- [ ] empty/weekend/error states handled
- [ ] target screens tested
- [ ] UAT approved
