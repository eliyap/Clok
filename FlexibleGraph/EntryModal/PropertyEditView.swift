//
//  PropertyEditView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 14/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct PropertyEditView: View {
    
    @ObservedObject var model: EntryModel
    
    /// define a slightly faster animation
    static let animation = Animation.easeInOut(duration: 0.2)
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if model.field != .none {
                Color.primary
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
                DatePicker("Start Time", selection: $model.start, in: ...model.end)
                    .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())
            case .end:
                DatePicker("End Time", selection: $model.end, in: model.start...)
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
    }
}
