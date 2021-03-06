import Foundation

/**
 represents a period of time
 */
struct TimeFrame {
    var start:Date
    var end:Date
    func containsStartOf(_ entry: TimeEntry) -> Bool {
        entry.start.between(start, end)
    }
    func containsEndOf(_ entry: TimeEntry) -> Bool {
        entry.end.between(start, end)
    }
//    func contains(_ entry: TimeEntry) -> Bool {
//        entry.end.between(start, end)
//    }
}

struct WeekTimeFrame {
    var frame: TimeFrame
    var entries: [TimeEntry]
    let df = DateFormatter()
    
    /**
     filter time entries down to between date range
     */
    init (start start_: Date, entries entries_: [TimeEntry], terms: SearchTerms) {
        frame = TimeFrame(start: start_, end: start_ + .week)
        entries = entries_
            .matching(terms: terms)
            .within(interval: .week, of: start_)
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
        ].meanTime() + (.day / 2)
    }
    
    /**
     find the most sensible way to divide these time entries into "days"
     with each day spanning at most 24 hours, and starting / ending at some modified midnight
    */
    func modifiedDays(for entries: [TimeEntry]) -> [DayTimeFrame] {
        let modMN = modifiedMidnight(for: entries)
        /// find day time frames, using modified midnight
        return daySlices(
            start: frame.start.roundDown(to: modMN),
            end: frame.end
        )
    }
    
    /**
     a smart measure of what time each day you start an activity
     */
    func avgStartTime() -> Date? {
        guard entries.count > 0 else {
            return nil
        }
        
        var entries = self.entries
        
        /// filter and sort in chronological order by start
        entries.sort(by: {$0.start < $1.start})
        var days = modifiedDays(for: entries)
        
        /// list of the time entries that were the first started of their day
        var firstStarts = [TimeEntry]()
        
        /// iterate over list, adding the entry that *first started* that Day frame
        entries.forEach { entry in
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
    func avgEndTime() -> Date? {
        guard entries.count > 0 else {
            return nil
        }
        
        var entries = self.entries
        /// filter and sort in reverse chronological order by end
        entries.sort(by: {$0.end > $1.end})
        var days = modifiedDays(for: entries)
        
        /// list of the time entries that were the first ended of their day
        var lastEnds = [TimeEntry]()
        
        /// iterate over list backwards, adding the entry that *last ended* that Day frame
        entries.forEach { entry in
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
    
    /**
     find the average time each day spent on some activity
     NOTE: I could restrict this average to only days where you log at least 1 instance of the activity (e.g. average work only over weekdays)
     but I think people expect a 7 day average
     */
    func avgDuration() -> TimeInterval {
        // calculate total time interval / 7, taking care to cap at week boundaries
        return entries
            .map{min(frame.end, $0.end) - max(frame.start, $0.start)}
            .reduce(0, +) / 7
    }
}


/**
 period of time that covers a 24 hour period, or part thereof
 */
struct DayTimeFrame {
    var frame:TimeFrame
    init(start:Date, end:Date) {
        guard start < end else { fatalError("End Not After Start!")}
        guard end - start <= .day else { fatalError("spans more than a day!")}
        frame = TimeFrame(start: start, end: end)
    }
}

