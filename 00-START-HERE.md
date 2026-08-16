# Presence-Aware Org Chart — Reviewed & Optimized

This package supersedes the earlier **Unified** and **2-Pass** archives.

The implementation remains:

**SharePoint → Power Fx hierarchy/layout → SVG → native Canvas Image control**

No PCF, Dataverse, custom connector, or SharePoint restructuring is required.

## Use these files in order

1. `01-REVIEW-FINDINGS.md`
2. `02-CONTROL-CREATION.md`
3. `03-IMPLEMENTATION-SEQUENCE.md`
4. `PowerFx/` — paste formulas property by property
5. `04-TEST-PLAN.md`
6. `05-TROUBLESHOOTING.md`
7. `06-DEPLOYMENT-CHECKLIST.md`

The complete formula set is also available as:

`PowerFx/ALL-IN-ONE-REFERENCE.txt`

## Runtime architecture

There are two hidden helper actions:

- `btnBuildChart` — SharePoint retrieval, normalization, validation, hierarchy, layout.
- `btnRenderSvg` — selection/location styling, viewport calculations, SVG generation.

This is **one implementation**, not two project passes. The split prevents search, location filtering, and zoom from unnecessarily re-reading SharePoint or rebuilding the hierarchy.

## Important configuration

In `scrOrgChart.OnVisible`, set:

`varLocalRowSafetyLimit`

to the same value configured under **Settings → General → Data row limit** in your Canvas App. The default shown in the code is `500`.

The selected week's employee rows must remain below that limit for this local-cache architecture to be trusted as complete.
