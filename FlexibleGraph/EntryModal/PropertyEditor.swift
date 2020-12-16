//
//  PropertyEditor.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 16/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct PropertyEditor: View {
    
    @ObservedObject var model: EntryModel
    
    var body: some View {
        switch model.field {
        case .start:
            DatePicker("Start Time", selection: $model.start, in: ...model.end)
                .labelsHidden()
                .datePickerStyle(WheelDatePickerStyle())
        case .end:
            DatePicker("End Time", selection: $model.end, in: model.start...)
                .labelsHidden()
                .datePickerStyle(WheelDatePickerStyle())
        case .project:
            List {
            
            }
        default:
            EmptyView()
        }
    }
}
