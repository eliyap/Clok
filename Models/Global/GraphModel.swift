//
//  GraphModel.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 8/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

final class GraphModel: ObservableObject {
    
    init(){
        /// load mode from UserDefaults
        self.mode = GraphModel.Mode(rawValue: WorkspaceManager.graphMode)
            ?? .calendar
    }
    
    @Published var mode: Mode
    
    /// what form this view is adopting
    enum Mode: Int {
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
        case .calendar: return .day * 0.5
        case .graph: return .day * 0
        }
    }
    
    /// how far forwards to look
    var castFwrd: TimeInterval {
        switch mode {
        case .calendar: return .day * 1.5
        case .graph: return .day * 1
        }
    }
    
    var days: Double {
        (castBack + castFwrd) / .day
    }
}

