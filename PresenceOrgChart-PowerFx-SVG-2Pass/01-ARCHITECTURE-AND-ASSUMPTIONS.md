# Architecture and Assumptions

## Target architecture

```text
Existing SharePoint Weekly Org Tracker
              |
              | Filter to selected week
              v
      Selected-day projection
         colPresenceValid
              |
              | local Power Fx
              v
       Hierarchy collections
 Level0 -> Level1 -> ... -> Level6
              |
              v
         colOrgNodes
              |
      leaf/path layout
              v
          colLayout
              |
       Concat SVG markup
              v
       varOrgChartSvg
              |
           EncodeUrl
              v
      Native Image control
```

## Stable hierarchy keys

Use Person-field email, not display name:

```powerfx
Lower(wk.'Employee Name'.Email)
Lower(wk.'Manager Name'.Email)
```

Display names are for labels only.

## Presence rule

Work Type is authoritative:

```text
In-Person + office -> In Person — <office>
In-Person + blank  -> Location Missing
Remote             -> Remote
Vacation           -> Vacation
Sick               -> Sick
Holiday            -> Holiday
```

Never infer Remote from a blank Location.

## Hierarchy depth

Starter supports Level 0 through Level 6. If the real department is deeper, extend the repeated level-building pattern before production.

Unplaced employees are counted and surfaced.

## Multiple roots

A root is a person whose ManagerKey is blank or whose manager is not represented in the selected-day department. Multiple roots are allowed; their branches render on the same SVG.

## Data retrieval strategy

1. Calculate the Monday of the selected week.
2. Filter SharePoint on `Date (Mon) = varWeekStart`.
3. Project only the selected weekday's Work Type / Location fields.
4. Materialize the small selected-day result locally.
5. Perform all hierarchy/layout work against local collections.

Recommended SharePoint administration: index `Date (Mon)` because it is the weekly retrieval key.

## Intended scale

Designed for a small department, typically tens to a few hundred selected-day employees. It is not intended to render thousands of simultaneous nodes.

## Security

The app uses the user's SharePoint connection/security context. Do not embed sensitive attributes in the SVG unless users are already authorized to view them.

## Native SVG limitation

The SVG is displayed as one Canvas Image control; individual SVG nodes do not become native Power Apps controls. Pass 2 therefore uses Combo Box search, highlighting, details, and viewBox-based navigation rather than per-node OnSelect events.
