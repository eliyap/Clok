//
//  GraphCell.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 1/1/21.
//  Copyright © 2021 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

final class ClokGraphCell: UITableViewCell {
    
    var host: UIHostingController<TempDayGraph>?
    var idx: Int?
    var start: Date?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        /// set a constraint, value does not matter
        self.heightAnchor.constraint(equalToConstant: .greatestFiniteMagnitude).isActive = true
        self.widthAnchor.constraint(equalToConstant: .greatestFiniteMagnitude).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Implemented")
    }
    
}

struct TempDayGraph: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let entries: [TimeEntry]
    let start: Date
    let size: CGSize
    
    var body: some View {
        ZStack {
            ForEach(entries, id: \.id) { entry in
                entry.color(in: colorScheme)
                    /// push `View` down to `(proportion through the day x height)`
                    .offset(y: CGFloat((entry.start - start) / .day) * size.height)
                
                    .frame(height: size.height * CGFloat(entry.dur / .day))
                    
            }
                .frame(maxWidth: size.width, minHeight: size.height, alignment: .top)
        }
    }
}
