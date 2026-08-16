// Estate utilization %
Round(
    100 * Sum(colEstateTrend, BookedMinutes) /
    Max(1, Sum(colEstateTrend, AvailableMinutes)),
    1
)

// Booked room-hours
Round(Sum(colEstateTrend, BookedMinutes) / 60, 1)

// Meetings
Sum(colEstateTrend, MeetingCount)

// Average feedback rating
Round(
    Sum(colEstateTrend, RatingSum) /
    Max(1, Sum(colEstateTrend, FeedbackCount)),
    2
)

// Feedback responses
Sum(colEstateTrend, FeedbackCount)

// Issues
Sum(colEstateTrend, IssueCount)

// High/Critical issues
Sum(colEstateTrend, HighCriticalIssueCount)

// Inferred no-shows
Sum(colEstateTrend, InferredNoShows)
