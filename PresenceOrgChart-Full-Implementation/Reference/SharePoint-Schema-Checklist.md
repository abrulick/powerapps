# SharePoint Schema Verification Checklist

This checklist verifies the existing tracker without changing its structure.

## Required columns

- [ ] `Employee Name` is a Person column.
- [ ] `Manager Name` is a Person column.
- [ ] `Work Type (Mon)` is a Choice column.
- [ ] `Work Type (Tue)` is a Choice column.
- [ ] `Work Type (Wed)` is a Choice column.
- [ ] `Work Type (Thu)` is a Choice column.
- [ ] `Work Type (Fri)` is a Choice column.
- [ ] `Date (Mon)` exists.
- [ ] `Date (Tue)` exists.
- [ ] `Date (Wed)` exists.
- [ ] `Date (Thu)` exists.
- [ ] `Date (Fri)` exists.
- [ ] `Location (Mon)` is a Choice column.
- [ ] `Location (Tue)` is a Choice column.
- [ ] `Location (Wed)` is a Choice column.
- [ ] `Location (Thu)` is a Choice column.
- [ ] `Location (Fri)` is a Choice column.

## Work Type choice values

Confirm exact spelling/case used by the app:

- [ ] `In-Person`
- [ ] `Remote`
- [ ] `Vacation`
- [ ] `Sick`
- [ ] `Holiday`

## Weekly-row behavior

- [ ] One employee has one tracker row per week.
- [ ] `Date (Mon)` identifies the week.
- [ ] Dates on Tue-Fri correspond to the same week.
- [ ] Employee Person records include a usable `.Email` value.
- [ ] Manager Person records include a usable `.Email` value for employees with a tracked manager.
- [ ] The top departmental leader may legitimately have a manager outside the tracker.

## In-person validation

For each weekday:

- [ ] When Work Type is `In-Person`, Location is normally populated.
- [ ] When Work Type is not `In-Person`, Location is ignored by the chart.

The PCF intentionally displays `Location Missing` when an employee is In-Person with a blank location.

## Recommended list optimization

- [ ] Consider indexing `Date (Mon)` if the historical list is large.

This is an index, not a schema redesign.
