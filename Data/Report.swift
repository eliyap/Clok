//
//  Report.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 12/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import CoreData

fileprivate struct RawReport: Decodable {
    var total_count: Int
    var per_page: Int
    var total_grand: Double
    var data: [RawTimeEntry]
}

struct Report: Decodable {
    
    /// total number of time entries in the report
    var totalCount: Int
    
    /// number of time entries provided per request
    var perPage: Int
    
    /// total seconds tracked
    var totalGrand: Double
    
    /// list of TimeEntry's
    var entries: [RawTimeEntry]
    
    static let empty = Report(
        total_count: NSNotFound,
        per_page: NSNotFound,
        total_grand: .zero,
        data: []
    )
    
    private init(total_count: Int, per_page: Int, total_grand: TimeInterval, data: [RawTimeEntry]){
        self.totalGrand = total_grand
        self.totalCount = total_count
        self.perPage = per_page
        self.entries = data
    }
    
    init(from decoder: Decoder) throws {
        let rawReport = try RawReport(from: decoder)
        totalGrand = rawReport.total_grand
        totalCount = rawReport.total_count
        perPage = rawReport.per_page
        entries = rawReport.data
    }
}
