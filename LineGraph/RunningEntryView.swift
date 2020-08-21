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
fileprivate let interval = TimeInterval(60)

struct RunningEntryView: View {
    @EnvironmentObject var cred: Credentials
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Project.entity(), sortDescriptors: []) var projects: FetchedResults<Project>
    let timer = Timer.publish(every: interval, on: .main, in: .common).autoconnect()
    @State var running: RunningEntry? = nil
    @State var cancellable: AnyCancellable? = nil
    
    var body: some View {
        Text("")
            .onReceive(timer) { _ in
                guard let user = cred.user else { return }
                cancellable = RunningEntryLoader().fetchRunningEntry(
                    user: user,
                    projects: Array(projects),
                    context: moc
                )
                .assign(to: \.running, on: self)
            }
    }
}
