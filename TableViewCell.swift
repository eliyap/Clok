//
//  TableViewCell.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 1/1/21.
//  Copyright © 2021 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

final class ClokTableCell: UITableViewCell {
    
    var host: UIHostingController<AnyView> = UIHostingController(rootView: AnyView(EmptyView()))
    var idx: Int?
    var start: Date?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(host.view)
        
        /// set a constraint, value does not matter
        self.heightAnchor.constraint(equalToConstant: .greatestFiniteMagnitude).isActive = true
        self.widthAnchor.constraint(equalToConstant: .greatestFiniteMagnitude).isActive = true
        host.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Implemented")
    }
    
}


struct TempListView: View {
    
    /// light / dark mode
    @Environment(\.colorScheme) var colorScheme
    
    var entries: [TimeEntry]
    var size: CGSize
    
    var body: some View {
        VStack {
            ForEach(entries, id: \.id) { entry in
                VStack(alignment: .leading) {
                    HStack {
                        Text(entry.entryDescription)
                            .lineLimit(1)
                        Spacer()
                        Text(entry.projectName ?? StaticProject.NoProject.name)
                            .lineLimit(1)
                    }
//                    Spacer()
                    if type(of: entry) == TimeEntry.self {
                        Text(entry.duration.toString())
                    }
                }
                    .padding(3)
                    .background(entry.color(in: colorScheme))
            }
        }
        .frame(width: size.width)
        .border(Color.red)
    }
}
