# Implementation Sequence — One Linear Build

Follow this sequence exactly.

## Step 1 — Connect SharePoint and create controls

Complete `02-CONTROL-CREATION.md`.

Do not paste formulas until all named controls exist.

## Step 2 — Match the local row safety value

Open:

**Settings → General → Data row limit**

Note the value.

In:

`PowerFx/01_scrOrgChart_OnVisible.fx.txt`

set:

`varLocalRowSafetyLimit`

to the same number.

For a small department, the default 500 is normally ample; the selected week's employee rows must remain below the configured value.

## Step 3 — Paste screen initialization

Paste:

`PowerFx/01_scrOrgChart_OnVisible.fx.txt`

into:

`scrOrgChart.OnVisible`

## Step 4 — Paste date formulas

Use:

`PowerFx/02_dpPresenceDate.fx.txt`

for:

- `dpPresenceDate.DefaultDate`
- `dpPresenceDate.OnChange`

## Step 5 — Paste the build engine

Paste:

`PowerFx/03_btnBuildChart_OnSelect.fx.txt`

into:

`btnBuildChart.OnSelect`

This is the main engine:

SharePoint → selected day → validation → hierarchy → layout.

Do not split this formula across additional controls during initial implementation.

## Step 6 — Paste the SVG renderer

Paste:

`PowerFx/04_btnRenderSvg_OnSelect.fx.txt`

into:

`btnRenderSvg.OnSelect`

This formula uses the already-built `colLayout`. It does not re-query SharePoint.

## Step 7 — Configure the Image

Use:

`PowerFx/05_imgOrgChart.fx.txt`

Set all three documented Image properties.

### First validation point

Run the app now.

Before configuring search/zoom, confirm:

- `CountRows(colPresenceUnique)` is correct;
- `CountRows(colOrgNodes)` matches usable employee count;
- `CountRows(colUnplaced) = 0` for valid data;
- the SVG renders.

If the SVG does not render, stop here and use `05-TROUBLESHOOTING.md`.

## Step 8 — Add employee search

Use:

`PowerFx/06_cmbEmployee.fx.txt`

Then use:

`PowerFx/07_SelectedEmployeeDetails.fx.txt`

for the native detail panel.

## Step 9 — Add office highlighting

Use:

`PowerFx/08_ddLocationFilter.fx.txt`

The dropdown uses the configured SharePoint Location choices, not only locations occupied that day.

## Step 10 — Add weekday navigation

Use:

`PowerFx/09_WeekdayNavigation.fx.txt`

The buttons skip Saturday/Sunday.

## Step 11 — Add zoom and centering

Use:

`PowerFx/10_ZoomAndCenter.fx.txt`

Zoom modifies the SVG viewBox only; it does not change hierarchy coordinates.

## Step 12 — Add presence counters

Use:

`PowerFx/11_PresenceCounters.fx.txt`

## Step 13 — Add message/error state

Use:

`PowerFx/12_ChartMessage.fx.txt`

## Step 14 — Add data-quality display

Use:

`PowerFx/13_DataIssues.fx.txt`

## Step 15 — Add Refresh

Use:

`PowerFx/14_RefreshData.fx.txt`

This gives users an explicit way to retrieve changes other employees made to SharePoint.

## Step 16 — Optional maker diagnostics

Use:

`PowerFx/15_OptionalDiagnostics.fx.txt`

while implementing. Hide/remove the diagnostic label for production if you don't need it.

## Step 17 — Run App Checker

In Power Apps Studio, run **App checker** and resolve:

- formula errors;
- delegation warnings you didn't intentionally accept;
- accessibility issues.

The weekly local-copy warning is intentional only when your selected week remains below the configured row limit.

## Step 18 — Run the test plan

Use `04-TEST-PLAN.md`.

## Step 19 — Use Live Monitor

Run the app with **Live monitor** while:

- first opening the screen;
- changing weeks;
- pressing Refresh;
- selecting a person;
- changing office;
- zooming.

Search/office/zoom should not create SharePoint retrieval calls; date changes and Refresh should.

## Step 20 — Deploy

Use `06-DEPLOYMENT-CHECKLIST.md`.
