//
//  TimeIndicator.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 4/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct TimeIndicator: View {
    let divisions: Int

    let tf = DateFormatter()
    
    var body: some View {
        VStack {
            ForEach(0..<divisions, id: \.self) { idx in
                Text("hi")
                Text("\(tf.string(from: Calendar.current.startOfDay(for: Date()) + Double(idx * 86400/divisions)))")
                    .onAppear{
                        print(tf.string(from: Calendar.current.startOfDay(for: Date()) + Double(idx * 86400/divisions)))
                    }
            }
            
        }
            .onAppear {
                /// show hour in preferred way (no minutes or seconds)
                tf.setLocalizedDateFormatFromTemplate(is24hour() ? "HH" : "h a")
            }
    }
}
