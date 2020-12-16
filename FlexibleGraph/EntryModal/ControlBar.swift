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
    let undo: () -> Void
    let redo: () -> Void
    var dismissalCompletion: CGFloat
    @ObservedObject var model: EntryModel
    
    var body: some View {
        HStack {
            DismissalButton(dismiss: dismiss, completion: dismissalCompletion)
            Spacer()
            /// other stuff here
            Button(action: undo) {
                Image(systemName: "arrow.uturn.left")
            }
            Button(action: redo) {
                Image(systemName: "arrow.uturn.right")
            }
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
    @State var pastModels = [EntryModel]()
    
    /// states that were previously undone from, in reverse chronological order (newest at index 0)
    @State var futureModels = [EntryModel]()
    @State var undoTracker = Set<AnyCancellable>()
    
    /// represents whether the undo / redo system is in the process of changing anything (during which `undoTracker`) should be dormant
    @State var isAmending = false
    
    var body: some View {
        Group {
            Button(action: undo) {
                Image(systemName: "arrow.uturn.left")
            }
            Button(action: redo) {
                Image(systemName: "arrow.uturn.right")
            }
        }
    }
    
    func undo() -> Void {
        /// lock `undoTracker` out during function scope
        isAmending = true
        defer { isAmending = false }
        
        #if DEBUG
        print(pastModels.count, pastModels.last?.start.MMMdd)
        #endif
        /// ensure there is at least one recent model
        guard let recent = pastModels.popLast() else { return }
        
        /// allow user to `redo` to current state
        futureModels.append(model)
        
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
        guard let imminent = futureModels.popLast() else { return }
        
        /// allow user to `undo` to current state
        pastModels.append(model)
        
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
            
            #if DEBUG
            print("CHANGE DETECTED \(model.start.MMMdd)")
            #endif
            /// store any changes, as well as the initial value
            print((pastModels.last ?? EntryModel(from: StaticEntry.noEntry)).start, model.start)
            
            /// abuse short-circuit evaluation to perform a force unwrap
            /// https://docs.swift.org/swift-book/LanguageGuide/BasicOperators.html
            if pastModels.last == nil || pastModels.last! != model {
                /// NOTE: recall that classes are reference types, hence a copy must be made!
                pastModels.append(model.copy() as! EntryModel)
                #if DEBUG
                print("\(pastModels.count) undos left")
                #endif
            }
        }.store(in: &undoTracker)
    }
}
