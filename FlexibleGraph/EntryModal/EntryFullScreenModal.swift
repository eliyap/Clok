//
//  EntryFullScreenModal.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 2/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct EntryFullScreenModal: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    //MARK:- State Properties
    @State var scrollOffset: CGFloat = .zero
    @State var initialPos: CGFloat? = .none
    @State var bottomPos: CGFloat = .zero
    
    //MARK:- Static Properties
    /// the minimum pull-down to dismiss the view
    static let threshhold: CGFloat = 50
    static let sharedPadding: CGFloat = 10
    /// named Coordinate Space for this view
    let coordSpaceName = "bottom"
    
    
    @Binding var selected: TimeEntry?
    var namespace: Namespace.ID
    let entry: TimeEntryLike
    let geometry: NamespaceModel
    
    init(
        selected: Binding<TimeEntry?>,
        state: NewGraphModel,
        namespace: Namespace.ID
    ) {
        self._selected = selected
        self.namespace = namespace
        self.entry = state.selected ?? StaticEntry.noEntry
        self.geometry = state.geometry ?? NamespaceModel.none
    }
    
    var body: some View {
        /// define a drag gesture that imitates scrolling (no momentum though)
        let ScrollDrag = DragGesture()
            .onChanged { gesture in
                /// capture initial offset as gesture begins
                if initialPos == .none { initialPos = scrollOffset }
                let newOffset = initialPos! + gesture.translation.height
                withAnimation(.linear(duration: 0.05)) {
                    /// give pull down more "resistance"
                    self.scrollOffset = newOffset < 0 ? newOffset : newOffset / 3
                }
            }
            .onEnded { _ in
                initialPos = .none
                if scrollOffset > EntryFullScreenModal.threshhold {
                    self.dismiss()
                } else if scrollOffset > 0 {
                    withAnimation { scrollOffset = 0 }
                } else if bottomPos < 0 {
                    /// prevent scrolling past bottom of stack
                    withAnimation { scrollOffset -= bottomPos }
                }
            }
        
        return GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                /// a solid color background for the view
                Color(UIColor.secondarySystemBackground)
                    /** MGE placement here has 2 benefits
                     1. animation expands to / contracts from the full size of the screen
                     2. does not cause other elements to "crush" together as view contracts
                    */
                    .matchedGeometryEffect(id: geometry, in: namespace)
                    .offset(y: max(0, scrollOffset))
                ControlBar
                    .offset(y: max(0, scrollOffset))
                    .zIndex(1)
                VStack(spacing: .zero) {
                    EntryHeader
                        
                    EntryBody
                    /// monitors the position of the bottom of the view
                    GeometryReader { bottomGeo in
                        Run {
                            bottomPos = bottomGeo.frame(in: .named(coordSpaceName)).maxY - geo.size.height
                        }
                    }
                }
                    .offset(y: scrollOffset)
            }
                .frame(height: geo.size.height, alignment: .top)
                .coordinateSpace(name: coordSpaceName)
                .gesture(ScrollDrag)
        }
    }
    
    
    var EntryBody: some View {
        VStack(alignment: .labelText) {
            Label(entry.projectName, systemImage: "folder.fill")
                .labelStyle(AlignedLabelStyle())
            Label(entry.duration.toString(), systemImage: "stopwatch")
                .labelStyle(AlignedLabelStyle())
        }
            .padding(Self.sharedPadding)
    }
    
    // MARK:- ControlBar
    var ControlBar: some View {
        HStack {
            DismissalButton(dismiss: dismiss, completion: dismissalCompletion)
            Spacer()
            Button {
                print("dummy button!")
            } label: {
                Image(systemName: "xmark")
            }
        }
            .buttonStyle(PlainButtonStyle())
            .padding(Self.sharedPadding)
            .background(
                /// a nice transluscent system color
                Color(UIColor.secondarySystemFill)
                    /// allows it to cover color when user scrolls down
                    .edgesIgnoringSafeArea(.top)
            )
    }
    
    /// measures the progress of the "swipe down to dismiss" gesture. bounded from [0, 1]
    var dismissalCompletion: CGFloat {
        /// note: clamp prevents visual from triggering while scrolling down
        /// `-` inversion causes circle to fill clockwise instead of counterclockwise
        -clamp(scrollOffset / Self.threshhold, between: (0, 1))
    }
    
    func dismiss() -> Void {
        withAnimation { selected = .none }
    }
}
