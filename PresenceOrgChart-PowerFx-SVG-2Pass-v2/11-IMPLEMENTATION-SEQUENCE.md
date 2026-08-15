# Implementation Sequence — Two Strictly Separate Passes

This is the **authoritative build order** for the Power Fx + SVG implementation.

The two passes are intentionally separated by a hard acceptance gate.

---

# PASS 1 — Build and Prove the Full-Tree Engine

## Pass 1 objective

At the end of Pass 1, the app must be able to:

1. read the selected week's existing SharePoint rows;
2. project one selected weekday into a normalized local collection;
3. reconstruct the complete reporting hierarchy;
4. calculate stable X/Y positions;
5. render the complete hierarchy as SVG in a native Image control;
6. show each employee's selected-day presence status and location;
7. rebuild correctly when the selected weekday changes;
8. report hierarchy/data errors.

**Pass 1 is complete even though the chart is not yet searchable, zoomable, filterable, or production-polished.**

## Do NOT build during Pass 1

Do not add any of these yet:

- employee search
- employee details panel
- location highlighting/filtering
- Zoom In / Zoom Out
- Fit All
- Center Selection
- previous/next weekday buttons
- presence summary tiles
- responsive/mobile refinements
- production loading animations
- performance optimizations
- branch collapse/expand

Those belong to Pass 2.

---

## PASS 1 — Step 1: Verify the SharePoint contract

Before writing hierarchy code, verify the actual list columns in Power Apps Studio.

Required source fields:

```text
Employee Name        Person
Manager Name         Person

Work Type (Mon)      Choice
Work Type (Tue)      Choice
Work Type (Wed)      Choice
Work Type (Thu)      Choice
Work Type (Fri)      Choice

Date (Mon)           Date
Date (Tue)           Date
Date (Wed)           Date
Date (Thu)           Date
Date (Fri)           Date

Location (Mon)       Choice
Location (Tue)       Choice
Location (Wed)       Choice
Location (Thu)       Choice
Location (Fri)       Choice
```

Confirm the Work Type Choice values are exactly:

```text
In-Person
Remote
Vacation
Sick
Holiday
```

### Gate 1A

Do not continue until the SharePoint connector exposes:

```powerfx
'Employee Name'.Email
'Employee Name'.DisplayName
'Manager Name'.Email
'Manager Name'.DisplayName
'Work Type (Mon)'.Value
'Location (Mon)'.Value
```

or the equivalent names shown by your Power Apps IntelliSense.

---

## PASS 1 — Step 2: Create only the minimum controls

Create:

```text
scrOrgChart
dpPresenceDate
btnBuildChart
imgOrgChart
lblTreeWarning
lblStatus
```

Set:

```powerfx
btnBuildChart.Visible = false
```

Do not add the Pass 2 controls yet.

Reference:

- `02-CONTROL-MAP.md`
- `04-PASS-1-POWERFX.txt`

---

## PASS 1 — Step 3: Initialize the date and chart constants

Implement the `scrOrgChart.OnVisible` section from:

```text
04-PASS-1-POWERFX.txt
```

This establishes:

```text
varSelectedDate
varNodeWidth
varNodeHeight
varXGap
varYGap
varChartMargin
```

The screen should then call:

```powerfx
Select(btnBuildChart)
```

### Gate 1B

Confirm `varSelectedDate` contains the expected date and the screen loads without formula errors.

---

## PASS 1 — Step 4: Build the selected-day source collection

Implement only sections D1 through D3 of `btnBuildChart.OnSelect`.

The required output is:

```text
colPresenceValid
```

with this contract:

```text
EmployeeKey
EmployeeName
ManagerKey
ManagerName
WorkDate
WorkType
WorkLocation
PresenceStatus
PresenceText
```

### Validate before proceeding

Open the Power Apps Collections viewer and manually inspect several employees.

For each sample employee verify:

```text
EmployeeKey      = Employee Name.Email, lower case
EmployeeName     = Employee Name.DisplayName
ManagerKey       = Manager Name.Email, lower case
ManagerName      = Manager Name.DisplayName
WorkDate         = correct selected weekday date
WorkType         = correct selected weekday Choice value
WorkLocation     = correct selected weekday location
PresenceText     = correct user-facing text
```

For an In-Person employee:

```text
PresenceText = In Person — <office>
```

For Remote/Vacation/Sick/Holiday, no stale office should be shown.

### HARD GATE 1

**Stop here if `colPresenceValid` is wrong.**

Do not troubleshoot hierarchy or SVG until the selected-day collection is correct.

Pass condition:

```powerfx
CountRows(colPresenceValid)
```

matches the expected employees for that week's tracker.

---

## PASS 1 — Step 5: Build the hierarchy only

Implement sections D4 through D6.

Build:

```text
colLevel0
colLevel1
colLevel2
colLevel3
colLevel4
colLevel5
colLevel6
colOrgNodes
```

The hierarchy logic must use:

```text
EmployeeKey = unique node key
ManagerKey  = parent key
```

Do not use display names as relationship keys.

### Validate hierarchy without SVG

Inspect `colOrgNodes`.

For known employees verify:

```text
EmployeeName
ManagerName
Level
PathKey
SortPath
```

Check several known reporting chains manually.

Example:

```text
Director       Level 0
Manager A      Level 1
Supervisor A   Level 2
Employee A     Level 3
```

### Check completeness

Evaluate:

```powerfx
varUnplacedEmployees
```

Expected for valid production data:

```text
0
```

### HARD GATE 2

Do not continue if:

- a known manager/employee relationship is incorrect;
- an employee appears more than once;
- an employee is missing;
- a valid employee remains unplaced;
- a manager cycle/self-manager exists;
- required hierarchy depth exceeds Level 6.

Resolve those issues first.

---

## PASS 1 — Step 6: Build leaf ordering

Implement D7 and D8.

Required collections:

```text
colLeavesBase
colLeaves
```

Inspect:

```text
EmployeeName
SortPath
LeafIndex
LeafX
```

The leaf ordering should group employees from the same reporting branch together.

### HARD GATE 3

Do not build SVG until leaf ordering is stable and deterministic.

Change dates and rebuild several times.

The same hierarchy should produce the same leaf order.

---

## PASS 1 — Step 7: Calculate node layout

Implement D9 and D10.

Required collection:

```text
colLayout
```

Required fields:

```text
DirectReportCount
NodeX
NodeY
```

### Validate manager centering mathematically

For a manager:

1. identify all descendant leaves whose `PathKey` begins with the manager's `PathKey`;
2. inspect those leaves' `LeafX` values;
3. calculate their average;
4. confirm the manager's `NodeX` equals that average.

Example:

```text
Leaf A X = 160
Leaf B X = 424

Manager X =
Average(160, 424)
= 292
```

### HARD GATE 4

Do not generate SVG until `colLayout` is correct.

At this point the difficult tree-layout problem should already be solved.

---

## PASS 1 — Step 8: Generate SVG connectors

Implement D11.

Output:

```text
varSvgConnectors
```

Do not worry about visual polish.

The only objective is correct parent-to-child connectors.

---

## PASS 1 — Step 9: Generate SVG employee nodes

Implement D12.

Output:

```text
varSvgNodes
```

Every node must contain:

```text
Employee name
Presence text
Direct report count
Presence status strip
```

Do not add selection/location/zoom styling yet.

---

## PASS 1 — Step 10: Assemble and display the SVG

Implement D13 and the `imgOrgChart.Image` property.

Expected:

```powerfx
"data:image/svg+xml;utf8," &
EncodeUrl(varOrgChartSvg)
```

Set:

```powerfx
imgOrgChart.ImagePosition = ImagePosition.Fit
```

At this point, the complete full-tree chart should be visible.

---

## PASS 1 — Step 11: Test all five weekdays

Using `dpPresenceDate`, test:

```text
Monday
Tuesday
Wednesday
Thursday
Friday
```

The organization structure should normally remain the same while:

```text
WorkType
WorkLocation
PresenceStatus
PresenceText
```

change by day.

Also test:

- a week boundary;
- a week with no data;
- a weekend;
- an employee with In-Person + missing location.

---

# PASS 1 — FINAL ACCEPTANCE GATE

Pass 1 is complete only when **all** are true:

- [ ] `colPresenceValid` contains the correct employees
- [ ] Work Type is correct for selected weekday
- [ ] office location is correct
- [ ] hierarchy matches known reporting structure
- [ ] all valid employees appear exactly once
- [ ] `varUnplacedEmployees = 0`
- [ ] root employee(s) are correct
- [ ] leaf ordering is stable
- [ ] manager X positions correctly average descendant leaves
- [ ] connector lines connect correct parent/child nodes
- [ ] full SVG renders in `imgOrgChart`
- [ ] In-Person nodes display office
- [ ] Remote/Vacation/Sick/Holiday display correctly
- [ ] missing In-Person location is visibly flagged
- [ ] Monday–Friday date changes work
- [ ] empty/weekend states do not crash the app

## Pass 1 deliverable

Create/save a Power Apps version explicitly named or documented as:

```text
PASS 1 — Full Tree Engine Validated
```

Do not proceed to Pass 2 without preserving this working version for rollback.

---

---

# PASS 2 — Add Production Interaction and Hardening

## Pass 2 entry requirement

**Pass 1 must already be accepted and saved as a known-good app version.**

Pass 2 must treat these structures as stable contracts:

```text
colPresenceValid
colOrgNodes
colLeaves
colLayout
```

Do not redesign the SharePoint list or rewrite hierarchy construction merely to add UI features.

## Pass 2 objective

Turn the validated tree renderer into a production-friendly departmental presence application.

Pass 2 adds:

1. employee search and selected-person highlighting;
2. employee detail panel;
3. location highlighting;
4. presence summary counters;
5. previous/next weekday navigation;
6. zoom;
7. Fit All;
8. Center Selection;
9. data-quality diagnostics;
10. loading/empty/error states;
11. responsive layout and accessibility;
12. UAT and deployment.

---

## PASS 2 — Step 1: Freeze and protect the Pass 1 engine

Before modifying formulas:

1. save/publish or version the working Pass 1;
2. record the values of:
   - `CountRows(colPresenceValid)`
   - `CountRows(colOrgNodes)`
   - `CountRows(colLeaves)`
   - `varChartWidth`
   - `varChartHeight`
3. take a screenshot of a known-good weekday chart.

These become regression references.

---

## PASS 2 — Step 2: Add employee search and selection

Add:

```text
cmbEmployee
conEmployeeDetail
```

Implement section A and B from:

```text
06-PASS-2-POWERFX.txt
```

Selection should set:

```text
varSelectedEmployeeKey
```

Modify **only SVG node styling**, not hierarchy logic.

Selected node:

```text
blue/thicker border
```

### Gate 2A

Selecting an employee must not change:

```text
CountRows(colOrgNodes)
NodeX
NodeY
```

It is a rendering state only.

---

## PASS 2 — Step 3: Add selected employee details

Use native Canvas labels/containers to show:

```text
EmployeeName
ManagerName
PresenceText
WorkLocation
DirectReportCount
```

This is the primary accessible detail surface.

Do not rely on SVG node text as the only way to read employee information.

---

## PASS 2 — Step 4: Add office/location highlighting

Add:

```text
ddLocationFilter
```

Behavior:

```text
All Locations -> all nodes normal
Selected office -> matching in-person nodes normal
                  nonmatching nodes dimmed
```

**Do not remove nonmatching employees from the hierarchy.**

Removing them would destroy organizational context.

### Gate 2B

Location highlighting must not change:

```text
colOrgNodes
colLeaves
colLayout
```

Only SVG opacity/styling should change.

---

## PASS 2 — Step 5: Add presence summary counters

Add:

```text
lblInPersonCount
lblRemoteCount
lblVacationCount
lblSickCount
lblHolidayCount
```

Counts come directly from:

```text
colPresenceValid
```

Validate counts manually against a known selected day.

---

## PASS 2 — Step 6: Add Previous / Next weekday navigation

Add:

```text
btnPrevDay
btnNextDay
```

Use the formulas in `06-PASS-2-POWERFX.txt`.

Required behavior:

```text
Monday previous -> Friday
Friday next     -> Monday
```

Do not land on weekends.

Changing date is allowed to rebuild the entire Pass 1 engine because source presence and potentially hierarchy records may differ by week.

---

## PASS 2 — Step 7: Add Zoom and Fit All

Add:

```text
btnZoomIn
btnZoomOut
btnFit
```

Implement zoom through SVG `viewBox`.

Do not change NodeX/NodeY to zoom.

The tree layout remains fixed; only the visible SVG window changes.

### Gate 2C

Fit All must reproduce the same complete chart framing as the original Pass 1 rendering.

---

## PASS 2 — Step 8: Add Center Selection

Add:

```text
btnCenterSelection
```

Look up the selected person's:

```text
NodeX
NodeY
```

from `colLayout`.

Change only:

```text
varViewCenterX
varViewCenterY
varZoom
```

Then re-render SVG.

The hierarchy should not be recalculated solely because a user centers a selection unless the simple implementation still uses `btnBuildChart`; optimization can happen later.

---

## PASS 2 — Step 9: Add data-quality diagnostics

Add:

```text
galDataIssues
```

At minimum detect:

- In-Person with blank Location
- blank EmployeeKey
- self-manager
- duplicate employee record
- unplaced employee
- hierarchy depth exceeded
- unexpected local root / missing manager

Separate valid "manager outside department" roots from true data issues where possible.

---

## PASS 2 — Step 10: Add user-facing loading, empty, and error states

The app should never communicate failure by showing only a blank image.

Add visible states for:

```text
Building chart…
No tracker records for selected week
Select a Monday–Friday date
Hierarchy issue detected
No employees match expected source data
```

Optional variables:

```text
varChartBuilding
varChartError
```

---

## PASS 2 — Step 11: Responsive and accessibility review

Recommended primary form factor:

```text
desktop/tablet landscape
```

Review:

- chart container width/height;
- header/filters in responsive containers;
- readable node text;
- status text in addition to color;
- native employee details panel;
- keyboard-accessible Combo Box and buttons;
- contrast.

Do not attempt to make a very large full-tree SVG behave like a phone-first UI.

If phone use is required, create a simplified alternate view.

---

## PASS 2 — Step 12: Performance hardening

Only optimize after real-data measurement.

Capture:

```text
CountRows(colPresenceValid)
CountRows(colOrgNodes)
CountRows(colLeaves)
Len(varOrgChartSvg)
```

If interaction feels slow, split the implementation into:

```text
Layout rebuild
vs.
SVG re-render
```

### Layout rebuild required when:

- selected date/week changes;
- source hierarchy changes.

### SVG-only re-render sufficient when:

- employee selection changes;
- location highlighting changes;
- zoom changes;
- viewport center changes.

This optimization is optional and belongs at the end of Pass 2.

---

## PASS 2 — Step 13: Regression test against Pass 1

Before UAT, repeat the complete Pass 1 test set.

Confirm that Pass 2 features did not alter:

- employee completeness;
- hierarchy;
- leaf order;
- manager centering;
- connectors;
- presence accuracy.

---

## PASS 2 — Step 14: UAT and production release

Use:

```text
07-TEST-PLAN.md
09-DEPLOYMENT-CHECKLIST.md
```

UAT should include:

- department manager;
- tracker/list owner;
- several typical employees;
- at least one user working at a non-primary office.

Publish only after UAT acceptance.

---

# PASS 2 — FINAL ACCEPTANCE GATE

Pass 2 is complete only when:

- [ ] Pass 1 regression tests still pass
- [ ] employee search works
- [ ] selected node highlights
- [ ] employee detail panel is correct
- [ ] location highlighting preserves complete hierarchy
- [ ] presence counters match source data
- [ ] previous/next weekday skips weekends
- [ ] Zoom In works
- [ ] Zoom Out works
- [ ] Fit All works
- [ ] Center Selection works
- [ ] data-quality issues are visible
- [ ] empty/error/loading states are understandable
- [ ] target form factors are usable
- [ ] performance is acceptable with real department data
- [ ] accessibility review completed
- [ ] UAT accepted
- [ ] production smoke test passed

## Pass 2 deliverable

Production-ready application:

```text
SharePoint
   ->
selected-day presence projection
   ->
validated hierarchy/layout engine
   ->
native Power Fx-generated SVG
   ->
searchable, filterable, zoomable departmental presence org chart
```

---

# The rule that keeps the project manageable

## Pass 1 answers:

> **Can the existing SharePoint data reliably produce the correct full-tree presence chart?**

## Pass 2 answers:

> **Can users comfortably operate that already-correct chart in production?**

Do not solve both questions at the same time.
