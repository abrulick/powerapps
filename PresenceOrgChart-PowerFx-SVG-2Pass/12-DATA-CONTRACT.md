# Data Contract

## `colPresenceValid`

| Column | Meaning |
|---|---|
| EmployeeKey | lower-case Employee Person Email |
| EmployeeName | Employee DisplayName |
| ManagerKey | lower-case Manager Person Email |
| ManagerName | Manager DisplayName |
| WorkDate | selected weekday Date |
| WorkType | selected weekday Choice.Value |
| WorkLocation | selected weekday Location Choice.Value |
| PresenceStatus | Work Type, with Location Missing override |
| PresenceText | user-facing status/location |

## `colOrgNodes` additions

| Column | Meaning |
|---|---|
| Level | hierarchy depth 0–6 |
| PathKey | email-based ancestry path |
| SortPath | deterministic branch ordering path |

## `colLeaves` additions

| Column | Meaning |
|---|---|
| LeafIndex | ordered leaf number |
| LeafX | horizontal leaf center |

## `colLayout` additions

| Column | Meaning |
|---|---|
| DirectReportCount | local direct-report count |
| NodeX | SVG node horizontal center |
| NodeY | SVG node top position |

## SVG variables

| Variable | Meaning |
|---|---|
| varSvgConnectors | connector markup |
| varSvgNodes | node-card markup |
| varOrgChartSvg | full SVG |
| varChartWidth | SVG width |
| varChartHeight | SVG height |

Keep this contract stable between passes.
