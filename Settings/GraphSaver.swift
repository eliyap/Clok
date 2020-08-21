//
//  GraphSaver.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 18/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import Combine

/// Plugs my `EnvironmentObject`s publishers into UserDefaults
final class PrefSaver: ObservableObject {
    
    init(
        zero: ZeroDate,
        model: GraphModel,
        data: TimeData
    ){
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
        self.modeSaver = model.$mode
            .debounce(
                for: .seconds(1),
                scheduler: RunLoop.main
            )
            .sink { mode in
                WorkspaceManager.graphMode = mode.rawValue
            }
        self.projectsSaver = data.$terms
            .debounce(
                for: .seconds(1),
                scheduler: RunLoop.main
            )
            .map { terms in
                terms.projects.map { project in
                    project.wrappedID
                }
            }
            .sink { ids in
                WorkspaceManager.termsProjects = ids
            }
    }
    
    var startSaver: AnyCancellable?
    var zoomSaver: AnyCancellable?
    var modeSaver: AnyCancellable?
    var projectsSaver: AnyCancellable?
}
