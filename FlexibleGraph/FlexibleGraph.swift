//
//  FlexibleGraph.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 2/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI
import Combine

/**
 Against my better judgement, this entire view is written in ONE struct, so that they may all share `Namespace`s.
 Alternative 1: pass `Namespace.ID` down 10 levels of hierarchy (hint: not happening)
 Alternative 2: make `Namespace.ID` an environment var (skip the hierarchy). I tried this, and swift started complaining at me, so here we are.
 */
struct FlexibleGraph: View {
    
    
    //MARK:- Properties
    /// tracks the `View`'s state, such as its mode and which `TimeEntry` is selected
    @StateObject var model = NewGraphModel()
    @State var passthroughGeometry: NamespaceModel? = nil
    @State var passthroughSelected: TimeEntry? = nil
    
    /// whether to show the `Mode` select menu
    @State var showSheet: Bool = false
    
    /// used for our `matchedGeometryEffect` animations
    @Namespace var graphNamespace
    @Namespace var modalNamespace
    
    /// access CoreData `TimeEntry` storage
    @FetchRequest(
        entity: TimeEntry.entity(),
        sortDescriptors: []
    ) var entries: FetchedResults<TimeEntry>
    
    /// light / dark mode
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var data: TimeData
    @EnvironmentObject var bounds: Bounds
    
    //MARK:- InfiniteScroll Properties
    
    /// records the rows for `InfiniteScroll`
    /** Observational Notes, 20.12.02
        Issue 1: Appending Pages when the user scrolls up causes a ~60ms animation hitch. I haven't been able to solve that.
        Issue 2: Including a very large (but finite) number of rows causes the app to consume a LOT of memory (20000rows = 200mb)
        Compromise: We will include *some* rows, AND allow the list to grow beyond that number.
        Most users will not experience the animation hitching (lordwilling), but those wishing to dip years into their Toggl archive will be *able* to do so.
            
     Note: there is a soft limit on past days, but a HARD limit on future days

     Note: UIKit scrollsToTop (https://developer.apple.com/documentation/uikit/uiscrollview/1619421-scrollstotop)
     is not (yet) available in ScrollView, so tapping the status bar sends the view ALLLL the way down.
     Therefore I am capping future exploration at 0 days, which should not affect TimeEntries that aren't recorded in the future.
     If this changes, do allow exploration of the future by increasing the cap
     */
    @State var RowList = Array((-(365*3)...0).reversed())
    
    @State var dragInitial: CGFloat? = .none
    
    /// updated row and position of that row as user scrolls
    @State var rowPosition: RowPositionModel = .zero
    
    /// Publisher allows us to manually request updates and changes to the `rowPosition`.
    /// Value passed indicates the requested change in row, or `nil` if no change is required
    let positionRequester = PassthroughSubject<Int?, Never>()
    
    /// arbitrary value to shift `id` for `PageAnchor`. Do not set to `1`!
    static let idOffset = 0.5
    
    //MARK:- Body
    var body: some View {
        ZStack {
            switch model.mode {
            case .dayMode, .listMode:
                VerticalScroll
            case .extendedMode:
                HorizontalScroll
            }
            /// show full screen modal when an entry is pushed
            if model.selected != .none {
                EntryFullScreenModal(
                    /// pass binding, as `dismiss` needs to set this parameter
                    selected: $passthroughSelected,
                    /// pass resultant property, as this only needs to be read
                    state: model,
                    namespace: modalNamespace
                )
                    /// increase zIndex so that, while animating, modal does not fall behind other entries
                    .zIndex(1)
            }
            /// handles the Hero Animation when a `TimeEntry` is selected / dismissed
            MGEAnimator
            #warning("placeholder UI")
            Button {
                showSheet = true
            } label: {
                Text("Transform!")
            }
                .actionSheet(isPresented: $showSheet) { ModeSheet }
        }
    }
}
