//
//  HorizontalScroll.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 7/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

extension FlexibleGraph {
    
    var HorizontalScroll: some View {
        GeometryReader { geo in
            HStack(spacing: .zero) {
                AlignedTimeIndicator(height: geo.size.height)
                    .offset(y: -geo.size.height * rowPosition.position.y)
                    .gesture(DragGesture()
                        .onChanged { state in
                            rowPosition.position.y += state.translation.height / geo.size.height
                        }
                    )
                HorizontalScrollView
            }
        }
    }
    
    var HorizontalScrollView: some View {
        /** Enables user to scroll left (but not right) as far as they want.
         Important to my vision of allowing cross-day visualization.
         Built on a monstrous hack that exploits the behaviour of `LazyHStack`,
         wherein it doesn't scroll when views are added to the front
         */
        GeometryReader { geo in
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { proxy in
                    LazyHStack(spacing: .zero) {
                        ForEach(RowList, id: \.self) { idx in
                            DayStrip(
                                midnight: Date()
                                    .midnight
                                    .advanced(by: Double(idx) * .day + Double(rowPosition.position.y) * .day),
                                idx: idx
                            )
                                /// NOTE: this is effectively an arbitrary value
                                .frame(width: geo.size.width / 7)
                                .rotationEffect(.tau / 2)
                                /// if user hits the "last" (visually leftmost) date, add another one to the left (by appending)
                                .onAppear {
                                    if idx == RowList.last {
                                        RowList.insert(RowList.last! - 1, at: RowList.count)
                                    }
                                }
                        }
                    }
                    .onChange(of: requestedPosition) { req in
                        print(requestedPosition)
                        proxy.scrollTo(Double(req.row + 1) + 0.5, anchor: req.position)
                    }
                }
            }
                /** Flipped over so user can infinitely scroll "left" (actually right) to previous days */
                .rotationEffect(.tau / 2)
        }
    }
    
    
    /// Glues together 2 `TimeIndicators` in the right way to place it in beside the `HorizontalScrollView`
    func AlignedTimeIndicator(height: CGFloat) -> some View {
        VStack(spacing: .zero) {
            NewTimeIndicator(divisions: evenDivisions(for: height))
                .frame(height: height)
            NewTimeIndicator(divisions: evenDivisions(for: height))
                .frame(height: height)
        }
            .frame(height: height, alignment: .top)
            .offset(y: -height * rowPosition.position.y)
    }
    
    // MARK:- DayStrip
    func DayStrip(midnight: Date, idx: Int) -> some View {
        GeometryReader { geo in
            ZStack {
                ForEach(
                    entries
                        .filter{$0.end > midnight}
                        .filter{$0.start < midnight + .day}
                        /// chronological sort
                        .sorted{$0.start < $1.start}
                    , id: \.id
                ) { entry in
                    WeekRect(
                        entry: entry,
                        size: geo.size,
                        midnight: midnight,
                        idx: idx
                    )
                        /// push `View` down to `(proportion through the day x height)`
                        .offset(y: CGFloat((entry.start - midnight) / .day) * geo.size.height)
                        /// fade out views that do not match the filter
                        .opacity(entry.matches(data.terms) ? 1 : 0.25)
                        /// push View to stack when tapped
                        .onTapGesture {
                            passthroughGeometry = NamespaceModel(entryID: entry.id, dayIndex: idx)
                            passthroughSelected = entry
                        }
                }
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
                
                /// show current time in `calendar` mode
                if midnight == Date().midnight {
                    NewCurrentTimeIndicator(height: geo.size.height)
                        .frame(
                            width: geo.size.width,
                            height: geo.size.height,
                            alignment: .top
                        )
//                    NewRunningEntryView(terms: data.terms)
                }
            }
        }
    }
    
    //MARK:- WeekRect
    func WeekRect(
        entry: TimeEntry,
        size: CGSize,
        midnight: Date,
        idx: Int
    ) -> some View {
        let height = size.height * CGFloat((entry.end - entry.start) / .day)
        return entry.color(in: colorScheme)
            /// note: 1/18 is an arbitrary ratio, adjust to taste
            .cornerRadius(min(size.width / 18.0, height / 2))
            /// note: 0.8 is an arbitrary ratio, adjust to taste
            .matchedGeometryEffect(
                id: NamespaceModel(entryID: entry.id, dayIndex: idx),
                in: graphNamespace,
                isSource: model.selected == .none
            )
            .frame(width: size.width * 0.8, height: height)
    }
}
