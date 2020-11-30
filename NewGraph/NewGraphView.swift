//
//  NewGraphView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 29/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

/// fixed size footer, unfortunate but necessary
fileprivate let footerHeight: CGFloat = 20

struct NewGraph: View {
    
    @State var DayList = [0]
    var df = DateFormatter()
    
    init() {
        df.setLocalizedDateFormatFromTemplate("MMMdd")
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                ScrollViewReader { proxy in
                    LazyVStack(alignment: .leading, spacing: .zero, pinnedViews: .sectionFooters) {
                        ForEach(DayList, id: \.self) { idx in
                            Section(footer:Footer(idx: idx, size: geo.size)) {
                                DayRect(idx: idx, size: geo.size)
                                    .padding(.bottom, -footerHeight)
                            }
                                .rotationEffect(.tau / 2)
                                .onAppear {
                                    if idx == DayList.last {
                                        DayList.insert(DayList.last! - 1, at: DayList.count)
                                    }
                                }
                        }
                    }
                }
            }
            .rotationEffect(.tau / 2)
        }
    }
    
    func DayRect(idx: Int, size: CGSize) -> some View {
        HStack(spacing: .zero) {
            NewTimeIndicator(divisions: evenDivisions(for: size.height))
            NewLineGraphView(
                dayHeight: size.height,
                start: Date().midnight.advanced(by: Double(idx) * .day)
            )
        }
    }
    
    func dateString(at idx: Int) -> String {
        df.string(from: Date().advanced(by: Double(idx) * .day))
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

// MARK:- Section Footer
extension NewGraph {
    func Footer(idx: Int, size: CGSize) -> some View {
        HStack(spacing: .zero) {
            /// prevents the `DateIndicator` from covering the `TimeIndicator`
            WidthHelper(size: size)
            Text(dateString(at: idx))
                .font(.system(size: footerHeight - 5))
                .frame(height: footerHeight)
                .background(
                    RoundedCornerRectangle(radius: 10, corners: [.bottomRight, .topRight])
                        .foregroundColor(.red)
                )
                .offset(y: footerHeight)
            /// push view against the left edge of the graph
            Spacer()
        }
            /// drop a hair to allow the red divider to show through
            .offset(y: 1)
    }
}
