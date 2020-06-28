//  ContentGroupView.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.

import SwiftUI

struct ContentGroupView: View {
    @State var blurRadius = CGFloat.zero
    
    @EnvironmentObject private var data:TimeData
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                ZStack{
                    SpiralUI()
                    KnobView()
                    if self.data.searching {
                        /// increase contrast with filter text so it is more readable
                        SearchContrastScreen()
                    }
                }
                    .blur(radius: blurRadius)
                    .onReceive(data.$searching, perform: { searching in
                        withAnimation{
                            self.blurRadius = searching ? 5 : .zero
                        }
                    })
                    .frame(
                        width: UIScreen.main.bounds.size.height,
                        height: UIScreen.main.bounds.size.height
                    )
                    /**
                     Permits overlap of areas
                     - Important: ZStacking did *not* work, as the Time Strip layer grabbed touch focus,
                     preventing the user from manipulating the handle
                     */
                    .padding(Edge.Set.bottom, -UIScreen.main.bounds.size.height)
                    /// turn off interaction when user is filtering
                    .disabled(data.searching)
                SpiralControls()
            }
            .frame(width: UIScreen.main.bounds.size.height, height: UIScreen.main.bounds.size.height)
            TimeTabView()
        }
    }
}
