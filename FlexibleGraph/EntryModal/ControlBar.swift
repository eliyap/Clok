//
//  ControlBar.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 11/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct ControlBar: View {
    
    let dismiss: () -> Void
    var dismissalCompletion: CGFloat
    @ObservedObject var model: EntryModel
    
    var body: some View {
        HStack {
            DismissalButton(dismiss: dismiss, completion: dismissalCompletion)
            Spacer()
            /// other stuff here
            UndoTracker(model: model)
        }
            .buttonStyle(PlainButtonStyle())
            .padding(EntryFullScreenModal.sharedPadding)
            .background(
                /// a nice transluscent system color
                Color(UIColor.secondarySystemFill)
                    /// allows it to cover color when user scrolls down
                    .edgesIgnoringSafeArea(.top)
            )
    }
}

import Combine
struct UndoTracker: View {
    
    @ObservedObject var model: EntryModel
    
    /// past states, in chronological order (oldest at index 0)
    @State var changelog = [EntryModel]()
    @State var current: Int = .zero
    
    @State var undoTracker = Set<AnyCancellable>()
    
    /// represents whether the undo / redo system is in the process of changing anything (during which `undoTracker`) should be dormant
    @State var isAmending = false
    
    var body: some View {
        Group {
            Button(action: undo) {
                Image(systemName: "arrow.uturn.left")
            }
                /// cannot redo if current entry is the earliest entry
                .disabled(changelog.isEmpty || current == changelog.indices.first)
            Button(action: redo) {
                Image(systemName: "arrow.uturn.right")
            }
                /// cannot redo if current entry is the latest entry
                .disabled(changelog.isEmpty || current == changelog.indices.last)
        }
        .onAppear(perform: monitor)
    }
    
    func undo() -> Void {
        /// lock `undoTracker` out during function scope
        isAmending = true
        defer { isAmending = false }
        
        /// ensure there is at least one recent model
        guard changelog.count > 0, current > 0 else { return }
        let recent = changelog[changelog.count - 2]
        
        /// allow user to `redo` to current state
        current -= 1
        
        /// ignored: `id`, `field`
        model.start = recent.start
        model.end = recent.end
        model.billable = recent.billable
        model.project = recent.project
    }
    
    func redo() -> Void {
        /// lock `undoTracker` out during function scope
        isAmending = true
        defer { isAmending = false }
        
        /// ensure there is at least one recent model
        guard changelog.count >= current else { return }
        let imminent = changelog[current]
        
        /// allow user to `undo` to current state
        current += 1
        
        /// ignored: `id`, `field`
        model.start = imminent.start
        model.end = imminent.end
        model.billable = imminent.billable
        model.project = imminent.project
    }
    
    func monitor() {
        model.objectWillChange.sink { _ in
            /// if we're in the process of changing something, just ignore what's going on.
            guard !isAmending else { return }
            
            /// empty out all entries after the current one
            changelog.removeSubrange(current..<changelog.count)
            
            /// update current position
            current = changelog.count
            
            #if DEBUG
            print("CHANGE DETECTED \(model.start.MMMdd)")
            #endif
            /// store any changes, (will also store initial value when `.last` returns `nil`)
            if changelog.last != model {
                /// NOTE: recall that classes are reference types, hence a copy must be made!
                changelog.append(model.copy() as! EntryModel)
            }
        }.store(in: &undoTracker)
    }
}
