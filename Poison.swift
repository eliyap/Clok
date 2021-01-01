//
//  Poison.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 1/1/21.
//  Copyright © 2021 Secret Asian Man 3. All rights reserved.
//

import SwiftUI
import CoreData

final class ClokStackCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        /// set a constraint, value does not matter
        self.heightAnchor.constraint(equalToConstant: .greatestFiniteMagnitude).isActive = true
        self.widthAnchor.constraint(equalToConstant: .greatestFiniteMagnitude).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Defined")
    }
}

fileprivate let spacing: CGFloat = 3

func GenStack(entries: [TimeEntry]) -> (UIStackView, CGFloat) {
    var height: CGFloat = spacing * CGFloat(entries.count - 1)
    let stackView = UIStackView(arrangedSubviews: entries.map{ entry in
        let (view, h) = EntryStack(for: entry)
        height += h
        return view
    })
    stackView.axis = .vertical
    stackView.spacing = 3
    stackView.distribution = .fill
    print(stackView.arrangedSubviews.count, stackView.sizeThatFits(CGSize(width: 1000, height: 1000)))
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return (stackView, height)
}

func EntryStack(for entry: TimeEntry) -> (UIStackView, CGFloat) {
    let descriptionLabel = UILabel()
    descriptionLabel.text = entry.entryDescription
    let projectLabel = UILabel()
    projectLabel.text = entry.projectName ?? StaticProject.NoProject.name
    let topRow = UIStackView(arrangedSubviews: [descriptionLabel, projectLabel])
    topRow.axis = .horizontal
    topRow.distribution = .fill
    return (topRow, descriptionLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).height)
}
