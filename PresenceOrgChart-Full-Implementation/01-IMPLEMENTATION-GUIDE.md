# Full Implementation Guide: Presence-Aware Full-Tree Org Chart in Power Apps

## 1. Goal and architecture

This guide builds a full-tree org chart without changing the SharePoint list structure.

The design has two responsibilities:

1. **Power Apps / Power Fx** selects the relevant weekly SharePoint rows and reshapes the selected weekday into a clean table.
2. **A Power Apps Component Framework (PCF) dataset control** renders that clean table as a recursive full-tree organization chart.

```text
SharePoint weekly tracker
        │
        │ delegable filter: selected Monday/week
        ▼
Power Fx table shaping
        │
        │ EmployeeKey / ManagerKey / WorkType / Location
        ▼
PCF dataset Items
        │
        ▼
Full recursive org tree
```

The PCF does **not** connect directly to SharePoint. That separation is intentional: Power Apps owns authentication/connectors and the PCF owns visualization.

---

# PART A — PREPARE THE ENVIRONMENT

## 2. Prerequisites

You need:

- A Power Apps environment where you can import solutions.
- Permission to edit the target canvas app.
- Permission to read the SharePoint tracker list.
- An administrator who can enable **Power Apps component framework for canvas apps** in the environment if it is not already enabled.
- A developer workstation with:
  - Visual Studio Code
  - Node.js LTS
  - Microsoft Power Platform CLI (`pac`)
  - .NET SDK 6 or newer for solution build, or an appropriate MSBuild installation

Verify the local tools:

```powershell
node --version
npm --version
pac --version
dotnet --version
```

If `pac` is not recognized, install/update Microsoft Power Platform CLI before continuing.

## 3. Enable PCF for canvas apps

An environment administrator should:

1. Open Power Platform admin center.
2. Select the environment.
3. Open **Settings**.
4. Expand **Product**.
5. Open **Features**.
6. Enable **Power Apps component framework for canvas apps**.
7. Save.

This setting is environment-specific. It must be enabled in every environment where the canvas app will use the PCF.

## 4. Verify SharePoint list assumptions

Do not change the schema. Verify that the existing list contains:

```text
Employee Name         Person
Manager Name          Person

Work Type (Mon)       Choice
Work Type (Tue)       Choice
Work Type (Wed)       Choice
Work Type (Thu)       Choice
Work Type (Fri)       Choice

Date (Mon)            Date / DateTime
Date (Tue)            Date / DateTime
Date (Wed)            Date / DateTime
Date (Thu)            Date / DateTime
Date (Fri)            Date / DateTime

Location (Mon)        Choice
Location (Tue)        Choice
Location (Wed)        Choice
Location (Thu)        Choice
Location (Fri)        Choice
```

Also verify:

- One row represents one employee for one tracked week.
- `Date (Mon)` identifies that row's week.
- Employee Person values contain email addresses.
- Manager Person values contain email addresses where applicable.
- Each `Work Type` Choice uses the exact text expected by the app.
- Location is populated when Work Type is `In-Person`.

### Recommended non-schema SharePoint optimization

If the tracker has substantial historical data, index `Date (Mon)` in SharePoint. This does not alter the application data structure; it makes the primary week-selection column more suitable for filtered access as the list grows.

---

# PART B — BUILD THE POWER APPS LAYER

## 5. Add SharePoint to the canvas app

In Power Apps Studio:

1. Open the target canvas app.
2. Select **Data**.
3. Select **Add data**.
4. Select the SharePoint connector.
5. Select/connect to the SharePoint site.
6. Select the weekly tracker list.
7. Add it to the app.

This guide refers to the data source as:

```powerfx
'Weekly Org Tracker'
```

If Power Apps gives your list a different data-source name, replace every occurrence in the package formulas.

## 6. Choose the target form factor

A full-tree organization chart is best in a tablet/web landscape layout.

Recommended:

- Responsive canvas app or tablet layout
- Org-chart screen width that can use most of the browser window
- PCF container taking the majority of the screen
- Optional selected-person details pane on the right

Phone users can still pan and zoom, but a full-tree hierarchy naturally benefits from a larger viewport.

## 7. Create the org-chart screen

Create a screen named:

```text
scrPresenceOrgChart
```

Recommended screen hierarchy:

```text
scrPresenceOrgChart
└── conPage
    ├── conHeader
    │   ├── btnPreviousDay
    │   ├── dpPresenceDate
    │   └── btnNextDay
    └── conBody
        ├── pcfOrgChart
        └── conSelectedEmployee   (optional)
            ├── lblSelectedName
            └── lblSelectedPresence
```

The PCF has its own internal search, zoom, fit, expand and collapse toolbar.

## 8. Initialize date variables

Copy `PowerApps/01-App-OnStart.fx.txt` into `App.OnStart`.

The result is:

- weekdays → selected date is Today()
- Saturday/Sunday → selected date defaults to the previous Friday
- `varWeekStart` always resolves to the Monday containing `varSelectedDate`

After changing `App.OnStart`, run **OnStart** from Power Apps Studio or reopen/reload the app before testing.

## 9. Configure the date picker

Add a Date Picker:

```text
Name: dpPresenceDate
DefaultDate: varSelectedDate
```

Paste `PowerApps/03-DatePicker-OnChange.fx.txt` into its `OnChange` property.

The formula rejects Saturday/Sunday because the tracker is Monday-Friday only.

## 10. Add previous/next weekday navigation

Add two buttons or icons:

```text
btnPreviousDay
btnNextDay
```

Paste:

- `PowerApps/04-Previous-Day-OnSelect.fx.txt`
- `PowerApps/05-Next-Day-OnSelect.fx.txt`

These skip weekends automatically:

```text
Friday → Monday
Monday → Friday
```

## 11. Understand the PCF Items formula

The core Power Fx implementation is in:

```text
PowerApps/02-PCF-Items.fx.txt
```

This formula does three things.

### 11.1 Delegably filter SharePoint to one week

It begins with a date-range filter:

```powerfx
Filter(
    'Weekly Org Tracker',
    'Date (Mon)' >= varWeekStart &&
    'Date (Mon)' < DateAdd(varWeekStart, 1, TimeUnit.Days)
)
```

The date range is deliberately preferred over applying `DateValue()` to the SharePoint column. DateTime comparisons can delegate to SharePoint, while wrapping a source column in local conversion logic can prevent delegation.

The one-day range also works whether your SharePoint field is configured as Date Only or Date and Time.

### 11.2 Select the correct Monday-Friday pair

The formula calculates:

```powerfx
dayNumber = Weekday(varSelectedDate, StartOfWeek.Monday)
```

Then it resolves the selected day's values:

```text
1 → Work Type (Mon) + Location (Mon)
2 → Work Type (Tue) + Location (Tue)
3 → Work Type (Wed) + Location (Wed)
4 → Work Type (Thu) + Location (Thu)
5 → Work Type (Fri) + Location (Fri)
```

### 11.3 Produce the clean PCF schema

The PCF receives only:

```text
EmployeeKey
EmployeeName
ManagerKey
ManagerName
WorkType
WorkLocation
PresenceStatus
PresenceText
```

Example:

```text
EmployeeKey               ManagerKey                WorkType     WorkLocation
jane@contoso.com           robert@contoso.com        In-Person    New York
mike@contoso.com           robert@contoso.com        Remote
amy@contoso.com            jane@contoso.com          Vacation
```

No Monday-Friday-specific SharePoint column names leak into the visualization component.

## 12. Why EmployeeKey and ManagerKey use email

The implementation maps:

```powerfx
EmployeeKey = Lower('Employee Name'.Email)
ManagerKey  = Lower('Manager Name'.Email)
```

The tree therefore joins manager relationships by email rather than display name.

This avoids ambiguity from duplicate names such as two employees both named `John Smith`.

SharePoint Person columns expose `Email` and `DisplayName` subfields in Power Apps; those are also the Person subfields Microsoft documents as delegable for SharePoint when used in source queries.

## 13. Presence-status rules

The selected day's Work Type is authoritative.

The implementation resolves:

```text
In-Person + office → In Person — <Office>
Remote             → Remote
Vacation           → Vacation
Sick               → Sick
Holiday            → Holiday
```

There is one additional data-quality state:

```text
WorkType = In-Person + blank Location → Location Missing
```

That state is rendered in the chart so incomplete tracker entries are visible rather than silently misclassified.

## 14. Do not use ClearCollect for the historical SharePoint list

Earlier prototypes may be tempting to write as:

```powerfx
ClearCollect(colWeekRaw, Filter('Weekly Org Tracker', ...))
```

Do **not** make that the production retrieval pattern for a tracker that accumulates history.

`ClearCollect` itself is not delegable when used with a remote data source. This package instead binds the PCF directly to a shaped table expression whose inner `Filter` can delegate to SharePoint.

The table-shaping output is still subject to the canvas non-delegation row limit, which is why this pattern is explicitly designed for a small department where one week's employee rows are well below that limit.

---

# PART C — CREATE THE PCF CONTROL

## 15. Create a clean developer folder

Example:

```powershell
mkdir C:\repos\PresenceOrgChart
cd C:\repos\PresenceOrgChart
```

## 16. Initialize a dataset PCF

Run:

```powershell
pac pcf init `
  --namespace OrgPresence `
  --name PresenceOrgChart `
  --template dataset `
  --run-npm-install
```

Equivalent one-line command:

```powershell
pac pcf init --namespace OrgPresence --name PresenceOrgChart --template dataset --run-npm-install
```

The `dataset` template is required because the control receives a table of organization records rather than one scalar field.

## 17. Overlay the packaged PCF source

From this ZIP, copy:

```text
PCF/PresenceOrgChart/ControlManifest.Input.xml
PCF/PresenceOrgChart/index.ts
PCF/PresenceOrgChart/css/PresenceOrgChart.css
```

into the corresponding generated project locations.

Do not copy a `generated/ManifestTypes.d.ts` from another machine/project. The PCF build process generates the manifest types from your current manifest.

## 18. PCF behavior implemented in index.ts

The packaged PCF is dependency-free beyond the standard PCF scaffold. It does not require D3 or another chart library.

It implements:

### Data reading

For every dataset record it reads:

```text
EmployeeKey
EmployeeName
ManagerKey
ManagerName
WorkType
WorkLocation
PresenceStatus
PresenceText
```

### Tree construction

It builds a map keyed by `EmployeeKey`.

For each employee:

- If their manager exists in the map, the employee is appended to the manager's children.
- If the manager does not exist in the tracked department, the employee becomes a local root.
- If multiple local roots exist, the PCF creates a synthetic `Department` root.
- Self-reference and cyclic manager paths are prevented from breaking rendering.

### Layout

The PCF recursively places leaf nodes horizontally and centers manager nodes over their visible child branches.

This produces a top-down full tree with no hard-coded management-depth limit.

### Interaction

The component supports:

- drag-to-pan
- mouse-wheel/trackpad zoom
- zoom buttons
- fit-all
- branch collapse/expand
- expand-all
- collapse-all
- search by display name or email
- automatic ancestor expansion when a search match is inside a collapsed branch
- centering on a search match
- click/keyboard node selection

### Selection outputs

The manifest exposes:

```text
SelectedEmployeeKey
SelectedEmployeeName
SelectedPresenceText
```

The code calls `notifyOutputChanged()` when a person is selected so Power Apps can respond through the component's `OnChange` property.

## 19. Build the PCF

From the PCF project folder:

```powershell
npm run build
```

For iterative local development/testing:

```powershell
npm start watch
```

The PCF test harness can help validate rendering before deployment, but your final integration must also be tested inside the actual canvas app because the canvas dataset host behavior is the real target.

For production, build with production mode:

```powershell
npm run build -- --buildMode production
```

Do not deploy a development build as the final production component.

## 20. Fix common build errors

### Manifest types are missing

If TypeScript reports it cannot find:

```text
./generated/ManifestTypes
```

run the normal PCF build from the project root. Do not manually author the generated types.

### Component fields are not recognized

Confirm `ControlManifest.Input.xml` is the packaged version and rebuild.

### CSS does not load

Confirm:

```text
css/PresenceOrgChart.css
```

exists relative to the control folder and that the manifest resource path matches.

---

# PART D — PACKAGE THE PCF INTO A POWER PLATFORM SOLUTION

## 21. Create a solution project

From an appropriate parent/project folder:

```powershell
mkdir Solutions
cd Solutions
```

Initialize:

```powershell
pac solution init --publisher-name YourPublisher --publisher-prefix yourprefix
```

Choose a publisher name/prefix that complies with your environment's ALM conventions.

## 22. Add the PCF reference

Run:

```powershell
pac solution add-reference --path C:\repos\PresenceOrgChart
```

Use the path containing the PCF project file generated by `pac pcf init`.

## 23. Build the solution ZIP

If you have .NET SDK 6 or newer:

```powershell
dotnet build
```

For a release/production build:

```powershell
dotnet build -c Release
```

Microsoft documentation also supports MSBuild-based solution builds. The generated solution ZIP is placed under the solution project's `bin` output path.

## 24. Import the solution

In Power Apps:

1. Select the target environment.
2. Open **Solutions**.
3. Select **Import solution**.
4. Browse to the generated ZIP.
5. Import.
6. Publish customizations if required by your process.

For production ALM, prefer a managed solution in downstream environments according to your organization's standards.

---

# PART E — ADD THE PCF TO THE CANVAS APP

## 25. Import the code component into the app

After the PCF solution is imported into the environment:

1. Open the canvas app in Power Apps Studio.
2. Select **Add (+)**.
3. Select **Get more components**.
4. Open the **Code** tab.
5. Select `PresenceOrgChart`.
6. Select **Import**.
7. Add the component to `scrPresenceOrgChart`.

Rename the inserted control:

```text
pcfOrgChart
```

## 26. Size the component

Recommended:

```powerfx
Width = Parent.Width
Height = Parent.Height
```

If it shares space with a selected-person pane, size the surrounding responsive containers rather than hard-coding pixel positions.

The PCF calls `trackContainerResize(true)` so it responds to the canvas host's allocated size.

## 27. Bind Items

Select `pcfOrgChart` and choose its **Items** property.

Paste the **expression only** from:

```text
PowerApps/02-PCF-Items.fx.txt
```

Do not write:

```text
pcfOrgChart.Items = ...
```

The formula bar is already editing the Items property.

## 28. Confirm required fields arrive

If the component displays no data, temporarily inspect the Items formula in a gallery or table control.

Verify it contains:

```text
EmployeeKey
EmployeeName
ManagerKey
ManagerName
WorkType
WorkLocation
PresenceStatus
PresenceText
```

Check spelling/capitalization exactly.

## 29. Wire node selection back to Power Apps

Set `pcfOrgChart.OnChange` to the contents of:

```text
PowerApps/06-PCF-OnChange.fx.txt
```

This creates:

```text
varSelectedEmployeeKey
varSelectedEmployeeName
varSelectedPresenceText
```

You can then display a native Power Apps details pane:

```powerfx
lblSelectedName.Text = varSelectedEmployeeName
lblSelectedPresence.Text = varSelectedPresenceText
```

Recommended pane visibility:

```powerfx
!IsBlank(varSelectedEmployeeKey)
```

## 30. Optional: retrieve the original weekly row for selected-person actions

If selecting a person should expose additional fields from the SharePoint record, use the delegable `LookUp` pattern in:

```text
PowerApps/07-Selected-Employee-Lookup.fx.txt
```

It filters by:

- the selected week's Monday date range
- `Employee Name.Email = varSelectedEmployeeKey`

Avoid applying `Lower()` to the SharePoint Person column inside that source query; string-manipulation functions on source columns can prevent delegation.

---

# PART F — HOW THE FINAL APP BEHAVES

## 31. Example

SharePoint contains a weekly row for each employee.

For Wednesday, Power Fx resolves:

```text
Robert   → In-Person / New York
Jane     → Remote
Michael  → In-Person / Boston
Susan    → Vacation
Amy      → In-Person / New York
```

Manager relationships resolve:

```text
Robert
├── Jane
│   └── Amy
├── Michael
└── Susan
```

The PCF renders:

```text
                       ROBERT
                In Person — New York
                          │
              ┌───────────┼───────────┐
              │           │           │
             JANE      MICHAEL      SUSAN
            Remote     Boston       Vacation
              │
             AMY
          New York
```

Changing the date changes presence overlays without changing the manager hierarchy unless the underlying weekly tracker's manager relationships differ.

## 32. Multiple top-level leaders

Suppose:

```text
VP A → manager outside tracker
VP B → manager outside tracker
```

Both appear as roots within the departmental dataset.

The PCF creates:

```text
Department
├── VP A
└── VP B
```

This prevents one valid subtree from disappearing.

## 33. Manager outside the department

If the departmental director reports to someone not included in the weekly tracker:

```text
Corporate VP       not in dataset
     │
Department Director
```

the Department Director becomes a local root. No external directory lookup is required.

## 34. Malformed hierarchy protection

The PCF detects relationships that would create a cycle, such as:

```text
A manages B
B manages A
```

or:

```text
A manages A
```

Those malformed edges are not allowed to recurse indefinitely. The affected person is promoted to a root so the chart remains renderable.

This is a safety behavior, not a substitute for fixing the source data.

---

# PART G — PERFORMANCE AND DELEGATION

## 35. The critical delegation boundary

Microsoft's canvas delegation behavior matters because the weekly tracker accumulates historical rows.

This implementation keeps the **SharePoint source filter** delegable:

```powerfx
'Date (Mon)' >= varWeekStart &&
'Date (Mon)' < DateAdd(varWeekStart, 1, TimeUnit.Days)
```

Then Power Fx locally shapes that weekly result with `AddColumns` and `ShowColumns`.

Microsoft documents that table-shaping functions can accept delegable arguments, while the output of the shaping function remains subject to the app's non-delegation record limit.

Therefore the correct sizing question is:

> How many employee rows exist for one selected week?

not:

> How many historical rows exist in the SharePoint tracker overall?

## 36. Recommended population boundaries

### Fewer than 500 weekly employee rows

Use this implementation as provided.

### 500–2,000 weekly employee rows

Possible, but:

- increase the app Data row limit only if needed
- test load/render time carefully
- confirm the PCF dataset receives all employees

### More than 2,000 weekly employee rows

Change the retrieval layer. Options include:

- Power Automate server-side query returning a normalized result
- Dataverse staging
- a custom API/Azure Function
- another server-side hierarchy dataset

Do not simply increase client logic beyond supported limits.

## 37. PCF rendering scale

The PCF itself is intended for small-to-medium departmental trees. It auto-fits and supports collapse/zoom, but extremely wide organizations can become visually dense even when technically renderable.

For very large trees, consider:

- default collapsing below a configured depth
- virtualized rendering
- search-first navigation
- department/subtree filters

Those are future enhancements, not required for the small-department scenario.

---

# PART H — TESTING

## 38. Run the packaged test plan

Use:

```text
Testing/Test-Plan.md
```

At minimum test:

- each weekday
- each Work Type
- each of several locations
- In-Person with missing location
- top-level leader whose manager is outside the tracker
- multiple root leaders
- individual contributor
- manager with many direct reports
- three or more hierarchy levels
- collapse/expand
- fit-all
- search
- employee selection output
- Monday ↔ Friday navigation
- blank/missing weekly data
- duplicate display names with unique emails

## 39. Validate employee count

For a representative week, compare:

```text
expected tracker employee rows
vs.
visible chart employee nodes
```

The numbers should match after accounting for deliberately excluded/malformed blank Employee Person rows.

This is the most important way to catch an accidental row-limit or data-quality issue.

## 40. Validate manager paths

Select 5–10 employees at different depths and confirm:

```text
Employee Name.Email
Manager Name.Email
```

produces the same manager relationship shown in the chart.

---

# PART I — DEPLOYMENT AND MAINTENANCE

## 41. Version the PCF

The manifest contains:

```xml
version="1.0.0"
```

Increment the version whenever you release a code change, for example:

```text
1.0.1
1.1.0
2.0.0
```

Power Apps Studio can require reopening the app before it recognizes an updated imported code component. Publish the updated solution/customizations first.

## 42. Production build

Before production deployment:

```powershell
npm run build -- --buildMode production
```

Then build the Power Platform solution in Release configuration according to your ALM process.

## 43. Security model

The PCF receives only the records Power Apps provides to it.

It does not:

- call SharePoint directly
- call Microsoft Graph
- store authentication tokens
- use browser local/session storage
- transmit data to a third party

Users still need the appropriate SharePoint/Power Apps access used by the canvas application.

Because code components execute custom code in Power Apps Studio, administrators should review/trust the source before importing it, consistent with Microsoft's security guidance for code components.

## 44. Recommended ownership

Assign ownership for:

- SharePoint tracker schema/business rules
- Canvas app formulas/UI
- PCF source code
- Power Platform solution/ALM
- environment feature settings

Keep the PCF source in source control such as GitHub or Azure DevOps rather than relying only on imported solution binaries.

---

# PART J — TROUBLESHOOTING QUICK REFERENCE

## 45. PCF does not appear under Code components

Check:

1. PCF for canvas apps environment feature is enabled.
2. Solution containing the PCF imported successfully.
3. You are editing the app in the same environment.
4. Use **Add → Get more components → Code**.

## 46. Component appears but shows “No presence records”

Check:

- `varSelectedDate`
- `varWeekStart`
- `Date (Mon)` values in SharePoint
- data-source name
- Items formula errors
- weekend date

Put the Items formula temporarily into a gallery to inspect the resulting rows.

## 47. Everyone appears as a root

Usually means `ManagerKey` does not match another employee's `EmployeeKey`.

Inspect:

```text
Employee Name.Email
Manager Name.Email
```

Look for:

- blank Manager values
- external managers not in the department
- Person fields pointing at unexpected accounts

External managers are expected for the top tracked leader; they should not be expected for every employee.

## 48. Some employees are missing

Check:

- blank `Employee Name`
- selected week filter
- row-limit boundary
- duplicate employee email in the same week

The PCF intentionally deduplicates duplicate `EmployeeKey` values and keeps the first record.

## 49. In-Person employee shows “Location Missing”

This is intentional when:

```text
Work Type = In-Person
Location = blank
```

Correct the weekly tracker entry.

## 50. Updated PCF code is not visible in Power Apps

Check:

- manifest version was incremented
- production solution was rebuilt/imported
- customizations were published if applicable
- close and reopen Power Apps Studio/app
- accept/update the available code-component version when prompted

## 51. Tree is too wide

Use:

- Fit all
- collapse branches
- search for a person
- larger web/tablet screen

If the department grows dramatically, revisit the layout strategy.

---

# PART K — ACCEPTANCE CRITERIA

The V1 is complete when all of these are true:

- [ ] SharePoint schema remains unchanged.
- [ ] User can choose any tracked Monday-Friday date.
- [ ] Chart displays every employee for the selected week within the supported weekly row limit.
- [ ] Every employee is connected to the correct manager when the manager is in the dataset.
- [ ] In-Person nodes display the selected office.
- [ ] Remote, Vacation, Sick, and Holiday display correctly.
- [ ] In-Person with blank location is visibly flagged.
- [ ] Full hierarchy is visible on one zoomable/pannable canvas.
- [ ] Branches can collapse and expand.
- [ ] Search finds and centers an employee.
- [ ] Selecting a node exposes its key/name/presence back to Power Apps.
- [ ] Previous/next navigation skips weekends.
- [ ] Multiple roots and external top managers do not break rendering.
- [ ] Test plan passes in the target environment.
- [ ] PCF is packaged in a solution and production build process is documented.

---

# PART L — OFFICIAL DOCUMENTATION USED

See `Reference/Official-Sources.md` for the current Microsoft documentation used to validate this implementation.
