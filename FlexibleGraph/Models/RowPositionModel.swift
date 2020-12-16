//
//  RowPositionModel.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 3/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct RowPositionModel: Equatable {
    var row: Int
    var position: UnitPoint

    static let zero = RowPositionModel(row: .zero, position: .zero)
}
