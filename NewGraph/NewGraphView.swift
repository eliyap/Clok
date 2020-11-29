//
//  NewGraphView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 29/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

fileprivate let scrollLimit = 10000

struct NewGraph: View {
    
    @State var xOffset: CGFloat = .zero
    @State var recentPos: CGFloat? = .none
    
    var DayList = Array(0..<(365 + scrollLimit))
    var df = DateFormatter()
    
    init() {
        df.dateStyle = .short
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                ScrollViewReader { proxy in
                    LazyVStack(alignment: .leading, spacing: .zero, pinnedViews: .sectionHeaders) {
                        ForEach(DayList, id: \.self) { idx in
                            DaySection(idx: idx, size: geo.size)
                        }
                    }
                    .onAppear {
                        proxy.scrollTo(scrollLimit)
                    }
                }
            }
        }
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    recentPos = recentPos == .none ? gesture.startLocation.x : recentPos
//                    withAnimation(.linear(duration: 0.05)) {
                        self.xOffset += gesture.location.x - recentPos!
//                    }
                    
                    recentPos = gesture.location.x
                }
                .onEnded { _ in
                    recentPos = .none
                    withAnimation {
                        self.xOffset = 0
                    }
                }
        )
    }
    
    func DaySection(idx: Int, size: CGSize) -> some View {
        Section(header:
            HStack(spacing: .zero) {
                WidthHelper(size: size)
                Text(dateString(at: idx))
                    .frame(height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.clokBG)
                    )
            }
                /// drop a hair to allow the red divider to show through
                .offset(y: 1)
                .offset(x: xOffset)
        ) {
            DayRect(idx: idx, size: size)
                .padding(.top, -40)
        }
    }
    
    func DayRect(idx: Int, size: CGSize) -> some View {
        HStack(spacing: .zero) {
            NewTimeIndicator(divisions: evenDivisions(for: size.height))
            NewLineGraphView(
                dayHeight: size.height,
                start: Date().midnight.advanced(by: Double(idx - scrollLimit) * .day)
            )
        }
    }
    
    func dateString(at idx: Int) -> String {
        df.string(from: Date().advanced(by: Double(idx - scrollLimit) * .day))
    }
    
    /**
     Wrapper around  an invisible`TimeIndicator`.
     Keeps the labels aligned correctly above their respective days
     */
    func WidthHelper(size: CGSize) -> some View {
        /// `TimeIndicator` is very tall, so wrap it in a `ScrollView`
        /// to allow it to collapse its height without messing up the width
        ScrollView {
            NewTimeIndicator(divisions: evenDivisions(for: size.height))
        }
            /// view should be invisible and non-interactable
            .opacity(0)
            .allowsHitTesting(false)
            .disabled(true)
            .frame(height: .zero)
    }
}
