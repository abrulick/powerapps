# Test Plan

## Mandatory source tests

- [ ] `CountRows(colWeekRows)` matches expected weekly employees.
- [ ] `CountRows(colWeekRows) < varLocalRowSafetyLimit`.
- [ ] `EmployeeKey` is the employee email.
- [ ] `ManagerKey` is the manager email.
- [ ] selected weekday Work Type matches SharePoint.
- [ ] selected weekday Location matches SharePoint.
- [ ] selected weekday Date equals `varSelectedDate`.

## Presence-state tests

Test at least one of each:

- [ ] In-Person with office
- [ ] Remote
- [ ] Vacation
- [ ] Sick
- [ ] Holiday
- [ ] In-Person with missing office

For Remote/Vacation/Sick/Holiday, a stale stored Location must not be shown as presence text.

## Hierarchy tests

- [ ] expected department root appears at Level 0.
- [ ] known manager/direct-report pairs are correct.
- [ ] same-name employees remain distinct by email.
- [ ] all valid employees appear exactly once.
- [ ] `CountRows(colUnplaced) = 0` for a valid week.
- [ ] multiple roots produce a warning.
- [ ] self-manager produces an error.
- [ ] hierarchy beyond Level 7 produces an unplaced-node error.

## Layout tests

Pick at least two managers.

For each:

1. identify descendant leaves by PathKey;
2. average their LeafX values;
3. confirm manager NodeX matches the average.

- [ ] no same-level node overlap in the real department.
- [ ] rebuilding the same date keeps the same leaf order.
- [ ] connectors reach correct parent and child nodes.

## Interaction tests

- [ ] employee search selects correct employee.
- [ ] selected employee border highlights.
- [ ] details panel matches selected employee.
- [ ] selecting an office dims nonmatching nodes but removes nobody.
- [ ] all ~30 configured offices remain available in the dropdown.
- [ ] Monday Previous goes to Friday.
- [ ] Friday Next goes to Monday.
- [ ] Zoom In works.
- [ ] Zoom Out stops at Fit-All scale.
- [ ] Fit All restores complete tree.
- [ ] Center Selection centers the selected employee.

## Refresh tests

1. Change one employee's tracker row in SharePoint.
2. Keep the app open.
3. Press Refresh.

- [ ] refreshed status appears.
- [ ] chart reflects the updated SharePoint row.
- [ ] refresh failure produces a readable error instead of an empty chart.

## Data-quality tests

`galDataIssues` should surface applicable examples of:

- [ ] missing employee identity
- [ ] duplicate employee row
- [ ] self manager
- [ ] missing Work Type
- [ ] unexpected Work Type
- [ ] missing In-Person location
- [ ] location on non-In-Person day
- [ ] date mismatch
- [ ] multiple local roots
- [ ] unplaced hierarchy node
- [ ] local row limit risk

## Empty/error tests

- [ ] weekend selected directly → weekday message
- [ ] empty week → no-records message
- [ ] no roots/cyclic-only hierarchy → root/hierarchy error
- [ ] blank SVG is never the only indication of failure

## Performance/Monitor tests

Using Live monitor:

- [ ] first chart load has expected SharePoint calls
- [ ] date change rebuilds data
- [ ] Refresh retrieves fresh source data
- [ ] employee selection does not reload SharePoint
- [ ] office filter does not reload SharePoint
- [ ] zoom does not reload SharePoint

Record for the real department:

- weekly rows
- unique employees
- hierarchy depth
- leaf count
- `varSvgLength`

## Final acceptance

Do not publish until all mandatory source, hierarchy, SVG, and error-state tests pass.
