//
//  SearchContrastScreen.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 28/6/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct SearchContrastScreen: View {
    @EnvironmentObject private var data: TimeData
    var body: some View {
        Rectangle()
            .foregroundColor(Color(UIColor.systemBackground))
            .opacity(0.4)
            .transition(.opacity)
            .edgesIgnoringSafeArea(.all)
    }
}

struct SearchContrastScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchContrastScreen()
    }
}
