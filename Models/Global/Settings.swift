//  Settings.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 28/6/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.

import Foundation

final class Settings: ObservableObject {
    enum Tabs {
        case spiral
        case bar
        case settings
    }
    
    @Published var tab: Tabs = .spiral
    @Published var user: User? = nil
}
