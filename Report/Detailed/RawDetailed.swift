//
//  RawDetailed.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 26/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
/**
 Mirrors the shape of the Detailed Report JSON blob
 */
struct RawDetailed: Decodable {
    
    let data: [RawTimeEntry]
    
    /// total number of milliseconds
    let total_grand: Int
    
    /// total number of entries in the requested date range
    let total_count: Int
    
    /// number of entries returned in a single request
    /// typically 50
    let per_page: Int
    
    /// currencies represented for billing
    //let total_currencies: NSNull /// I don't care
}
