//
//  SaveChangesButton.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 19/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct SaveChangesButton: View {
    let save: () -> Void
    var canUndo: Bool
    var body: some View {
        Button(action: save) {
            Image(systemName: "checkmark")
        }
            /// only allow saving if there are changes (i.e. something to undo)
             .disabled(!canUndo)
    }
}
