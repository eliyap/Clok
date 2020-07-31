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
    @State private var dateString = ""
    private var df = DateFormatter()
    
    var body: some View {
        HStack{
            Text(dateString)
                .font(.headline)
                .bold()
                .onReceive(self.zero.$startDate, perform: { date in
                /// set labels programatically so that ellipsis animation does NOT play when changing date
                self.dateString = "\(self.df.string(from: date)) – \(self.df.string(from: date + weekLength))"
            })
            Spacer()
        }
        
    }
    
    init() {
        df.setLocalizedDateFormatFromTemplate("MMMdd")
    }
}
