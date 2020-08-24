//
//  RunningEntryView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 21/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI
import Combine

/// how long to wait before checking `RunningEntry` again
fileprivate let interval = TimeInterval(10)

struct RunningEntryView: View {
    
    @EnvironmentObject var cred: Credentials
    @EnvironmentObject var model: GraphModel
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: Project.entity(), sortDescriptors: []) var projects: FetchedResults<Project>
    
    /// manage the auto updating
    let timer = Timer.publish(every: interval, on: .main, in: .common).autoconnect()
    
    @ObservedObject var loader = RunningEntryLoader()
    
    let terms: SearchTerms
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center, spacing: .zero) {
                if let running = loader.running {
                    EntryRect(
                        range: (running.start, Date()),
                        size: geo.size,
                        midnight: Date().midnight
                    )
                        .foregroundColor(running.project.wrappedColor)
                        .offset(y: offset(size: geo.size, running: running))
                        /// placeholder styling
                        .opacity(0.5)
                
                }
                ForceRefresh
            }
            .frame(width: geo.size.width)
            
        }
            .onReceive(timer) { _ in loadRunning() }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: loadRunning)
            }
    }
    
    /// calculate appropriate distance to next `entry`
    func offset(size: CGSize, running: RunningEntry) -> CGFloat {
        let scale = size.height / CGFloat(.day * model.days)
        return CGFloat(max(running.start - (Date().midnight - model.castBack), .zero)) * scale
    }
    
    func loadRunning() -> Void {
        /// force a refresh
        meaningless.toggle()
        
        guard let user = cred.user else { return }
        
        #if DEBUG
        print("Fetching running timer")
        #endif
        
        loader.fetchRunningEntry(
            user: user,
            projects: Array(projects),
            context: moc
        )
    }
    
    /**
     A hacky way to force SwiftUI to wake its dopey ass up and redraw the view
     */
    @State var meaningless = false
    
    var ForceRefresh: some View {
        Text(meaningless ? "!" : "?")
            .opacity(0)
            .allowsHitTesting(false)
    }
}
