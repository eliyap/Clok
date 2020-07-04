//
//  Clockhands.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 3/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI


struct Clockhands: View {
    @EnvironmentObject var zero: ZeroDate
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: .zero) {
                HStack{
                    Spacer()
                    if zero.showHands {
                        Circle().frame(width:30, height: 30).transition(.inAndOut(edge: .top))
                    }
                    Spacer()
                }
                Spacer()
                HStack{
                    if zero.showHands {
                    Circle().frame(width:30, height: 30).transition(.inAndOut(edge: .leading))
                    }
                    Spacer()
                    if zero.showHands {
                        Circle().frame(width:30, height: 30).transition(.inAndOut(edge: .trailing))
                    }
                }
                Spacer()
                HStack{
                    Spacer()
                    if zero.showHands {
                        Circle().frame(width:30, height: 30).transition(.inAndOut(edge: .bottom))
                    }
                    Spacer()
                }
            }
        }
    }
}
