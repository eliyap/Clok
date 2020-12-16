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
    
    /// model history, allowing us to implement an undo / redo system
    @State var pastModels = [EntryModel]()
    @State var futureModels = [EntryModel]()
    @State var undoTracker = Set<AnyCancellable>()
    
    /// represents whether the undo / redo system is in the process of changing anything (during which `undoTracker`) should be dormant
    @State var isAmending = false
    
    //MARK:- Form Properties
    @StateObject var entryModel = EntryModel(from: StaticEntry.noEntry)
    
    //MARK:- Static Properties
    /// the minimum pull-down to dismiss the view
    static let threshhold: CGFloat = 50
    static let sharedPadding: CGFloat = 10
    /// named Coordinate Space for this view
    let coordSpaceName = "bottom"
    
    
    let dismiss: () -> Void
    var namespace: Namespace.ID
    let entry: TimeEntryLike
    let geometry: NamespaceModel
    
    init(
        entry: TimeEntry?,
        geometry: NamespaceModel,
        namespace: Namespace.ID,
        dismiss: @escaping () -> Void
    ) {
        self.dismiss = dismiss
        self.namespace = namespace
        self.entry = entry ?? StaticEntry.noEntry
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
                    .offset(y: max(0, scrollOffset))
                /// translucent bar with some main control buttons
                ControlBar(dismiss: dismiss, undo: undo, redo: redo, dismissalCompletion: dismissalCompletion, model: entryModel)
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
                .frame(height: geo.size.height, alignment: .top)
                .coordinateSpace(name: coordSpaceName)
                .gesture(ScrollDrag)
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
        .onAppear(perform: monitor)
    }
    
    /// measures the progress of the "swipe down to dismiss" gesture. bounded from [0, 1]
    var dismissalCompletion: CGFloat {
        /// note: clamp prevents visual from triggering while scrolling down
        /// `-` inversion causes circle to fill clockwise instead of counterclockwise
        -clamp(scrollOffset / Self.threshhold, between: (0, 1))
    }
    
    func undo() -> Void {
        /// lock `undoTracker` out during function scope
        isAmending = true
        defer { isAmending = false }
        
        #if DEBUG
        print(pastModels.count, pastModels.last?.start.MMMdd)
        #endif
        /// ensure there is at least one recent model
        guard let recent = pastModels.popLast() else { return }
        
        /// allow user to `redo` to current state
        futureModels.append(entryModel)
        
        /// ignored: `id`, `field`
        entryModel.start = recent.start
        entryModel.end = recent.end
        entryModel.billable = recent.billable
        entryModel.project = recent.project
    }
    
    func redo() -> Void {
        /// lock `undoTracker` out during function scope
        isAmending = true
        defer { isAmending = false }
        
        /// ensure there is at least one recent model
        guard let imminent = futureModels.popLast() else { return }
        
        /// allow user to `undo` to current state
        pastModels.append(entryModel)
        
        /// ignored: `id`, `field`
        entryModel.start = imminent.start
        entryModel.end = imminent.end
        entryModel.billable = imminent.billable
        entryModel.project = imminent.project
    }
    
    func monitor() {
        entryModel.objectWillChange.sink { _ in
            /// if we're in the process of changing something, just ignore what's going on.
            guard !isAmending else { return }
            
            #if DEBUG
            print("CHANGE DETECTED \(entryModel.start.MMMdd)")
            #endif
            /// store any changes, as well as the initial value
            print((pastModels.last ?? EntryModel(from: StaticEntry.noEntry)).start, entryModel.start)
            
            /// abuse short-circuit evaluation to perform a force unwrap
            /// https://docs.swift.org/swift-book/LanguageGuide/BasicOperators.html
            if pastModels.last == nil || pastModels.last! != entryModel {
                /// NOTE: recall that classes are reference types, hence a copy must be made!
                pastModels.append(entryModel.copy() as! EntryModel)
                #if DEBUG
                print("\(pastModels.count) undos left")
                #endif
            }
        }.store(in: &undoTracker)
    }
}
