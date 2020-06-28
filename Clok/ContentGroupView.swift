//  ContentGroupView.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.

import SwiftUI

struct ContentGroupView: View {
    var heightLimit: CGFloat
    var widthLimit: CGFloat
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
                        Rectangle()
                            .foregroundColor(Color(UIColor.systemBackground))
                            .opacity(0.4)
                            .transition(.opacity)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                self.data.searching = false
                            }
                    }
                }
                    .blur(radius: blurRadius)
                    .onReceive(data.$searching, perform: { searching in
                        withAnimation{
                            self.blurRadius = searching ? 5 : .zero
                        }
                    })
                    .frame(
                        width: min(self.widthLimit, self.heightLimit),
                        height: min(self.widthLimit, self.heightLimit)
                    )
                    /**
                     Permits overlap of areas
                     - Important: ZStacking did *not* work, as the Time Strip layer grabbed touch focus,
                     preventing the user from manipulating the handle
                     */
                    .padding(Edge.Set.bottom, -heightLimit)
                    /// turn off interaction when user is filtering
                    .disabled(data.searching)
                SpiralControls()
            }
            .frame(width: self.widthLimit, height: self.heightLimit)
            TimeTabView()
        }
    }
}
