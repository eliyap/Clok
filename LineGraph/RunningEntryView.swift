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
                    Rect(size: geo.size, running: running)
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
    
    private func loadRunning() -> Void {
        guard let user = cred.user else { return }
        #if DEBUG
        print("Fetching running timer")
        #endif
        cancellable = RunningEntryLoader.fetchRunningEntry(
            user: user,
            projects: Array(projects),
            context: moc
        )
        .assign(to: \.running, on: self)
    }
    
    func Rect(size: CGSize, running: RunningEntry) -> some View {
        let scale = size.height / CGFloat(.day * model.days)
        
        /// calculate appropriate distance to next `entry`
        let offset = CGFloat(max(running.start - (Date().midnight - model.castBack), .zero)) * scale
        
        return EntryRect(
            range: (running.start, Date()),
            size: size,
            midnight: Date().midnight
        )
            .foregroundColor(running.project.wrappedColor)
            .offset(y: offset)
    }
}
