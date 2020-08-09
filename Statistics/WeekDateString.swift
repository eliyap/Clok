//
//  WeekDateString.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 27/6/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct WeekDateString: View {
    @EnvironmentObject private var zero: ZeroDate
    private var df = DateFormatter()
    
    init() {
        df.setLocalizedDateFormatFromTemplate("MMMdd")
    }
    
    var body: some View {
        HStack{
            Text("\(df.string(from: zero.start)) – \(df.string(from: zero.end - 1))")
                .font(.headline)
                .bold()
            Spacer()
        }
    }
}
