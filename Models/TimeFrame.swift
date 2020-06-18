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
    
    /**
     a smart measure of what time each day you start an activity
     based on "modified midnight" metric
     */
    func avgStartTime(_ terms:SearchTerm) -> Date {
        df.dateStyle = .short
        df.timeStyle = .short
        
        /// filter and sort in chronological order by start
        var e = entries.matching(terms)
        e.sort(by: {$0.start < $1.start})
        
        /**
         modified midnight is the average of all start and end times,
         +12hr to place it on the opposite side of the clock
         */
        let modMN = [
            e.map{ $0.start }.meanTime(),
            e.map{ $0.end   }.meanTime()
        ].meanTime() + (dayLength / 2)
        
        print("Mod Midnight is \(df.string(from: modMN))")
        
        /// list of the time entries that were the first started of their day
        var firstStarts = [TimeEntry]()
        
        /// get the day time frames
        var modStart = frame.start
        modStart.roundDown(to: modMN)
        var days = daySlices(start: modStart, end: frame.end)
        
        /// iterate over list, only adding the *first started* entry in a day frame that hasn't yet been filled
        e.forEach { entry in
            for idx in 0..<days.count {
                if days[idx].frame.containsStartOf(entry) {
                    firstStarts.append(entry)
        
                    /// pop this day, so no other entries starting on this day can be added
                    days.remove(at: idx)
                    /// move on to next entry
                    break
                }
            }
        }
        
        let avg = firstStarts
            .map{$0.start}
            .meanTime()
        print("Avg is \(df.string(from: avg))")
        return avg
    }
}


/**
 period of time that covers a 24 hour period, or part thereof
 */
struct DayFrame {
    var frame:TimeFrame
    init(start:Date, end:Date) {
        guard start < end else { fatalError("End Not After Start!")}
        guard end - start <= dayLength else { fatalError("spans more than a day!")}
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
    
    for d in stride(from: start, through: end, by: dayLength) {
        slices.append(d)
    }
    
    for idx in 0..<(slices.count - 1) {
        frames.append(DayFrame(start: slices[idx], end:slices[idx + 1]))
    }
    
    return frames
}
