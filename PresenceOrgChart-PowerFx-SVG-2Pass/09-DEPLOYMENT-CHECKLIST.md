# Deployment Checklist

## Before build

- [ ] SharePoint connection works
- [ ] no PCF dependency
- [ ] target form factor agreed
- [ ] column types confirmed
- [ ] exact Work Type strings confirmed
- [ ] Location choices confirmed
- [ ] Date (Mon) indexing reviewed
- [ ] max hierarchy depth confirmed
- [ ] expected department headcount confirmed

## Pass 1 gate

- [ ] selected-day projection correct
- [ ] hierarchy levels correct
- [ ] unplaced = 0 for valid data
- [ ] manager centering correct
- [ ] SVG renders
- [ ] date switching correct
- [ ] presence/locations correct
- [ ] real data tested

## Pass 2 gate

- [ ] employee search
- [ ] selection highlight/detail
- [ ] location highlight
- [ ] presence counters
- [ ] weekday navigation
- [ ] zoom in/out
- [ ] Fit All
- [ ] Center Selection
- [ ] data-quality gallery
- [ ] empty/weekend/error/loading states
- [ ] responsive layout

## Security/governance

- [ ] SharePoint permissions reviewed
- [ ] no sensitive attributes unnecessarily embedded in SVG
- [ ] no external HTTP calls
- [ ] no custom connectors
- [ ] no PCF
- [ ] no unintended premium dependency

## Performance

Record with real data:

- [ ] employee count
- [ ] hierarchy depth
- [ ] leaf count
- [ ] SVG length
- [ ] build responsiveness
- [ ] date-switch responsiveness

## UAT and production

- [ ] manager validates hierarchy
- [ ] tracker owner validates statuses
- [ ] office filters validated
- [ ] target devices tested
- [ ] UAT sign-off
- [ ] save/publish
- [ ] app shared with intended users/groups
- [ ] SharePoint permissions verified
- [ ] production smoke test
- [ ] app/support owner documented
- [ ] max supported hierarchy depth documented
- [ ] rollback/version recorded
