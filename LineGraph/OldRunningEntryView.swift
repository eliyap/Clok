//
//  RunningEntryView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 21/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI
import Combine
import WidgetKit

/// how long to wait before checking `RunningEntry` again
fileprivate let interval = TimeInterval(10)

struct RunningEntryView: View {
    
    @EnvironmentObject var cred: Credentials
    @EnvironmentObject var model: GraphModel
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: Project.entity(), sortDescriptors: []) var projects: FetchedResults<Project>
    
    /// manage the auto updating
    let timer = Timer.publish(every: interval, on: .main, in: .common).autoconnect()
    @State var running: RunningEntry? = nil
    @State var cancellable: AnyCancellable? = nil
    
    let terms: SearchTerms
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center, spacing: .zero) {
                if let running = running {
                    EntryRect(
                        range: (running.start, Date()),
                        size: geo.size,
                        midnight: Date().midnight
                    )
                        /// placeholder styling
                        .opacity(0.5)
                        .overlay(
                            EntryRect(
                                range: (running.start, Date()),
                                size: geo.size,
                                midnight: Date().midnight,
                                border: true
                            )
                        )
                        .foregroundColor(running.wrappedProject.color)
                        .offset(y: offset(size: geo.size, running: running))
                } else {
                    EmptyView()
                }
            }
            .frame(width: geo.size.width)
            
        }
        /// deliberately hobbled in lieu of removing this whole View
//            .onReceive(timer) { _ in loadRunning() }
            .onAppear(perform: loadRunning)
    }
    
    /// calculate appropriate distance to next `entry`
    func offset(size: CGSize, running: RunningEntry) -> CGFloat {
        let scale = size.height / CGFloat(.day * model.days)
        return CGFloat(max(running.start - (Date().midnight - model.castBack), .zero)) * scale
    }
    
    func loadRunning() -> Void {
        #warning("commented out pending deletion")
//        guard let user = cred.user else { return }
//        cancellable = RunningEntryLoader.fetchRunningEntry(
//            user: user,
//            projects: Array(projects),
//            context: moc
//        )
//        /// if fetch is successful, save to `UserDefaults`
//        .map { runningEntry in
//            #if DEBUG
//            print(runningEntry == RunningEntry.noEntry ? "No Entry Running." : "Running: \(runningEntry?.project.name), \(runningEntry?.entryDescription)")
//            #endif
//            if !RunningEntry.widgetMatch(
//                WidgetManager.running,
//                runningEntry
//            ) {
//                #if DEBUG
//                print("Difference Detected, Reloading Widget Timeline")
//                #endif
//                WidgetManager.running = runningEntry
//                WidgetCenter.shared.reloadAllTimelines()
//            }
//            return runningEntry
//        }
//        .assign(to: \.running, on: self)
    }
}
