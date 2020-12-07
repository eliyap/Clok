//
//  GraphModel.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 30/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
final class NewGraphModel: ObservableObject {
    
    enum GraphMode: Int {
        case dayMode
        case listMode
    }
    
    /// registers the selected `TimeEntry`
    @Published var selected: TimeEntry? = nil

    /// tracks which `TimeEntry` shape is being tracked
    @Published var geometry: NamespaceModel? = nil
    
    /// registers what mode the view is in
    @Published var mode: GraphMode = .dayMode
}
