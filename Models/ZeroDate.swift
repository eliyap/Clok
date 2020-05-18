//
//  ZeroDate.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.05.17.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

class ZeroDate: ObservableObject {
    // default to 1 week before end of today
    @Published var date:Date = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date())!
        .addingTimeInterval(-7 * 24 * 60 * 60)
}
