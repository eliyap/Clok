//
//  ControlBar.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 11/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct ControlBar: View {
    
    let discard: () -> Void
    let save: () -> Void
    var dismissalCompletion: CGFloat
    @ObservedObject var model: EntryModel
    @State var canUndo = false
    
    var body: some View {
        HStack {
            DiscardButton(discard: discard, completion: dismissalCompletion)
            SaveChangesButton(save: save, canUndo: canUndo)
            Spacer()
            /// other stuff here
            UndoTracker(model: model, canUndo: $canUndo)
        }
            .buttonStyle(PlainButtonStyle())
            .padding(EntryFullScreenModal.sharedPadding)
            /// a nice transluscent system color
            .background(Color(UIColor.secondarySystemFill))
    }
}
