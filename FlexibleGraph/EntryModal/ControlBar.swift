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
    
    @Environment(\.undoManager) private var undoManager
    
    var body: some View {
        HStack {
            DismissalButton(dismiss: dismiss, completion: dismissalCompletion)
            Spacer()
            /// other stuff here
            Button{
                undoManager?.undo()
            } label: {
                Image(systemName: "arrow.uturn.left")
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
