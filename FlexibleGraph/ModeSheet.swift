//
//  ModeSheet.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 2/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

extension FlexibleGraph {
    var ModeSheet: ActionSheet {
        ActionSheet(title: Text("Graph Mode"), buttons: [
            .default(Text("Day".tickedIf(model.mode == .dayMode))) {
                setMode(to: .dayMode)
            },
            .default(Text("List".tickedIf(model.mode == .listMode))) {
                setMode(to: .listMode)
            },
            .default(Text("Extended".tickedIf(model.mode == .extendedMode))) {
                setMode(to: .extendedMode)
            },
            .cancel()
        ])
    }
    
    func setMode(to newMode: NewGraphModel.GraphMode) -> Void {
        /// on switching away from `.dayMode`, determine its position first
        if model.mode == .dayMode && newMode != .dayMode {
            positionRequester.send(true)
        }
        withAnimation { model.mode = newMode }
    }
}

fileprivate extension String {
    /// a slightly weak visual attempt to center text with an added tick mark
    func tickedIf(_ condition: Bool) -> String {
        condition ? "    \(self) ✓ " : self
    }
}
