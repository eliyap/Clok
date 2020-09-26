//
//  WidgetView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 3/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

fileprivate let strokeStyle = StrokeStyle(
    lineWidth: 4,
    lineCap: .round
)

struct ClokWidgetEntryView : View {
    
    @Environment(\.widgetFamily) var family
    
    var entry: SummaryEntry
    
    var body: some View {
        HStack {
            switch family {
            case .systemMedium:
                TripleRing()
                TripleLabel()
                
            default:
                TripleRing()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(10)
    }
    
    func TripleLabel() -> some View {
        let (p1, p2, p3) = top3()
        func nameLabel(_ p: Summary.Project) -> some View {
            Text(p.name)
                .foregroundColor(p.color)
                .font(.system(.title, design: .rounded))
                .bold()
        }
        func timeLabel(_ p: Summary.Project) -> some View {
            let hours = Int(p.duration / .hour)
            let mins = Int(p.duration.mod(.hour) / 60)
            return Text(String(format: "%d:%02d", hours, mins))
                .foregroundColor(p.color)
                .font(.system(.title, design: .rounded))
                .bold()
        }
        return Group {
            Spacer()
            VStack(alignment: .trailing) {
                timeLabel(p1)
                timeLabel(p2)
                timeLabel(p3)
            }
            VStack(alignment: .leading) {
                nameLabel(p1)
                nameLabel(p2)
                nameLabel(p3)
            }
            
        }
    }
    
    func TripleRing() -> some View {
        let (p1, p2, p3) = top3()
        return GeometryReader { geo in
            ZStack {
                ShadowRing(p1, weight: 15, beadAngle: 0.25)
                ShadowRing(p2, weight: 12, beadAngle: 0.32)
                    .frame(
                        width: geo.size.width * 0.67,
                        height: geo.size.height * 0.67
                    )
                ShadowRing(p3, weight: 10, beadAngle: 0.5)
                    .frame(
                        width: geo.size.width * 0.4,
                        height: geo.size.height * 0.4
                    )
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    /// returns the `count` projects in descending order duration
    /// if there are fewer than `count` projects, the array is padded with nils
    func top3() -> (Summary.Project, Summary.Project, Summary.Project) {
        var result: (Summary.Project, Summary.Project, Summary.Project) = (.empty, .empty, .empty)
        /// sort projects by duration
        var projs = entry.summary.projects.sorted(by: {$0.duration > $1.duration})
        
        /// try to match first ID
        if
            let pid1 = entry.pid1,
            let match = projs.firstIndex(where: {$0.id == pid1})
        {
            result.0 = projs[match]
            projs.remove(at: match)
        } else if !projs.isEmpty {
            result.0 = projs.first!
            projs.removeFirst()
        }

        
        /// try to match second ID
        if
            let pid2 = entry.pid2,
            let match = projs.firstIndex(where: {$0.id == pid2})
        {
            result.1 = projs[match]
            projs.remove(at: match)
        } else if !projs.isEmpty {
            result.1 = projs.first!
            projs.removeFirst()
        }

        /// try to match third ID
        if
            let pid3 = entry.pid3,
            let match = projs.firstIndex(where: {$0.id == pid3})
        {
            result.2 = projs[match]
            projs.remove(at: match)
        } else if !projs.isEmpty {
            result.2 = projs.first!
            projs.removeFirst()
        }

        return result
    }
}
