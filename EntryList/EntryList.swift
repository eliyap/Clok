//
//  EntryList.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 1/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct EntryList: View {
    
    @EnvironmentObject var data: TimeData
    @EnvironmentObject var zero: ZeroDate
    
    var body: some View {
        List {
            ForEach(data.report.entries.within(interval: weekLength, of: zero.date), id: \.id) { entry in
                Text(entry.description)
            }
        }
    }
}

struct EntryList_Previews: PreviewProvider {
    static var previews: some View {
        EntryList()
    }
}
