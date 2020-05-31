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
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(entry:TimeEntry())
    }
}
