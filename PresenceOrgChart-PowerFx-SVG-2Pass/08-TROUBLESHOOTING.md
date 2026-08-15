# Troubleshooting

## SVG is blank

Check `CountRows(colLayout)`. If zero, debug upstream. Inspect `Left(varOrgChartSvg,1000)` in a temporary text label; it should begin with `<svg`. Confirm Image uses `"data:image/svg+xml;utf8," & EncodeUrl(varOrgChartSvg)`.

Use `EncodeHTML()` for employee/location text inserted into SVG.

## Only some employees appear

Compare:

```powerfx
CountRows(colPresenceValid)
CountRows(colOrgNodes)
varUnplacedEmployees
```

If unplaced > 0, inspect depth, manager cycles, self-manager records, manager data, and duplicates.

## Wrong reporting line

Inspect the employee's `EmployeeKey` and `ManagerKey` in `colPresenceValid`. The relationship comes from SharePoint Person fields; do not start by debugging the SVG.

## Manager not centered

For that manager, inspect descendant leaves where `StartsWith(leaf.PathKey,node.PathKey)`. Confirm NodeX equals the Average of their LeafX values.

## Sibling order appears random

Inspect `SortPath`. Do not rely on `ForAll` execution order. Leaf positions are assigned only after explicit `SortByColumns` and `Sequence`/`Index`.

## Unexpected root

Their manager is blank or not present in `colPresenceValid`. This may be valid if the manager is outside the department, or bad data if the manager should be tracked.

## Location Missing

This is deliberate when Work Type = In-Person and the selected-day Location Choice is blank.

## Delegation warning

Keep the SharePoint predicate simple:

```powerfx
Filter('Weekly Org Tracker','Date (Mon)' = varWeekStart)
```

Index `Date (Mon)`. Complex hierarchy calculations occur only after the selected-week result is local. If the department grows materially, revisit the retrieval design rather than only increasing local limits.

## Long names overflow

Increase node width, reduce font, truncate the rendered label, or use SVG `<tspan>` wrapping. Do this after hierarchy correctness.

## Chart too wide

Reduce node width/X gap or use Pass 2 viewBox zoom. Prefer landscape desktop/tablet.

## Blank Manager Email formula errors

Use the defensive pattern:

```powerfx
If(IsBlank(wk.'Manager Name'.Email),Blank(),Lower(wk.'Manager Name'.Email))
```

## Choice `.Value` errors

Confirm single-select SharePoint Choice. Follow Power Apps IntelliSense if your field is exposed differently.

## Formula separators

This package uses US-style commas. Some authoring locales require semicolons.
