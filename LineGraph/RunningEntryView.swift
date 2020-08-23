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
                        .foregroundColor(running.project.wrappedColor)
                        .offset(y: offset(size: geo.size))
                        /// placeholder styling
                        .opacity(0.5)
                
                } else {
                    EmptyView()
                }
            }
            .frame(width: geo.size.width)
            
        }
            .onReceive(timer) { _ in loadRunning() }
            .onAppear(perform: loadRunning)
    }
    
    /// calculate appropriate distance to next `entry`
    func offset(size: CGSize) -> CGFloat {
        let scale = size.height / CGFloat(.day * model.days)
        guard let running = running else { return .zero }
        return CGFloat(max(running.start - (Date().midnight - model.castBack), .zero)) * scale
    }
    
    func loadRunning() -> Void {
        guard let user = cred.user else { return }
        #if DEBUG
        print("Fetching running timer")
        #endif
        cancellable = RunningEntryLoader().fetchRunningEntry(
            user: user,
            projects: Array(projects),
            context: moc
        )
        .assign(to: \.running, on: self)
    }
}