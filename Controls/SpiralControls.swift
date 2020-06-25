//
//  SpiralControls.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.14.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct SpiralControls: View {
    @EnvironmentObject private var data: TimeData
    
    var body: some View {
        VStack(spacing: .zero) {
            TimeStripView()
            Spacer()
            HStack {
                FilterStack()
                Spacer()
            }
            WeekButtons()
                /// disable week cycling when filtering
                .disabled(data.searching)
        }
    }
}

struct SpiralControls_Previews: PreviewProvider {
    static var previews: some View {
        SpiralControls()
    }
}
