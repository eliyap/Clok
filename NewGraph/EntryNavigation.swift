//
//  EntryNavigation.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 29/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

/// wrapper to allow observable
final class _TimeEntry: ObservableObject {
    @Published var entry: TimeEntry? = nil
}

struct EntryNavigation: View {
    
    @ObservedObject var ChosenEntry: _TimeEntry = _TimeEntry()
    
    var body: some View {
        NavigationView {
            NewGraph()
        }
            .environmentObject(ChosenEntry)
            .onChange(of: ChosenEntry.entry) { entry in
                print(entry?.description)
            }
    }
}
