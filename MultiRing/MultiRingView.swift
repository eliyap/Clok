//
//  MultiRing.swift
//  MultiRing
//
//  Created by Secret Asian Man 3 on 20.09.25.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

fileprivate let padded = CGFloat(10)
fileprivate let spaced = CGFloat(5)

struct MultiRingEntryView : View {
    
    @Environment(\.widgetFamily) var family
    
    var entry: Provider.Entry

    var body: some View {
        HStack {
            switch family {
            case .systemSmall:
                Grid4(topN[0], topN[1], topN[2], topN[3])
            case .systemMedium:
                ProjectRing(topN[0], size: .large)
                Grid4(topN[1], topN[2], topN[3], topN[4])
            case .systemLarge:
                Grid4(topN[0], topN[1], topN[2], topN[3])
            }
            
        }
        .padding(padded)
    }
    
    func Grid4(
        _ p1: Summary.Project?,
        _ p2: Summary.Project?,
        _ p3: Summary.Project?,
        _ p4: Summary.Project?
    ) -> some View {
        VStack(spacing: spaced) {
            HStack(spacing: spaced) {
                ProjectRing(p1)
                ProjectRing(p2)
            }
            HStack(spacing: spaced) {
                ProjectRing(p3)
                ProjectRing(p4)
            }
        }
    }
}

// MARK: - How many rings to show
extension MultiRingEntryView {
    var ringCount: Int {
        switch family {
        case .systemSmall:
            return 4
        case .systemMedium:
            return 8
        case .systemLarge:
            return 16
        @unknown default:
            fatalError()
        }
    }
    
    /// return exactly enough projects, padded with `empty`s to make the count
    var topN: [Summary.Project?] {
        /// sorted by duration and padded with enough `empty`s
        let projs = entry.projects.sorted(by: {$0.duration > $1.duration})
            + Array(repeating: nil, count: ringCount)
        return Array(projs[0..<ringCount])
    }
}
