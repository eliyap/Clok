//
//  NamespacEnvironmentKey.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 1/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

struct NamespaceID: EnvironmentKey {
    static var defaultValue = Namespace().wrappedValue
}

extension EnvironmentValues {
    var namespace: Namespace.ID {
        get { self[NamespaceID.self] }
        set { self[NamespaceID.self] = newValue }
    }
}
