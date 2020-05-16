//
//  EntryList.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.05.15.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct EntryList: View {
    @ObservedObject var report = Report()
    
    var body: some View {
    
            List {
                Section(header: Text("Test").font(.largeTitle)) {
                    ForEach(self.report.entries, id: \.id) { entry in
                        LineEntry(entry)
                            // removes the vertical padding around list items
                            // so that the right side color bars can touch
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                    }
                }
            }
        
        
        
    
        
    
    }
}

struct EntryList_Previews: PreviewProvider {
    static var previews: some View {
        EntryList()
    }
}
