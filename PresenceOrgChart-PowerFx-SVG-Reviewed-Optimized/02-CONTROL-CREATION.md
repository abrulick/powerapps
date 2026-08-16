# Control Creation

For maximum formula compatibility, use the **classic** versions of Date Picker, Combo Box, and Drop down where available.

## Data source

Connect the existing SharePoint list and make sure the Canvas App data source is named:

`'Weekly Org Tracker'`

If the name differs, replace it in the formulas.

## Create these controls on `scrOrgChart`

| Control | Name | Required configuration |
|---|---|---|
| Screen | `scrOrgChart` | Main screen |
| Classic Date Picker | `dpPresenceDate` | Date selector |
| Button | `btnBuildChart` | `Visible = false` |
| Button | `btnRenderSvg` | `Visible = false` |
| Image | `imgOrgChart` | Main SVG renderer |
| Classic Combo Box | `cmbEmployee` | Single select; employee search |
| Classic Drop down | `ddLocationFilter` | Office highlight |
| Button | `btnPrevDay` | Previous weekday |
| Button | `btnNextDay` | Next weekday |
| Button | `btnZoomIn` | Zoom in |
| Button | `btnZoomOut` | Zoom out |
| Button | `btnFitAll` | Fit complete tree |
| Button | `btnCenterSelection` | Center selected person |
| Button | `btnRefreshData` | Refresh SharePoint |
| Label | `lblLastRefresh` | Refresh timestamp |
| Label | `lblChartMessage` | Empty/error/loading state |
| Label | `lblDataIssueCount` | Issue count |
| Gallery | `galDataIssues` | Issue details |
| Label | `lblInPersonCount` | In-person count |
| Label | `lblRemoteCount` | Remote count |
| Label | `lblVacationCount` | Vacation count |
| Label | `lblSickCount` | Sick count |
| Label | `lblHolidayCount` | Holiday count |
| Container | `conEmployeeDetail` | Selected person panel |
| Label | `lblSelectedName` | Selected employee |
| Label | `lblSelectedEmail` | Selected employee email |
| Label | `lblSelectedManager` | Manager |
| Label | `lblSelectedPresence` | Presence text |
| Label | `lblSelectedReports` | Direct-report count |

## Static Combo Box properties

`cmbEmployee.SelectMultiple = false`

`cmbEmployee.DisplayFields = ["EmployeeName"]`

`cmbEmployee.SearchFields = ["EmployeeName"]`

## Hidden helper controls

`btnBuildChart.Visible = false`

`btnRenderSvg.Visible = false`

## Image

`imgOrgChart` should occupy most of the screen, preferably in a landscape desktop/tablet layout.

Its Image, ImagePosition, and AccessibleLabel formulas are in:

`PowerFx/05_imgOrgChart.fx.txt`

## Before pasting formulas

Confirm Power Apps IntelliSense recognizes:

- `'Employee Name'.Email`
- `'Employee Name'.DisplayName`
- `'Manager Name'.Email`
- `'Manager Name'.DisplayName`
- `'Work Type (Mon)'.Value`
- `'Location (Mon)'.Value`

If a SharePoint column was renamed, use the identifier Power Apps Studio exposes.
