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
    
    /// define a slightly faster animation
    static let animation = Animation.easeInOut(duration: 0.2)
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if model.field != .none {
                Color.black
                    .opacity(0.5)
                    .onTapGesture(perform: dismiss)
            }
            Editor
                /// allow background to consume max width
                .frame(maxWidth: .infinity)
                .background(Color.background)
                .transition(.inAndOut(edge: .bottom))
        }
        
    }
    
    var Editor: some View {
        Group {
            switch model.field {
            case .start:
                DatePicker("Start Time", selection: $internalModel.start, in: ...model.end)
                    .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())
            case .end:
                DatePicker("End Time", selection: $internalModel.end, in: model.start...)
                    .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())
            default:
                EmptyView()
            }
        }
    }
    
    func dismiss() -> Void {
        withAnimation(Self.animation) {
            model.field = .none
        }
        /// reflect changes outwards
        model.update(with: internalModel)
    }
}
