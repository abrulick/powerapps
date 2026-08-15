# Presence Org Chart V1 Test Plan

Record pass/fail and evidence for each test before production deployment.

## A. Data retrieval

- [ ] Select a known Monday and confirm all expected tracker employees appear.
- [ ] Select Tuesday-Friday of the same week and confirm employee count remains correct.
- [ ] Select a different week and confirm the chart updates to that week's records.
- [ ] Select a Saturday; app rejects it and retains/resets to a weekday.
- [ ] Select a Sunday; app rejects it and retains/resets to a weekday.
- [ ] Confirm the app does not show historical employees from unrelated weeks.

## B. Work Type rendering

Create/identify at least one example of each state:

- [ ] `In-Person` with valid location displays `In Person — <Location>`.
- [ ] `Remote` displays `Remote`.
- [ ] `Vacation` displays `Vacation`.
- [ ] `Sick` displays `Sick`.
- [ ] `Holiday` displays `Holiday`.
- [ ] `In-Person` with blank location displays `Location Missing`.

## C. Hierarchy

- [ ] Department top leader appears at the top when their manager is outside the tracker.
- [ ] Direct reports appear below the correct manager.
- [ ] At least three management levels render correctly.
- [ ] Individual contributors show `Individual contributor`.
- [ ] Managers show the correct direct-report count.
- [ ] Two employees with the same display name but different emails remain distinct.
- [ ] Multiple local roots produce a synthetic `Department` root.

## D. Malformed data safety

Use a test environment/test data where practical.

- [ ] Self-manager relationship does not crash the chart.
- [ ] A two-person manager cycle does not crash the chart.
- [ ] Blank Employee Name row is ignored rather than crashing the chart.
- [ ] Duplicate EmployeeKey in the same weekly dataset does not duplicate the node.

## E. Interaction

- [ ] Dragging pans the tree.
- [ ] Mouse wheel/trackpad zooms.
- [ ] Zoom + button works.
- [ ] Zoom − button works.
- [ ] Fit all shows the complete visible tree.
- [ ] Collapse branch hides descendants.
- [ ] Expand branch restores descendants.
- [ ] Collapse all works.
- [ ] Expand all works.
- [ ] Search by partial employee name finds a node.
- [ ] Search by email finds a node.
- [ ] Search expands hidden ancestors when the match is inside a collapsed branch.
- [ ] Search centers the match.
- [ ] Keyboard Enter/Space selects a focused employee node.

## F. Power Apps output integration

- [ ] Clicking a node sets `varSelectedEmployeeKey`.
- [ ] Clicking a node sets `varSelectedEmployeeName`.
- [ ] Clicking a node sets `varSelectedPresenceText`.
- [ ] Optional selected-person pane becomes visible.
- [ ] Changing the selected date clears stale selected-person output.
- [ ] Optional SharePoint `LookUp` retrieves the original weekly row for the selected employee.

## G. Date navigation

- [ ] Previous from Tuesday goes to Monday.
- [ ] Previous from Monday goes to previous Friday.
- [ ] Next from Thursday goes to Friday.
- [ ] Next from Friday goes to next Monday.
- [ ] Date picker reflects navigation after reset.

## H. Responsive behavior

Test in the actual supported clients.

- [ ] Desktop browser at normal width.
- [ ] Narrow browser window.
- [ ] Tablet/Power Apps player if applicable.
- [ ] Phone client if phone access is in scope; confirm pan/zoom remains usable.

## I. Performance

- [ ] Chart loads acceptably for a normal week.
- [ ] Search is responsive.
- [ ] Expand/collapse is responsive.
- [ ] No browser-console errors during normal interaction.
- [ ] Power Apps Studio shows no unexpected delegation warning on the inner weekly `Filter`.
- [ ] Expected weekly employee count is below the app's configured non-delegation row limit.

## J. Acceptance count check

For at least three representative weeks record:

| Week | Expected SharePoint employee rows | Visible chart employee nodes | Pass |
|---|---:|---:|---|
| Week 1 | | | |
| Week 2 | | | |
| Week 3 | | | |

A mismatch must be investigated before release.
