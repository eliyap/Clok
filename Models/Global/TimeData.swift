//
//  Data.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import Combine
import CoreData

final class TimeData: ObservableObject {
    
    init(projects: [Project]){
        /// get the matching `Project` or `StaticProject`
        self.terms.projects = WorkspaceManager.termsProjects.compactMap { (id: Int) -> ProjectLike? in
            (projects.map{ProjectLike.project($0)} + StaticProject.all.map{ProjectLike.special($0)})
                .first(where: {$0.id == id})
        }
    }
    
    /// the `Project`s the user is filtering for
    @Published var terms = SearchTerms()
}
