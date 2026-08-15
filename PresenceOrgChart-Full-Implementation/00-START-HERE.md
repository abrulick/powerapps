# Presence-Aware Full-Tree Org Chart — Start Here

This package implements a **full-tree, presence-aware organization chart in a Microsoft Power Apps canvas app** using your existing weekly SharePoint list exactly as structured.

## Your existing SharePoint schema

The implementation assumes these columns already exist:

- `Employee Name` — SharePoint Person column
- `Manager Name` — SharePoint Person column
- `Work Type (Mon)` through `Work Type (Fri)` — SharePoint Choice columns
- `Date (Mon)` through `Date (Fri)` — SharePoint Date/DateTime columns
- `Location (Mon)` through `Location (Fri)` — SharePoint Choice columns

Work Type values:

- `In-Person`
- `Remote`
- `Vacation`
- `Sick`
- `Holiday`

When Work Type is `In-Person`, the matching Location column contains one of your office choices.

## What this package builds

The finished experience provides:

- Complete multi-level organization tree on one canvas
- Dynamic manager/direct-report relationships from SharePoint
- Selected weekday presence status
- Office name for in-person staff
- Remote, Vacation, Sick, and Holiday states
- Warning state for In-Person with no office selected
- Pan and zoom
- Fit-all
- Expand/collapse by branch
- Expand-all/collapse-all
- Employee search and centering
- Employee selection returned from the PCF to Power Apps
- Multiple-root handling when a tracked department leader reports outside the tracker
- Protection against malformed self/cyclic manager relationships

## Recommended implementation order

1. Read `01-IMPLEMENTATION-GUIDE.md` completely once.
2. Verify the SharePoint assumptions in `Reference/SharePoint-Schema-Checklist.md`.
3. Add the SharePoint list to your canvas app.
4. Add the Power Fx formulas from `PowerApps/`.
5. Enable PCF for canvas apps in your environment.
6. Create a dataset PCF scaffold with Power Platform CLI.
7. Copy the files from `PCF/PresenceOrgChart/` over the generated source files.
8. Build and test the PCF.
9. Package the PCF in a Power Platform solution.
10. Import the solution and add the code component to your canvas app.
11. Bind its `Items` property to `PowerApps/02-PCF-Items.fx.txt`.
12. Execute the test plan in `Testing/Test-Plan.md`.
13. Complete `Deployment/Production-Checklist.md` before publishing.

## Important scalability assumption

This design is intentionally optimized for the stated use case: **a small department**.

The Power Fx `Filter` that selects the week is delegable to SharePoint. The subsequent `AddColumns`/`ShowColumns` operations shape only that weekly result, but their output is subject to the canvas app non-delegation record limit. Therefore:

- **Under 500 employee rows per week:** default settings are appropriate.
- **500–2,000 employee rows per week:** test carefully and consider raising the app Data row limit to 2,000.
- **Over 2,000 employee rows per week:** do not use this exact client-side shaping pattern; use a server-side staging/API/Power Automate approach instead.

For the small department described in this project, this is a good fit.

## Package layout

```text
PresenceOrgChart-Full-Implementation/
├── 00-START-HERE.md
├── 01-IMPLEMENTATION-GUIDE.md
├── PowerApps/
│   ├── 01-App-OnStart.fx.txt
│   ├── 02-PCF-Items.fx.txt
│   ├── 03-DatePicker-OnChange.fx.txt
│   ├── 04-Previous-Day-OnSelect.fx.txt
│   ├── 05-Next-Day-OnSelect.fx.txt
│   ├── 06-PCF-OnChange.fx.txt
│   ├── 07-Selected-Employee-Lookup.fx.txt
│   └── 08-Control-Properties.txt
├── PCF/
│   └── PresenceOrgChart/
│       ├── ControlManifest.Input.xml
│       ├── index.ts
│       └── css/PresenceOrgChart.css
├── Scripts/
├── Testing/
├── Deployment/
└── Reference/
```

## Version

Package version: **1.0.0**  
Implementation guide checked against current Microsoft documentation on **August 15, 2026**.
