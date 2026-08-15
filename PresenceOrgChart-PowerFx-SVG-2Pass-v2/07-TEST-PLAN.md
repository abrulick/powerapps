# Test Plan

Test in layers: SharePoint week filter → `colPresenceValid` → hierarchy levels → `colOrgNodes` → `colLeaves` → `colLayout` → SVG.

## Required test scenarios

1. **Simple 3-level tree** — one director, two managers, several staff.
2. **Uneven depth** — one branch has an extra supervisor level.
3. **Multiple roots** — peer leaders whose common manager is outside the tracker.
4. **All presence types** — In-Person, Remote, Vacation, Sick, Holiday, and missing in-person Location.
5. **Duplicate display names** — same name, different emails.
6. **Missing manager** — manager not represented in selected-week rows.
7. **Self-manager** — EmployeeKey equals ManagerKey.
8. **Depth > 6** — validate unplaced warning.
9. **Weekend** — explicit unsupported-day message.
10. **Empty week** — graceful empty state.

## Pass 1 acceptance matrix

| Area | Test | Expected |
|---|---|---|
| Source | Week filter | only selected week |
| Source | Person | email/display name correct |
| Source | Choice | `.Value` correct |
| Presence | In-Person | office shown |
| Presence | Remote | no stale office |
| Presence | Leave types | correct text |
| Data quality | Missing office | warning status |
| Hierarchy | Root | correct local root(s) |
| Hierarchy | Parent-child | matches tracker |
| Hierarchy | Uneven depth | valid tree |
| Layout | Leaf order | deterministic |
| Layout | Manager center | average descendant leaves |
| Render | Connectors | correct parent-child paths |
| Render | SVG | Image control renders |
| Completeness | Unplaced | zero for valid data |

## Pass 2 acceptance matrix

- [ ] employee search finds employee
- [ ] selected employee highlighted
- [ ] detail panel correct
- [ ] office highlight dims rather than removes other nodes
- [ ] previous/next skips weekends
- [ ] presence counters match source
- [ ] zoom in/out works
- [ ] Fit All works
- [ ] Center Selection works
- [ ] data issues visible
- [ ] empty/loading/error states visible
- [ ] target screen sizes usable

## UAT questions

1. Who reports to Manager X?
2. Where is Employee Y today?
3. Which members of Manager X's branch are at Office Z?
4. How many people are remote?
5. Who is on vacation/sick?
6. Is anyone In-Person without a location?
7. Can a named employee be found quickly?
8. Is the hierarchy understandable without training?
9. Can users switch dates easily?
10. Is the chart readable on intended devices?
