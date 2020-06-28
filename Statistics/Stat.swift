//
//  Stat.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 27/6/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct Stat: View {
    var label: String
    var symbol: String
    var text: Text
    
    private let glyphSize = CGFloat(30)
    var body: some View {
        Group {
            HStack{
                Text(label)
                Spacer()
                Image(systemName: self.symbol)
                    /// hardcoded values are bad practice, but only way I could align the glyphs
                    .frame(width: glyphSize, height: glyphSize)
            }
            text
        }
    }
}