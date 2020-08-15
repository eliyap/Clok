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
                    weekday = newDay(idx: idx)
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text(newDay(idx: idx).weekdaySymbol)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Week starts on")
    }
    
    private func newDay(idx: Int) -> Int {
        (weekday + idx - 1) % 7 + 1
    }
}

fileprivate extension Int {
    var weekdaySymbol: String {
        precondition(1 <= self && self <= 7, "\(self) is not a valid index!")
        /// fix offset from 1 indexed components to zero indexed name array
        return Calendar.current.weekdaySymbols[self - 1]
    }
}
