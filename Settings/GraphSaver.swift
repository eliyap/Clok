//
//  GraphSaver.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 18/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import Combine

/// Plugs my `EnvironmentObject` publisher into UserDefaults
final class GraphSaver: ObservableObject {
    
    init(zero: ZeroDate){
        /// save start date to User Defaults
        self.startSaver = zero.$start
            /// debounce to limit the rate we hit User Defaults
            .debounce(
                for: .seconds(1),
                scheduler: RunLoop.main
            )
            .sink { date in
                WorkspaceManager.zeroStart = date
            }
        
        /// save `zoomIdx` date to User Defaults
        self.zoomSaver = zero.$zoomIdx
            /// debounce to limit the rate we hit User Defaults
            .debounce(
                for: .seconds(1),
                scheduler: RunLoop.main
            )
            .sink { index in
                WorkspaceManager.zoomIdx = index
            }
    }
    
    var startSaver: AnyCancellable?
    var zoomSaver: AnyCancellable?
}
