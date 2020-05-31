//
//  DetailView.swift
//  CustomTableView
//
//  Created by Peter Ent on 12/4/19.
//  Copyright © 2019 Peter Ent. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    var entry: TimeEntry
    
    var body: some View {
        
        Text("\(entry.description)")
        .navigationBarTitle("Back")
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)

    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(entry:TimeEntry())
    }
}
