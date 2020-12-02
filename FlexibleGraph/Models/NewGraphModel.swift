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
        case weekMode
        case dayMode
        case listMode
    }
    
    /// registers the selection of `TimeEntry`s
    @Published var selected: NamespaceModel = NamespaceModel(entry: .none, row: 0, col: .zero)
    
    /// registers what mode the view is in
    @Published var mode: GraphMode = .weekMode
}
