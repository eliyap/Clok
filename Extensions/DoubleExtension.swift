//
//  DoubleExtension.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.18.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
extension Array where Element == Double {
    /// simple mean calculation
    func mean() -> Double {
        self.reduce(0.0, {$0 + $1}) / Double(self.count)
    }
}
