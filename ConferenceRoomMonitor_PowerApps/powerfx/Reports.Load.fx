Set(
    gblReportDays,
    Switch(
        radReportRange.Selected.Value,
        "7 days", 7,
        "30 days", 30,
        "90 days", 90,
        30
    )
);

Set(gblReportStart, DateAdd(Today(), -(gblReportDays - 1), TimeUnit.Days));
Set(gblReportEnd, Today());

Concurrent(
    Refresh(CRM_EstateDailyMetrics),
    Refresh(CRM_RoomRollingMetrics)
);

ClearCollect(
    colEstateTrend,
    Filter(
        CRM_EstateDailyMetrics,
        MetricDate >= gblReportStart &&
        MetricDate <= gblReportEnd
    )
);

ClearCollect(
    colRoomRolling,
    CRM_RoomRollingMetrics
);

ClearCollect(
    colUtilizationByRoom,
    AddColumns(
        colRoomRolling As RM,
        RoomName,
            Coalesce(
                LookUp(
                    colRooms As R,
                    Lower(R.RoomEmail) = Lower(RM.RoomEmail),
                    R.Title
                ),
                RM.RoomEmail
            ),
        Utilization,
            Switch(
                gblReportDays,
                7, RM.Utilization7d,
                30, RM.Utilization30d,
                90, RM.Utilization90d,
                RM.Utilization30d
            ),
        BookedHours,
            Switch(
                gblReportDays,
                7, RM.BookedHours7d,
                30, RM.BookedHours30d,
                90, RM.BookedHours90d,
                RM.BookedHours30d
            ),
        MeetingCount,
            Switch(
                gblReportDays,
                7, RM.MeetingCount7d,
                30, RM.MeetingCount30d,
                90, RM.MeetingCount90d,
                RM.MeetingCount30d
            )
    )
);
