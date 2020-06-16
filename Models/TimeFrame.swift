import Foundation

struct SearchTerm {
    /// nil indicates "without project" or "no description"
    var project:String?
    var description:String
    
    /// if you *do not wish* to search by project or description, toggle to false
    var byProject = true
    var byDescription = true
}

/**
 represents a period of time
 */
struct TimeFrame {
    var start:Date
    var end:Date
    func containsStartOf(_ entry:TimeEntry) -> Bool {
        entry.start.between(self.start, self.end)
    }
    func containsEndOf(_ entry:TimeEntry) -> Bool {
        entry.end.between(self.start, self.end)
    }
    func contains(_ entry:TimeEntry) -> Bool {
        entry.end.between(self.start, self.end)
    }
}

struct WeekTimeFrame {
    var frame:TimeFrame
    var entries:[TimeEntry]
    let df = DateFormatter()
    
    /**
     we expect time entries to already be filtered down between some date range
     */
    init (zero:Date, entries entries_:[TimeEntry]) {
        frame = TimeFrame(start: zero, end: zero + weekLength)
        entries = entries_
        df.timeStyle = .short
    }
    
    func avgStartTime(_ terms:SearchTerm) -> String {
        df.dateStyle = .short
        /// a list of the time entries that were the first started of their day
        var firstStarts = [TimeEntry]()
        
        /// filter and sort by start in chronological order
        var e = entries.matching(terms)
        e.sort(by: {$0.start < $1.start})
        
        /// get the day time frames
        var days = daySlices(start: frame.start, end: frame.end)
        
        /// iterate over list, only adding the *first started* entry in a day frame that hasn't yet been filled
        e.forEach { entry in
            for idx in 0..<days.count {
                if days[idx].frame.containsStartOf(entry) {
                    firstStarts.append(entry)
                    /// pop this day, so no other entries starting on this day can be added
                    days.remove(at: idx)
                    break
                }
            }
        }
        
        let avg = firstStarts
            .map{$0.start}
            .averageTime()
        return df.string(from: avg)
    }
}


/**
 period of time that must start or end at midnight
 can cover a 24 hour day, may cover only part
 */
struct DayFrame {
    var frame:TimeFrame
    init(start:Date, end:Date) {
        /// check whether start and end were on the same day
        let cal = Calendar.current
        if cal.startOfDay(for: start) != cal.startOfDay(for: end) {
            /// if not, check whether end is at midnight (which rolls it into the next day)
            if cal.startOfDay(for: end) != end {
                fatalError("Start & End on different days!")
            }
        }
        frame = TimeFrame(start: start, end: end)
    }
}

/**
 provided a start and end date, returns an array with all midnights between those dates
 (as well as the dates themselves)
 striding over adjacent dates in resulting array gives all "day intervals" between the 2 dates,
 with non-midnight inputs resulting in partial days at the start and end (this is intentional)
 
 For testing:
 - providing 2 midnight dates should not result in duplicate values
 - 7 days (not midnight) should return a partial day, 6 full days, and a partial day (9 dates)
 - 7 days (midnight) should return 7 full days (8 dates)
 */
func daySlices(start:Date, end:Date) -> [DayFrame] {
    guard start < end else { fatalError("Invalid date range!") }
    
    var frames = [DayFrame]()
    var slices = [Date]()
    let cal = Calendar.current
    
    for d in stride(from: cal.startOfDay(for: start), through: cal.startOfDay(for: end), by: dayLength) {
        slices.append(d)
    }
    slices.remove(at: 0)
    slices.insert(start, at: 0)
    if slices.last != end { slices.append(end) }
    
    for idx in 0..<(slices.count - 1) {
        frames.append(DayFrame(start: slices[idx], end:slices[idx + 1]))
    }
    
    return frames
}
