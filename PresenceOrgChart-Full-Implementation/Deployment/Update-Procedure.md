# Updating the PCF After V1

1. Modify the PCF source in source control.
2. Increment the `version` value in `ControlManifest.Input.xml`.
3. Run a local development build/test.
4. Run the production PCF build:

```powershell
npm run build -- --buildMode production
```

5. Rebuild the Power Platform solution in Release configuration.
6. Import/update the solution in the target environment.
7. Publish customizations if required.
8. Close and reopen Power Apps Studio for the canvas app.
9. Accept/update the available component version if prompted.
10. Regression-test the chart.
11. Publish the canvas app.

Keep the previous working solution package available for rollback according to your ALM process.
