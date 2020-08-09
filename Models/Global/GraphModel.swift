//
//  GraphModel.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 8/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

final class GraphModel: ObservableObject {
    @Published var mode: Mode = .calendar
    
    /// what form this view is adopting
    enum Mode {
        case calendar
        case graph
        
        mutating func toggle() -> Void {
            switch self {
            case .calendar: self = .graph
            case .graph: self = .calendar
            }
        }
    }
    
    /// how far back to look
    var castBack: TimeInterval {
        switch mode {
        case .calendar: return dayLength * 0.5
        case .graph: return dayLength * 0
        }
    }
    
    /// how far forwards to look
    var castFwrd: TimeInterval {
        switch mode {
        case .calendar: return dayLength * 1.5
        case .graph: return dayLength * 1
        }
    }
    
    var days: Double {
        (castBack + castFwrd) / dayLength
    }
}

