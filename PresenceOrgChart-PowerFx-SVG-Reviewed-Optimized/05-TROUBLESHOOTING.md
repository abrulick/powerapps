# Troubleshooting

## Formula doesn't paste

Use the individual files in `PowerFx/` rather than the all-in-one reference.

This package uses current Power Fx identifier syntax. If SharePoint columns were renamed, Power Apps may expose a different identifier. Follow Studio IntelliSense.

## `ShowColumns` flags a column

Verify the exact Power Apps field identifier for that SharePoint column.

The optimized weekly projection intentionally lists only fields used by the application.

## `.Value` fails on Work Type or Location

The formulas assume single-select SharePoint Choice columns.

If Studio exposes a different shape, follow IntelliSense for your column type.

## Week is unexpectedly incomplete

Check:

`CountRows(colWeekRows)`

and:

`varLocalRowSafetyLimit`

`ClearCollect` is subject to the Canvas App local record limit. The delegable Filter narrows the remote query, but the copied output still must remain below the app's local limit.

If one selected week could exceed the configured limit, this architecture needs a different retrieval layer rather than simply trusting the partial collection.

## SharePoint returns an error

Check `varChartError`.

The optimized build wraps the weekly read in `IfError` and preserves the connector error message.

Confirm:

- user has list permissions;
- data source connection is valid;
- column identifiers are correct.

## Chart is blank

Check in order:

1. `varChartError`
2. `CountRows(colPresenceUnique)`
3. `CountRows(colOrgNodes)`
4. `CountRows(colLayout)`
5. `Len(varOrgChartSvg)`

If `colLayout` is empty, don't debug the Image control first.

## Employee appears as unexpected root

Their ManagerKey wasn't found as an EmployeeKey in the selected week.

Possible valid case:
- department head's manager is outside the tracker.

Possible bad data:
- manager row missing;
- wrong manager Person value.

Multiple roots are now explicitly reported in `colDataIssues`.

## Manager is not centered

Inspect:

- manager PathKey
- descendant leaf PathKeys
- leaf LeafX values
- manager NodeX

NodeX must equal the Average LeafX of all descendant leaves.

## Location dropdown is missing a configured office

The optimized package uses:

`Choices('Weekly Org Tracker'.'Location (Mon)')`

as the canonical list.

Confirm all weekday Location Choice fields are configured with the same office choices. If Monday isn't your canonical field, change the Choices reference.

## Location dropdown has an office with zero employees

That is intentional.

The dropdown represents configured offices, not only occupied offices.

## Refresh doesn't update

Confirm `btnRefreshData.OnSelect` contains `Refresh('Weekly Org Tracker')`.

Use Live monitor to verify the connector call.

## Duplicate employee

The chart temporarily selects the lowest SharePoint `ID` row for the employee and reports an error.

Correct the duplicate in SharePoint. The fallback is not intended as a permanent business rule.

## Long employee names

The SVG truncates visible names to 28 characters.

If needed:
- increase `varNodeWidth`;
- reduce font size;
- implement `<tspan>` wrapping later.

## Too wide

A full tree can become very wide.

Use:
- Fit All;
- employee search + Center Selection;
- landscape desktop/tablet form factor.

If necessary, reduce `varNodeWidth` and `varXGap` together, then rerun overlap tests with your real data.

## Modern-control property mismatch

The package recommends classic Date Picker / Combo Box / Drop down for formula compatibility.

If you use modern controls, map the formula to the equivalent current property exposed by Studio.
