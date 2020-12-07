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
                withAnimation { model.mode = .dayMode }
            },
            .default(Text("List".tickedIf(model.mode == .listMode))) {
                withAnimation { model.mode = .listMode }
            },
            .default(Text("Extended".tickedIf(model.mode == .extendedMode))) {
                withAnimation { model.mode = .extendedMode }
            },
            .cancel()
        ])
    }
}

fileprivate extension String {
    /// a slightly weak visual attempt to center text with an added tick mark
    func tickedIf(_ condition: Bool) -> String {
        condition ? "    \(self) ✓ " : self
    }
}
