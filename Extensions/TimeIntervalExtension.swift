//
//  TimeIntervalExtension.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.14.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension TimeInterval {
    func toString() -> String {
        let seconds = Int(self)
        let hh:Int = seconds / 3600
        let mm:Int = (seconds % 3600) / 60
        let ss:Int = seconds % 60
        return String(format: "%d:%02d:%02d", hh,mm,ss)
    }
}
