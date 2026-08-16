If(
    IsBlank(gblPowerBIUrl) ||
    gblPowerBIUrl = "REPLACE_ME",
    Notify(
        "The Power BI report URL has not been configured.",
        NotificationType.Warning,
        3000
    ),
    Launch(gblPowerBIUrl)
)
