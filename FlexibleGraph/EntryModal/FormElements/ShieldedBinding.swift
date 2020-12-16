//
//  ShieldedBinding.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 16/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI


/// A wrapping view that allows some internal `View` to decide
/// when it wants to reflect changes on a `Binding`to be reflected outwards.
/// Primarily used to prevent my homebrew `UndoTracker` from being flooded with trivial changes
/// by `TextField` and `DatePicker`
struct ShieldedBinding<T, V>: View where T: Equatable, V: View {
    /// some exterior binding
    @Binding var exterior: T
    
    /// internal state that tracks the exterior binding
    @State var interior: T
    
    /// content that requires a binding, and promises to alert us when changes are made
    var content: (Binding<T>, _ onCommit: @escaping () -> ()) -> V
    
    init(
        _ exterior: Binding<T>,
        @ViewBuilder content: @escaping (Binding<T>, _ onCommit: @escaping () -> ()) -> V
    ) {
        self._exterior = exterior
        /// copy initial value
        self._interior = State<T>(initialValue: exterior.wrappedValue)
        self.content = content
    }
    
    var body: some View {
        content($interior, onCommit)
            /// if the exterior value changes, reflect those changes internally (potentially losing interior `State` changes)
            .onChange(of: exterior) { interior = $0 }
    }
    
    /// only reflect changes outwards when the internal view decides to do so.
    func onCommit() -> Void {
        exterior = interior
    }
}
