# Revision Notes — v2

This revision clarifies the implementation sequence into two strict passes.

## Changed

- Rewrote `11-IMPLEMENTATION-SEQUENCE.md` as the authoritative build sequence.
- Added hard acceptance gates inside Pass 1.
- Added an explicit Pass 1 final acceptance gate before any Pass 2 work.
- Added explicit "Do NOT build during Pass 1" scope boundaries.
- Added Pass 2 entry requirements and regression rules.
- Clarified that Pass 2 should preserve the validated hierarchy/layout contracts.
- Updated `00-START-HERE.md` to point implementers to the authoritative sequence.

No SharePoint schema change, PCF, or architectural dependency was introduced.
