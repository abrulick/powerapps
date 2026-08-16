# Comprehensive Review Findings

## Overall assessment

The core **leaf-average hierarchy layout** is sound for the stated small-department use case. It was retained.

The surrounding implementation was optimized for correctness, governability, maintainability, and daily operational use.

## High-priority changes applied

### 1. SharePoint retrieval is now narrower and better documented

The weekly query now uses:

- a delegable `Filter` against `Date (Mon)`;
- DateTime range comparison;
- `ShowColumns` to keep only fields used by the chart;
- `IfError` so permission/network failures aren't misreported as an empty week.

The copied result is still subject to the Canvas App nondelegation row limit, so a runtime safety warning is included.

### 2. Row-limit truncation is now explicitly guarded

The package adds:

`varLocalRowSafetyLimit`

When the selected week returns a record count at or above that configured safety value, `colDataIssues` warns that the week might be truncated.

This is important because `ClearCollect` is nondelegable even when its input contains a delegable filter/table-shaping expression.

### 3. The office dropdown now represents the actual configured offices

Previously the dropdown was rebuilt only from offices where someone was present on the selected day.

It now uses:

`Choices('Weekly Org Tracker'.'Location (Mon)')`

as the canonical office list, plus `All Locations`.

This means all ~30 configured offices remain selectable even if occupancy is zero on a given day.

### 4. Explicit Refresh support added

A new `btnRefreshData` calls `Refresh('Weekly Org Tracker')` and rebuilds the chart.

This allows users to pick up changes made by other employees without closing/reopening the app.

### 5. Source and hierarchy failures are now distinguished

New/stronger handling covers:

- SharePoint read failure;
- empty week;
- no usable employee identities;
- no hierarchy root;
- empty layout;
- unplaced hierarchy nodes.

The UI should no longer rely on a blank SVG to communicate failure.

### 6. Data-quality checks expanded

The build now flags:

- missing employee identity;
- duplicate employee weekly rows;
- self-manager records;
- missing Work Type;
- unexpected Work Type;
- In-Person with missing Location;
- Location populated on a non-In-Person day;
- weekday Date mismatch;
- multiple local roots;
- hierarchy nodes unplaced in levels 0–7;
- potential local row-limit truncation.

### 7. ForAll side effects reduced

Where `ForAll` is used only to generate issue records, the optimized code returns a table of records and collects that table, rather than repeatedly calling `Collect` inside `ForAll`.

This removes unnecessary ordering/parallel-side-effect concerns.

### 8. UI-only interactions remain render-only

Employee search, office highlighting, zoom, Fit All, and Center Selection call only:

`btnRenderSvg`

They don't hit SharePoint and don't rebuild hierarchy coordinates.

### 9. Formula placement is now split into separate files

The earlier all-in-one formula was difficult to implement.

The `PowerFx` folder now contains one file per control/function group. Use those files for implementation.

## Core decisions retained

### Explicit hierarchy levels 0–7

Retained because recursive user-defined functions are not currently supported in Power Fx. Eight levels is a deliberate, visible constraint.

### Person email as hierarchy key

Retained. Display names are not unique enough for hierarchy joins.

### Average descendant leaf X-position

Retained. This is the strongest native-Power-Fx approximation of a conventional top-down org tree without JavaScript/PCF.

### SVG Image renderer

Retained. It provides the layout freedom native galleries don't provide for a full tree.

## Algorithm validation

The leaf-average algorithm was stress-tested outside Power Apps against 100 randomly generated 200-node trees with hierarchy depth up to 7.

With:

- node width = 220
- horizontal gap = 44

the minimum same-level center separation observed was 264 pixels, and no same-level node overlaps occurred in those tests.

This validates the geometry principle, not tenant-specific Power Fx syntax or SharePoint schema.

## Why helper buttons were retained

Current Power Fx supports behavior user-defined functions in `App.Formulas`.

However, this baseline keeps the helper-control method because:

- it is easy to map to a visible Power Apps property;
- it is broadly familiar in existing Canvas Apps;
- it avoids making the implementation depend on another authoring construct while you're already working inside a governed tenant.

A later refactor to behavior UDFs can remove the hidden helper controls without changing the data/layout algorithm.
