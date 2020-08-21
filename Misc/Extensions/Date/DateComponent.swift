//
//  DateComponent.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 20/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

/**
 I'm so sick of getting components this way
 */
extension Date {
    var minute: Int {
        Calendar.current.component(.minute, from: self)
    }
    
    var hour: Int {
        Calendar.current.component(.hour, from: self)
    }
    var month: Int {
        Calendar.current.component(.month, from: self)
    }
    
    var year: Int {
        Calendar.current.component(.year, from: self)
    }
    var midnight: Date {
        Calendar.current.startOfDay(for: self)
    }
}
