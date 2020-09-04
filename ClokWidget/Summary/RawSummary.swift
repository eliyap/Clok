//
//  RawSummary.swift
//  ClokWidgetExtension
//
//  Created by Secret Asian Man Dev on 3/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

/**
 Mirrors the shape of the Summary JSON blob
 */
struct RawSummary: Decodable {
    
    let data: [Project]
    let total_grand: Int /// total number of milliseconds
    
    struct Project: Decodable {
        let id: Int?
        let items: [Entry]
        let time: Int /// number of milliseconds for this project
        let title: RawSummary.Project.Title
        
        struct Title: Decodable {
            let hex_color: String?
            let project: String?
        }
    }
    
    struct Entry: Decodable {
        let time: Int /// number of milliseconds for this entry
        let title: RawSummary.Entry.Title
        
        struct Title: Decodable {
            let time_entry: String
        }
    }
}
