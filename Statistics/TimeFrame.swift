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
    init (zero: Date, entries entries_: [TimeEntry]) {
        frame = TimeFrame(start: zero, end: zero + weekLength)
        entries = entries_
        df.timeStyle = .short
    }
    
    /**
     find the modified midnight: the average of all start and end times,
     +12hr to place it on the opposite side of the clock
     designed to be placed OPPOSITE most of the provided time entries, thus dividing them into sensible "days"
     */
    func modifiedMidnight(for entries: [TimeEntry]) -> Date {
        [
            entries.map{ $0.start }.meanTime(),
            entries.map{ $0.end   }.meanTime()
        ].meanTime() + (dayLength / 2)
    }
    
    /**
     find the most sensible way to divide these time entries into "days"
     with each day spanning at most 24 hours, and starting / ending at some modified midnight
    */
    func modifiedDays(for entries: [TimeEntry]) -> [DayTimeFrame] {
        let modMN = modifiedMidnight(for: entries)
        /// find day time frames, using modified midnight
        return daySlices(
            start: roundDown(frame.start, to: modMN),
            end: frame.end
        )
    }
    
    /**
     a smart measure of what time each day you start an activity
     */
    func avgStartTime(for terms: SearchTerm) -> Date {
        /// filter and sort in chronological order by start
        var e = entries.matching(terms)
        e.sort(by: {$0.start < $1.start})
        var days = modifiedDays(for: e)
        
        /// list of the time entries that were the first started of their day
        var firstStarts = [TimeEntry]()
        
        /// iterate over list, adding the entry that *first started* that Day frame
        e.forEach { entry in
            for idx in 0..<days.count {
                if days[idx].frame.containsStartOf(entry) {
                    firstStarts.append(entry)
                    days.remove(at: idx)
                    break
                }
            }
        }
        return firstStarts
            .map{$0.start}
            .meanTime()
    }
    
    /**
     a smart measure of what time each day you end an activity
     */
    func avgEndTime(for terms: SearchTerm) -> Date {
        /// filter and sort in reverse chronological order by end
        var e = entries.matching(terms)
        e.sort(by: {$0.end > $1.end})
        var days = modifiedDays(for: e)
        
        /// list of the time entries that were the first ended of their day
        var lastEnds = [TimeEntry]()
        
        /// iterate over list backwards, adding the entry that *last ended* that Day frame
        e.forEach { entry in
            for idx in stride(from: days.count - 1, through: 0, by: -1) {
                if days[idx].frame.containsEndOf(entry) {
                    lastEnds.append(entry)
                    days.remove(at: idx)
                    break
                }
            }
        }
        
        return lastEnds
            .map{$0.end}
            .meanTime()
    }
}


/**
 period of time that covers a 24 hour period, or part thereof
 */
struct DayTimeFrame {
    var frame:TimeFrame
    init(start:Date, end:Date) {
        guard start < end else { fatalError("End Not After Start!")}
        guard end - start <= dayLength else { fatalError("spans more than a day!")}
        frame = TimeFrame(start: start, end: end)
    }
}

