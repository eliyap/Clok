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
            .default(Text("Day")) {
                withAnimation { model.mode = .dayMode }
            },
            .default(Text("Week")) {
                withAnimation { model.mode = .weekMode }
            },
            .default(Text("List")) {
                withAnimation { model.mode = .listMode }
            },
            .cancel()
        ])
    }
}
