# Review Validation Notes

## Static formula checks performed

The optimized combined Power Fx file was scanned for balanced:

- parentheses `()`
- brackets `[]`
- braces `{}`
- double-quoted string termination

Result: **PASS**

This is a structural text validation; Power Apps Studio remains the authoritative parser for your tenant/schema/control versions.

## Current Power Fx assumptions verified

- `Distinct` currently returns a one-column table named `Value`.
- `Sequence` returns a `Value` column.
- `ForAll` returns calculated results in input-table order, while side-effect processing can occur in arbitrary order.
- SharePoint supports delegation for Filter and DateTime comparison operations.
- SharePoint Person fields support delegable `Email` and `DisplayName` subfields.
- `ShowColumns` can take a delegable Filter argument, but its output is subject to the nondelegation record limit.
- `ClearCollect` is nondelegable and local result size must be treated accordingly.
- `Refresh` retrieves a fresh data-source copy.
- Image values can use data URIs.
- `EncodeHTML` and `EncodeUrl` are appropriate for the dynamic SVG string.

## Geometry stress test

The average-descendant-leaf layout was simulated on:

- 100 random trees
- 200 nodes per tree
- maximum depth 7
- node width 220 px
- horizontal gap 44 px

Observed:

- minimum same-level center separation: **264 px**
- same-level overlaps detected: **0**

This confirms the layout's spacing invariant for properly ordered trees.

## Not validated outside Power Apps Studio

The following must still be validated in your actual app:

- exact SharePoint internal/display field identifiers;
- whether all Location weekday columns share the same Choice list;
- classic vs modern control property differences;
- tenant-specific connector permissions;
- real SVG rendering/performance at your department's actual size.
