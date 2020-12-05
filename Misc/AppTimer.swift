//
//  AppTimer.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 5/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import Combine

/** A `Publisher` disguised as an `ObservableObject`
 This hack is borne because `onReceive` is not allowed on `WindowGroup`,
 but `onChange` is, strangely.
 Hence a publisher that periodically changes a value was needed.
 This is desirable so that multiple windows are not collectively clobbering the Toggl servers with periodic requests
 */
class AppTimer: ObservableObject {
    
    var cancellable: AnyCancellable? = nil
    
    @Published var tick: Bool = false
    
    /// how long to wait in seconds before fetching the `RunningTimer` again
    static let runningTimerFetchInterval: TimeInterval = 10
    
    init() {
        cancellable = Timer
            .publish(every: Self.runningTimerFetchInterval, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { _ in
                self.tick.toggle()
            })
    }
}

