//
//  PropertyEditView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 14/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct PropertyEditView: View {
    
    let field: EntryModel.Field
    @ObservedObject var model: EntryModel
    
    var body: some View {
        switch field {
        case .start:
            DatePicker("Start Time", selection: $model.start, in: ...model.end)
                    .labelsHidden()
        case .end:
            DatePicker("End Time", selection: $model.end, in: model.start...)
                    .labelsHidden()
        default:
            EmptyView()
        }
    }
}
