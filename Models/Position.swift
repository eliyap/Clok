//
//  Position.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.05.17.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

class ListPosition: ObservableObject {
    @Published var position:CGFloat = 0 
}

class ListRow: ObservableObject {
    @Published var row:Int = NSNotFound
}
