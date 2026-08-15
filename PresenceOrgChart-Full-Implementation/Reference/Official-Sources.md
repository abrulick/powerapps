# Official Documentation References

Checked August 15, 2026.

## Power Apps component framework for canvas apps

Microsoft Learn — Code components for canvas apps  
https://learn.microsoft.com/en-us/power-apps/developer/component-framework/component-framework-for-canvas-apps

Key use in this implementation: enabling PCF per environment and adding code components through **Add → Get more components → Code**.

## PCF command-line tooling

Microsoft Learn — `pac pcf` command group  
https://learn.microsoft.com/en-us/power-platform/developer/cli/reference/pcf

Key use: `pac pcf init`, dataset template, `--run-npm-install`, and `pac pcf push` reference behavior.

## Packaging code components

Microsoft Learn — Package a code component  
https://learn.microsoft.com/en-us/power-apps/developer/component-framework/import-custom-controls

Key use: `pac solution init`, `pac solution add-reference`, solution build, and import flow.

## Dataset component for canvas apps

Microsoft Learn — DataSet Grid component for canvas apps  
https://learn.microsoft.com/en-us/power-apps/developer/component-framework/sample-controls/data-set-component-canvas

Microsoft Learn — DataSet API reference  
https://learn.microsoft.com/en-us/power-apps/developer/component-framework/reference/dataset

Key use: primary dataset/Items behavior, `records`, `sortedRecordIds`, and container sizing.

## PCF paging

Microsoft Learn — Paging API reference  
https://learn.microsoft.com/en-us/power-apps/developer/component-framework/reference/paging

Key use: dataset page-size behavior and canvas support.

## PCF best practices

Microsoft Learn — Best practices for code components  
https://learn.microsoft.com/en-us/power-apps/developer/component-framework/code-components-best-practices

Key use: production builds, API availability, resizing, minimizing output notifications, and avoiding unsupported host DOM interaction/storage.

## SharePoint connection and delegation

Microsoft Learn — Connect to SharePoint from a canvas app  
https://learn.microsoft.com/en-us/power-apps/maker/canvas-apps/connections/connection-sharepoint-online

Key use: SharePoint data mapping; DateTime `Filter`/comparison delegation; Person `Email` and `DisplayName` delegation notes.

Microsoft Learn — Understand delegation in a canvas app  
https://learn.microsoft.com/en-us/power-apps/maker/canvas-apps/delegation-overview

Key use: 500 default / 2,000 configurable nondelegation limit and design guidance.

Microsoft Learn — AddColumns, DropColumns, RenameColumns, ShowColumns  
https://learn.microsoft.com/en-us/power-platform/power-fx/reference/function-table-shaping

Key use: delegable arguments to table-shaping functions and nondelegation limit on shaped output.

Microsoft Learn — Collect, Clear, and ClearCollect  
https://learn.microsoft.com/en-us/power-platform/power-fx/reference/function-clear-collect-clearcollect

Key use: avoiding `ClearCollect` as the production retrieval mechanism for an accumulating historical SharePoint list.
