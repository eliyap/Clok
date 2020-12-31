//
//  PredictTab.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 31/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct PredictTab: View {
    var body: some View {
        VStack {
            Text(WidgetManager.running.entryDescription)
            List {
                Section(header: Text("Often Next:")) {
                    
                }
            }
                .listStyle(InsetGroupedListStyle())
        }
    }
}

