# Canvas App Control Map

Use these names to minimize formula edits.

## Pass 1

| Type | Name | Purpose |
|---|---|---|
| Screen | `scrOrgChart` | Main screen |
| Image | `imgOrgChart` | SVG renderer |
| Date picker | `dpPresenceDate` | Selected date |
| Button | `btnBuildChart` | Hidden behavior button |
| Label | `lblTreeWarning` | Hierarchy/data warning |
| Label | `lblStatus` | Optional diagnostics |

Set:

```powerfx
btnBuildChart.Visible = false
imgOrgChart.ImagePosition = ImagePosition.Fit
```

## Pass 2

| Type | Name | Purpose |
|---|---|---|
| Combo box | `cmbEmployee` | Employee search |
| Dropdown | `ddLocationFilter` | Office highlight |
| Button | `btnPrevDay` | Previous weekday |
| Button | `btnNextDay` | Next weekday |
| Button | `btnZoomIn` | Zoom in |
| Button | `btnZoomOut` | Zoom out |
| Button | `btnFit` | Fit all |
| Button | `btnCenterSelection` | Center selected person |
| Container | `conEmployeeDetail` | Selected person details |
| Gallery | `galDataIssues` | Data-quality issues |
| Labels | `lblInPersonCount`, etc. | Presence counters |

## Data source

Formulas assume:

```powerfx
'Weekly Org Tracker'
```

Replace this with your app's actual SharePoint data-source name.

## Field names

The examples use display names such as:

```powerfx
'Work Type (Mon)'
'Location (Mon)'
'Employee Name'
```

If IntelliSense exposes a different identifier, use what Power Apps Studio shows for your list.
