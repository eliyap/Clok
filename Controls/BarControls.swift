//
//  BarControls.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 10/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct BarControls: View {
    var body: some View {
        VStack(spacing: .zero) {
//            TimeStripView()
            Spacer()
            HStack {
                FilterStack()
                Spacer()
            }
            WeekButtons()
        }
    }
}
