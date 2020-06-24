//
//  FilterButton.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 24/6/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct FilterButton: View {
    let radius = CGFloat(10)

    var body: some View {
        Button(action: {
            
        }) {
            Image(systemName: "line.horizontal.3.decrease.circle")
                .foregroundColor(.primary)
                .padding()
                .background(RaisedShape(radius: radius) { Circle() })
                .border(Color.red)
                .padding([.leading, .trailing])

        }
    }
}

struct FilterButton_Previews: PreviewProvider {
    static var previews: some View {
        FilterButton()
    }
}
