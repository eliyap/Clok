//
//  NewGraphView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 29/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI


struct NewGraph: View {
    
    @State private var DayList = [0]
    @Environment(\.colorScheme) private var mode
    @Environment(\.namespace) var namespace
    @EnvironmentObject var model: NewGraphModel
    @EnvironmentObject var data: TimeData
    @FetchRequest(
        entity: TimeEntry.entity(),
        sortDescriptors: []
    ) var entries: FetchedResults<TimeEntry>
    
    private var df = DateFormatter()
    /// fixed size footer, unfortunate but necessary
    static let footerHeight: CGFloat = 20

    
    init() {
        df.setLocalizedDateFormatFromTemplate("MMMdd")
    }
    
    var body: some View {
        /// a giant, monstrous hack
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: .zero, pinnedViews: .sectionFooters) {
                    ForEach(DayList, id: \.self) { idx in
                        Section(footer: Footer(idx: idx, size: geo.size)) {
                            switch model.mode {
                            case .dayMode:
                                DayCalendarBody(size: geo.size, idx: idx)
                            case .weekMode:
                                WeekCalendarBody(size: geo.size, idx: idx)
                            case .listMode:
                                ListBody(idx: idx)
                            }
                        }
                            /// flip view back over
                            .rotationEffect(.tau / 2)
                            /// if user hits the "last" (visually top) date, add another one "above" (by appending)
                            .onAppear {
                                if idx == DayList.last {
                                    DayList.insert(DayList.last! - 1, at: DayList.count)
                                }
                            }
                    }
                }
            }
                /**
                 Flipped over so user can infinitely scroll "up" (actually down) to previous days
                 */
                .rotationEffect(.tau / 2)
        }
    }
}

// MARK:- Calendar Body
extension NewGraph {
    func WeekCalendarBody(size: CGSize, idx: Int) -> some View {
        HStack(spacing: .zero) {
            Rectangle()
                .foregroundColor(.background)
                .frame(width: size.width, height: size.height)
            NewTimeIndicator(divisions: evenDivisions(for: size.height))
            WeekCalendar(
                dayHeight: size.height,
                start: Date().midnight.advanced(by: Double(idx) * .day),
                row: idx
            )
            Rectangle()
                .foregroundColor(.background)
                .frame(width: size.width, height: size.height)
        }
            .frame(width: 3 * size.width)
            .padding(.top, -NewGraph.footerHeight)
            .offset(x: size.width)
    }
}

// MARK:- List Body
extension NewGraph {
    func ListBody(idx: Int) -> some View {
        ListView(
            start: Date().midnight.advanced(by: Double(idx) * .day),
            row: idx
        )
    }
}

// MARK:- Section Footer
extension NewGraph {
    func Footer(idx: Int, size: CGSize) -> some View {
        HStack(spacing: .zero) {
            /// prevents the `DateIndicator` from covering the `TimeIndicator`
            WidthHelper(size: size)
            Text(df.string(from: Date().advanced(by: Double(idx) * .day)))
                .foregroundColor(mode == .dark ? .black : .white)
                .font(.system(size: NewGraph.footerHeight - 5))
                .bold()
                .frame(height: NewGraph.footerHeight)
                .padding([.leading, .trailing], 3)
                .background(
                    RoundedCornerRectangle(radius: 4, corners: [.bottomRight, .topRight])
                        .foregroundColor(.red)
                )
            /// push view against the left edge of the graph
            Spacer()
        }
    }
}

// MARK:- Width Helper
extension NewGraph {
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
