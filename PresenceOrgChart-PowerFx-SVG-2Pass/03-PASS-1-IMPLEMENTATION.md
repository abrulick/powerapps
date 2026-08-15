# Pass 1 — Functional Full-Tree Renderer

## Objective

Produce a correct full organizational tree for one selected weekday from the existing SharePoint tracker.

Pass 1 succeeds when every selected-week employee appears once, manager relationships are correct, managers are centered over descendant leaves, presence is correct, and date changes rebuild the tree.

## Step 1 — Connect SharePoint

1. Open the Canvas App.
2. Add the SharePoint data source.
3. Select the weekly org-tracker list.
4. Confirm the data-source name.
5. Verify the four field types used by formulas: Employee/Manager = Person; Work Type/Location = Choice.
6. If allowed administratively, index `Date (Mon)`.

## Step 2 — Create the Pass 1 controls

Create the controls listed in `02-CONTROL-MAP.md`. Hide `btnBuildChart` after formulas are installed.

## Step 3 — Initialize layout constants

Use `scrOrgChart.OnVisible` from `04-PASS-1-POWERFX.txt`.

Initial geometry:

```text
Node width       220
Node height       92
Horizontal gap    44
Vertical gap      76
Margin            50
```

Do not tune these until the hierarchy is correct.

## Step 4 — Build the selected-day data contract

The build formula calculates `varWeekStart`, filters SharePoint to the selected week, then maps only the selected weekday's wide columns into a consistent record:

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

The output is `colPresence`, followed by `colPresenceValid` for records with usable employee keys.

### Checkpoint A

Inspect `colPresenceValid` in the Collections viewer.

PASS when:

- record count equals expected employees for the week;
- EmployeeKey is the lower-case employee email;
- ManagerKey is the lower-case manager email;
- correct weekday's Work Type is shown;
- in-person office is correct;
- Remote/Vacation/Sick/Holiday do not inherit a stale office;
- In-Person with blank Location becomes `Location Missing`.

Do not debug the SVG until this collection is correct.

## Step 5 — Build hierarchy levels

Build `colLevel0` through `colLevel6`.

### Level 0 rule

A local root is an employee whose manager is blank or whose ManagerKey does not exist as an EmployeeKey in the selected-day collection.

### Levels 1–6

Each level finds employees whose ManagerKey matches a parent in the preceding level.

Each hierarchy record adds:

```text
Level
PathKey
SortPath
```

`PathKey` is email-based and used to identify descendants.

`SortPath` incorporates employee name plus email and is used for deterministic alphabetical branch ordering.

## Step 6 — Combine hierarchy

Combine every level into `colOrgNodes`.

Calculate:

```powerfx
varUnplacedEmployees = CountRows(colPresenceValid) - CountRows(colOrgNodes)
```

If greater than zero, investigate before layout work. Typical causes: depth beyond Level 6, cycles, self-manager records, malformed manager data, duplicate weekly rows.

### Checkpoint B

Compare `colOrgNodes` to a known-good organizational hierarchy.

## Step 7 — Find leaves

A leaf has no direct report within `colOrgNodes`.

Build `colLeavesBase`, sorted by `SortPath`.

## Step 8 — Assign leaf X positions

Use `Sequence()` plus `Index()` to create deterministic `LeafIndex` and `LeafX` values in `colLeaves`.

The horizontal spacing is:

```text
varNodeWidth + varXGap
```

## Step 9 — Position every manager by descendant average

Build `colLayout`.

Each record gets:

```text
DirectReportCount
NodeX
NodeY
```

For a leaf, NodeX equals its leaf position.

For a manager, NodeX equals the Average of every descendant leaf whose `PathKey` begins with the manager's `PathKey`.

This centers managers over their entire branch rather than merely over their direct children.

`NodeY` is based on hierarchy Level.

### Checkpoint C

Inspect `colLayout` before SVG. Confirm uneven-depth branches still have sensible X positions.

## Step 10 — Generate connectors

For every non-root node, find the manager in `colLayout` and generate an SVG cubic path from parent bottom-center to child top-center.

Store all connector fragments in `varSvgConnectors` using `Concat()`.

## Step 11 — Generate employee cards

Each node produces:

- white rounded card;
- status-color strip;
- employee name;
- presence/location text;
- direct-report count.

Starter status colors:

```text
In-Person        #107C10
Remote           #0078D4
Vacation         #8764B8
Sick             #D83B01
Holiday          #5C2D91
Location Missing #A4262C
```

Always show textual status as well as color.

Use `EncodeHTML()` on employee/location text inserted into SVG.

## Step 12 — Assemble and render SVG

Build `varOrgChartSvg`, then set the Image property:

```powerfx
"data:image/svg+xml;utf8," & EncodeUrl(varOrgChartSvg)
```

## Step 13 — Date switching

`dpPresenceDate.OnChange` updates `varSelectedDate` and reruns `btnBuildChart`.

Pass 1 intentionally rebuilds the selected-day tree. Keep it simple until correct.

## Pass 1 exit gate

- [ ] Mon–Fri statuses correct
- [ ] all expected employees appear once
- [ ] roots correct
- [ ] reporting relationships correct
- [ ] managers centered over branches
- [ ] in-person office visible
- [ ] Remote/Vacation/Sick/Holiday correct
- [ ] missing location flagged
- [ ] unplaced count is zero for valid data
- [ ] real department dataset tested
- [ ] target desktop/tablet screen renders acceptably

Only then begin Pass 2.
