# Validation Notes

## Completed in this package build

- PCF `index.ts` was syntax/type checked with TypeScript 5.8.3 against a minimal mock of the PCF interfaces used by the source.
- `ControlManifest.Input.xml` is included for the current source contract.
- Power Fx formulas were reviewed for the stated SharePoint column types and Monday-Friday business rules.
- The production data path was revised to avoid `ClearCollect` over the accumulating historical SharePoint list.
- The SharePoint week selection uses DateTime comparisons supported for delegation.
- The PCF hierarchy uses Person-email-based keys rather than display names.

## Not executable in the artifact-generation environment

Microsoft Power Platform CLI (`pac`) is not installed in the environment that created this ZIP. Therefore this package does **not** claim that a real PAC-generated `.pcfproj` or Power Platform solution ZIP was compiled here.

Follow the documented steps on a Power Platform developer workstation:

1. `pac pcf init ...`
2. apply the packaged source overlay
3. `npm run build`
4. create a solution with `pac solution init`
5. add the PCF reference
6. build the solution
7. import into the target environment

This approach intentionally avoids shipping fabricated/generated project files tied to an unknown local CLI/toolchain version.
