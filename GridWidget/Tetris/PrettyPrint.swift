//
//  PrettyPrint.swift
//  ClokWidgetExtension
//
//  Created by Secret Asian Man Dev on 6/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

func prettyPrint(_ bools: [[Bool]]) -> String {
    bools.map { row in
        row.map {
            $0 ? "●" : "○"
        }.joined(separator: " ")
    }.joined(separator: "\n")
}
