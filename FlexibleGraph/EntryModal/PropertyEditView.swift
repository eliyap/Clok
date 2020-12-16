//
//  PropertyEditView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 14/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct PropertyEditView: View {
    
    @ObservedObject private var model: EntryModel
    @StateObject private var internalModel: EntryModel
    
    init(model: EntryModel) {
        self._model = ObservedObject<EntryModel>(initialValue: model)
        /// assign itself a copy of the object
        self._internalModel = StateObject<EntryModel>(wrappedValue: model.copy() as! EntryModel)
    }
    
    
    /// Dismiss itself as a modal view,
    /// and alert the external `ObservedObject` of the changes
    func dismiss() -> Void {
        withAnimation(Self.animation) {
            model.field = .none
        }
        /// reflect changes outwards
        model.update(with: internalModel)
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                if model.field != .none {
                    Color.black
                        .opacity(0.5)
                        .onTapGesture(perform: dismiss)
                }
                PropertyEditor(
                    model: internalModel,
                    field: model.field,
                    dismiss: dismiss,
                    boundingWidth: geo.size.width
                )
                    /// allow background to consume max width
                    .frame(maxWidth: .infinity)
                    .background(Color.background)
                    .transition(.inAndOut(edge: .bottom))
            }
        }
    }
}

// MARK:- Animation Settings
extension PropertyEditView {
    /// define a slightly faster animation
    static let animation = Animation.easeInOut(duration: 0.2)
}
