# Production Deployment Checklist

## Source and build

- [ ] PCF source is stored in source control.
- [ ] `ControlManifest.Input.xml` version has been incremented for the release.
- [ ] `npm run build` passes.
- [ ] `npm run build -- --buildMode production` passes.
- [ ] No development build is being shipped as the final component.
- [ ] Solution Release build succeeds.

## Environment

- [ ] Target environment is correct.
- [ ] Power Apps component framework for canvas apps is enabled.
- [ ] Importer has appropriate solution permissions.
- [ ] SharePoint connection/data source works in the target environment.

## Solution

- [ ] Correct publisher and prefix are used.
- [ ] PCF project reference is included in the solution project.
- [ ] Solution package imports without errors.
- [ ] Managed/unmanaged choice matches organizational ALM policy.
- [ ] Customizations are published as required.

## Canvas app

- [ ] `PresenceOrgChart` is imported under Code components.
- [ ] PCF control is named `pcfOrgChart` or formulas are updated accordingly.
- [ ] `Items` formula references the correct SharePoint data-source name.
- [ ] Date picker and weekday buttons are wired.
- [ ] PCF `OnChange` is wired.
- [ ] Selected-person pane formulas use the correct control/variable names.
- [ ] App has been saved.
- [ ] App has been published.
- [ ] App sharing/security is correct.

## Data and delegation

- [ ] `Date (Mon)` is indexed if required for list scale.
- [ ] A representative selected week returns all expected employees.
- [ ] Weekly employee population is under the configured shaping/output limit.
- [ ] No unexpected source-side string transformation breaks the SharePoint date/person filter.

## Functional test

- [ ] Test plan is complete.
- [ ] All five Work Types have been validated.
- [ ] At least three hierarchy levels have been validated.
- [ ] Search/fit/zoom/pan/collapse work.
- [ ] Node selection outputs work.
- [ ] Monday-Friday navigation works across week boundaries.

## Release record

Record:

- Release version:
- PCF manifest version:
- Solution version:
- Canvas app version:
- Deployment date:
- Environment:
- Deployed by:
- Test evidence location:
- Rollback package/version:
