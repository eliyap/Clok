//
//  WeekdaySelector.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 13/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct WeekdaySelector: View {
    
    @Binding var weekday: Int
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List {
            ForEach(0..<7) { idx in
                Button {
                    weekday = weekday + idx % 7
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text((weekday + idx % 7).weekdaySymbol)
                }
            }
        }
    }
}

fileprivate extension Int {
    var weekdaySymbol: String {
        precondition(1 <= self && self <= 7, "\(self) is not a valid index!")
        /// fix offset from 1 indexed components to zero indexed name array
        return Calendar.current.weekdaySymbols[self - 1]
    }
}
