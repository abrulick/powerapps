# Deployment Checklist

## Before publish

- [ ] SharePoint connection uses the production list.
- [ ] `varLocalRowSafetyLimit` matches Canvas App Settings → General → Data row limit.
- [ ] weekly employee count is comfortably below that value.
- [ ] `Date (Mon)` is indexed if the historical list is large.
- [ ] all five Location Choice fields use the intended 30-office choice set.
- [ ] hierarchy depth is no more than Level 7.
- [ ] `CountRows(colUnplaced) = 0` for valid production weeks.
- [ ] duplicate weekly employee rows have been corrected.
- [ ] App checker has no unresolved formula errors.
- [ ] accessibility issues reviewed.
- [ ] Live monitor test completed.

## UAT

Have these people validate the app:

- department head or delegate;
- at least two managers;
- tracker/list owner;
- employees who routinely work at different office locations.

Validate:

- reporting structure;
- presence status;
- office location;
- date navigation;
- search;
- office highlighting;
- Refresh;
- zoom and centering;
- data-quality warnings.

## Governance/security

- [ ] no PCF/code component
- [ ] no custom connector
- [ ] no external HTTP service
- [ ] users have appropriate SharePoint permissions
- [ ] SVG contains only information users are authorized to view

## Publish

- [ ] save a known-good version before production publish
- [ ] publish
- [ ] share app with intended group
- [ ] production smoke test
- [ ] document app owner
- [ ] document SharePoint list owner
- [ ] document support contact
- [ ] document eight-level hierarchy limit
- [ ] document local-row-limit requirement

## Post-release

Review during the first weeks:

- data issue count
- unexpected multiple roots
- duplicate rows
- missing locations
- weekly row growth
- user-reported chart readability
- Live monitor/performance findings
