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
        GeometryReader { geo in
            LazyVGrid(columns: cols(size: geo.size), spacing: spaced) {
                ForEach(topN.compactMap({$0}), id: \.id) { project in
                    ProjectRing(project)
                        .frame(maxHeight: rowHeight(geo.size))
                }
            }
        }
        .padding(padded)
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

// MARK: - Row Division
extension MultiRingEntryView {
    
    var numCols: Int {
        switch family {
        case .systemSmall:
            return 2
        case .systemMedium:
            return 4
        case .systemLarge:
            return 4
        @unknown default:
            fatalError()
        }
    }
    
    var numRows: Int {
        switch family {
        case .systemSmall:
            return 2
        case .systemMedium:
            return 2
        case .systemLarge:
            return 4
        @unknown default:
            fatalError()
        }
    }
    
    func colWidth(_ size: CGSize) -> CGFloat {
        (size.width - spaced * CGFloat(numCols - 1)) / CGFloat(numCols)
    }
    
    func rowHeight(_ size: CGSize) -> CGFloat {
        (size.height - spaced * CGFloat(numRows - 1)) / CGFloat(numRows)
    }
    
    func cols(size: CGSize) -> [GridItem] {
        Array(
            repeating: GridItem(.fixed(colWidth(size)), spacing: spaced),
            count: numCols
        )
    }
}
