//
//  DateAndTimeIndicator.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 2/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

struct DateAndTimeIndicator: View {
    
    let divisions: Int
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                Run {
                    print(geo.frame(in: .global).maxY)
                }
            }
                .frame(width: 0, height: 0, alignment: .top)
            TimeIndicator(divisions: divisions)
        }
    }
}
