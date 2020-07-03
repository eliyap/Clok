//
//  Orientation.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 3/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

extension GeometryProxy {
    enum orientation {
        case landscape
        case portrait
    }
    func orientation() -> orientation {
        size.height > size.width ? .portrait : .landscape
    }
}

final class Bounds: ObservableObject {
    @Published var mode =  GeometryProxy.orientation.portrait
    @Published var notch = false
}
