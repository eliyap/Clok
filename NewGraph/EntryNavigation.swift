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
    @State var hasEntry: Bool = false
    
    var body: some View {
        NavigationView {
            VStack { /// swift is cursed. this makes the nav link work. don't know why
                NewGraph()
                NavigationLink(destination: Text(ChosenEntry.entry?.wrappedDescription ?? "Oops"), isActive: $hasEntry) {
                    EmptyView()
                }
            }
            
        }
            .environmentObject(ChosenEntry)
            .onChange(of: ChosenEntry.entry) { entry in
                self.hasEntry = entry != nil
                print(hasEntry)
            }
    }
}
