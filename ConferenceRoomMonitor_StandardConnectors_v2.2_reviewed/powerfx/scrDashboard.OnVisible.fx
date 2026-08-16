If(
    gblNeedsStatusRefresh ||
    IsBlank(gblLastStatusRefresh) ||
    DateDiff(
        gblLastStatusRefresh,
        Now(),
        TimeUnit.Seconds
    ) >= gblStatusRefreshSeconds,
    Select(btnRefreshStatus)
);
