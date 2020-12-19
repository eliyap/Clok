//
//  EntryFullScreenModal.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 2/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI
import Combine

struct EntryFullScreenModal: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    //MARK:- State Properties
    /// measures the amount to offset the view to simulate "scrolling"
    @State var scrollOffset: CGFloat = .zero
    
    /// temporary storage for the view's initial position before "scrolling" began
    @State var initialPos: CGFloat? = .none
    
    /// updated position of the bottom of the view
    @State var bottomPos: CGFloat = .zero
    
    /// updated amount to offset some view with an icon
    @State var iconOffset: CGFloat = .zero
    
    /// whether the user is considering discarding the changes
    @State var isDiscarding: Bool = false
    
    //MARK:- Form Properties
    @StateObject var entryModel = EntryModel(from: StaticEntry.noEntry)
    
    //MARK:- Static Properties
    /// the minimum pull-down to dismiss the view
    static let threshhold: CGFloat = 50
    static let sharedPadding: CGFloat = 10
    /// named Coordinate Space for this view
    let coordSpaceName = "bottom"
    
    /// dismisses `EntryFullScreenModal`
    let dismiss: () -> Void
    let save: (EntryModel) -> Void
    
    /// the `Namespace` to match our `matchedGeometryEffects` against
    var namespace: Namespace.ID
    
    /// the `TimeEntry` to match our `matchedGeometryEffects` against
    let geometry: NamespaceModel
    
    init(
        entry: TimeEntry?,
        geometry: NamespaceModel,
        namespace: Namespace.ID,
        dismiss: @escaping () -> Void,
        save: @escaping (EntryModel) -> Void
    ) {
        self.dismiss = dismiss
        self.save = save
        self.namespace = namespace
        self.geometry = geometry
        self._entryModel = StateObject(wrappedValue: EntryModel(from: entry ?? StaticEntry.noEntry))
    }
    
    var body: some View {
        /// define a drag gesture that imitates scrolling (no momentum though)
        let ScrollDrag = DragGesture()
            .onChanged { gesture in
                /// if second modal is being shown, ignore drag gesture
                guard entryModel.field == .none else { return }
                
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
                    self.discard()
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
                    .offset(y: max(0, scrollOffset))
                /// translucent bar with some main control buttons
                ControlBar(discard: discard, save: saveChanges, dismissalCompletion: dismissalCompletion, model: entryModel)
                    .offset(y: max(0, scrollOffset))
                    .zIndex(1)
                /// the rest of the view
                VStack(alignment: .leading, spacing: .zero) {
                    EntryHeader
                    EntryBody(model: entryModel, width: geo.size.width - iconOffset)
                    /// monitors the position of the bottom of the view, and the offset of `Label` icon
                    Label {
                        GeometryReader { bottomGeo in
                            Run {
                                bottomPos = bottomGeo.frame(in: .named(coordSpaceName)).maxY - geo.size.height
                                iconOffset = bottomGeo.frame(in: .named(coordSpaceName)).minX
                            }
                        }
                    } icon: {
                        /// invisible glyph
                        Image(systemName: "circle")
                            .foregroundColor(.clear)
                    }
                        /// pad horizontally to mimic `EntryBody`, but not vertically, to preserve integrity of `bottomPos` reading
                        .padding(.horizontal, EntryFullScreenModal.sharedPadding)
                }
                    .offset(y: scrollOffset)
                PropertyEditView(model: entryModel)
            }
                .actionSheet(isPresented: $isDiscarding) { DiscardSheet }
                .frame(height: geo.size.height, alignment: .top)
                .coordinateSpace(name: coordSpaceName)
                .gesture(ScrollDrag)
                /// minor thing, if the app is closed, I don't want it to re-appear in a suspended state
                /// (from which it will not spring back, since `DragGesture.onEnded` is never called)
                .onBackgrounded { _ in
                    self.scrollOffset = .zero
                }
        }
        .mask(
            /** MGE placement here has 2 benefits
             1. animation expands to / contracts from the full size of the screen
             2. does not cause other elements to "crush" together as view contracts
            */
            Rectangle()
                .matchedGeometryEffect(
                    id: geometry,
                    in: namespace,
                    isSource: false
                )
        )
    }
    
    /// measures the progress of the "swipe down to dismiss" gesture. bounded from [0, 1]
    var dismissalCompletion: CGFloat {
        /// note: clamp prevents visual from triggering while scrolling down
        /// `-` inversion causes circle to fill clockwise instead of counterclockwise
        -clamp(scrollOffset / Self.threshhold, between: (0, 1))
    }
}

//MARK:- Dismissal
extension EntryFullScreenModal {
    func saveChanges() -> Void {
        save(entryModel)
    }
    
    func discard() -> Void {
        isDiscarding = true
    }
    
    var DiscardSheet: ActionSheet {
        ActionSheet(title: Text("Discard Changes?"), buttons: [
            .destructive(Text("Discard"), action: dismiss),
            .cancel()
        ])
    }
}

