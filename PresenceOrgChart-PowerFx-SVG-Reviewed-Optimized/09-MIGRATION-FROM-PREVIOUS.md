# What Changed from the Previous Unified Package

If you already started implementing the previous package:

1. Keep the same SharePoint list and overall Canvas screen.
2. Add:
   - `btnRefreshData`
   - `lblLastRefresh`
3. Replace `scrOrgChart.OnVisible` with the reviewed version.
4. Replace `btnBuildChart.OnSelect` completely.
5. Replace `btnRenderSvg.OnSelect` completely.
6. Keep the Image/search/date/zoom controls, but replace their formulas with the reviewed files.
7. Set `varLocalRowSafetyLimit` to your app's actual Data row limit.
8. Remove the old selected-day construction of `colLocationOptions`; the reviewed version loads all configured office choices in `OnVisible`.
9. Run the full test plan again.

Do not attempt to merge individual lines from the old `btnBuildChart` formula. Replace that property as a whole.
