//
//  EntryFullScreenModal.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 2/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct EntryFullScreenModal: View {
    
    //MARK:- Modal Properties
    @State var offSet: CGFloat = .zero
    @State var initialPos: CGFloat? = .none

    @Binding var showEntry: Bool
    var namespace: Namespace.ID
    
    /// the minimum pull-down to dismiss the view
    static let threshhold: CGFloat = 50
    
    var body: some View {
        Color.clear
            .overlay(
                ZStack(alignment: .topLeading) {
                    ControlBar
                        .offset(y: max(0, offSet))
                        .zIndex(1)
                    Color.green
                        .offset(y: offSet)
                }
            )
            .gesture(DragGesture()
                .onChanged { gesture in
                    /// capture initial offset as gesture begins
                    if initialPos == .none { initialPos = offSet }
                    let newOffset = initialPos! + gesture.translation.height
                    withAnimation(.linear(duration: 0.05)) {
                        /// give pull down more "resistance"
                        self.offSet = newOffset < 0 ? newOffset : newOffset / 3
                    }
                }
                .onEnded { _ in
                    initialPos = .none
                    if offSet > EntryFullScreenModal.threshhold {
                        self.dismiss()
                    } else if offSet > 0 {
                        withAnimation { offSet = 0 }
                    }
                }
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var ControlBar: some View {
        HStack {
            DismissalButton
            Spacer()
            Button {
                print("dummy button!")
            } label: {
                Image(systemName: "xmark")
            }
        }
            .buttonStyle(PlainButtonStyle())
            .padding()
            .background(
                /// a nice transluscent system color
                Color(UIColor.secondarySystemFill)
                    /// allows it to cover color when user scrolls down
                    .edgesIgnoringSafeArea(.top)
            )
    }
    
    static let ButtonSize: CGFloat = 30
    static let ButtonStrokeWeight: CGFloat = 2
    static var CircleRadius: CGFloat { CGFloat(Double.tau) * (EntryFullScreenModal.ButtonSize - ButtonStrokeWeight) }
    var dismissalCompletion: CGFloat {
        /// note: clamp prevents visual from triggering while scrolling down
        min(0, -offSet / Self.threshhold)
    }
    var DismissalButton: some View {
        Button {
            self.dismiss()
        } label: {
            ZStack {
                Image(systemName: "xmark")
                Circle()
                    .strokeBorder(style: StrokeStyle(
                        lineWidth: Self.ButtonStrokeWeight,
                        lineCap: .round,
                        dash: [Self.CircleRadius],
                        /// the 1/2 factor is because the whole dash - empty length is 2 * circumference
                        /// the 1 + increment starts the circle empty
                        dashPhase: Self.CircleRadius * (1 + dismissalCompletion / 2)
                    ))
                    .frame(width: Self.ButtonSize, height: Self.ButtonSize)
                    /// make circle start drawing from 12 'o' clock, not 3 'o' clock
                    .rotationEffect(-.tau / 4)
            }
        }
    }
    
    func dismiss() -> Void {
        withAnimation { showEntry = false }
    }
}
