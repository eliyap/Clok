import Foundation

struct WeekTimeFrame: Equatable {
    var start = Date()
    var end = Date()
    var firstDay:Int
    let dayNames:[String] = DateFormatter().weekdaySymbols
    
    // returns the day index of a given Date, from 0 (Sunday) through 6 (Monday)
    func dayOf(_ day:Date) -> Int {
        Calendar.current.component(.weekday, from: day) - 1
    }
    
    // recursively finds the start of the week
    // by stepping back until it finds the right day of the week
    func weekStart(trying day:Date, contains:Date) -> Date {
        if firstDay == dayOf(day) && day < contains {
            return day
        }
        else {
            return weekStart(
                trying: day.addingTimeInterval(-24 * 60 * 60),
                contains: contains
            )
        }
    }
    
    // recursively finds the end of the week
    // by stepping forwards until it finds the right day of the week
    func weekEnd(trying day:Date, contains:Date) -> Date {
        if firstDay == dayOf(day) && day > contains {
            return day
        }
        else {
            return weekEnd(
                trying: day.addingTimeInterval(+24 * 60 * 60),
                contains: contains
            )
        }
    }
    
    // provide a start day from 0 (Sunday) through 6 (Monday)
    // and a date that you want this week range to contain
    init(starts:Int, contains:Date) {
        // ensures date range is set by midnight
        let dayStart = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: contains)!
        firstDay = starts
        start = weekStart(trying: dayStart, contains: contains)
        end = weekEnd(trying: dayStart, contains: contains)
    }
    
    init(starts:Date, ends:Date, first:Int) {
        start = starts
        end = ends
        firstDay = first
    }
    
    func addingTimeInterval(_ interval:TimeInterval) -> WeekTimeFrame {
        WeekTimeFrame (
            starts: start + interval,
            ends: end + interval,
            first: firstDay
        )
    }
    
    // get the prior week
    init(preceding:WeekTimeFrame) {
        firstDay = preceding.firstDay
        start = preceding.start.addingTimeInterval(-weekLength)
        end = preceding.end.addingTimeInterval(-weekLength)
    }
    
    // get the next week
    init(succeeding:WeekTimeFrame) {
        firstDay = succeeding.firstDay
        start = succeeding.start.addingTimeInterval(+weekLength)
        end = succeeding.end.addingTimeInterval(+weekLength)
    }
    
    // returns the week covering the past 7 days (including today)
    init() {
        firstDay = -1
        start = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
                .addingTimeInterval(-6 * dayLength)
        end = start.addingTimeInterval(weekLength)
    }
    
    static func == (lhs: WeekTimeFrame, rhs: WeekTimeFrame) -> Bool {
        return
            lhs.start == rhs.start &&
            lhs.end == rhs.end &&
            lhs.firstDay == rhs.firstDay
    }
    
    
    // filters Time Entries down to only those which fall
    // at least partially within the week
    func within(_ entries:[TimeEntry]) -> [TimeEntry] {
        entries.filter {
            // either the start or end date must fall within the date range
            self.start < $0.start && $0.start < self.end
            || self.start < $0.end && $0.end < self.end
        }
    }
}
