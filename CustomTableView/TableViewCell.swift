//
//  TableViewCell.swift
//  CustomTableView
//
//  Created by Peter Ent on 12/5/19.
//  Copyright © 2019 Peter Ent. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var description_: UILabel!
    @IBOutlet weak var project: UILabel!
    @IBOutlet weak var tab: UIView!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var startEnd: UILabel!
    
    private let df = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        df.timeStyle = .short
    }

    /**
     fills cell with time entry data
     */
    func populate(entry:TimeEntry) -> Void {
        /// placeholder empty labels
        if entry.description != "" {
            description_.text = entry.description
            description_.textColor = UIColor.label
        } else {
            description_.text = NSLocalizedString(
                "No Description",
                comment: "Placeholder for time entries without description"
            )
            description_.textColor = UIColor.placeholderText
        }
        
        project.text = entry.project.name
        project.isHidden = (entry.project == .noProject)
        
        duration.text = entry.dur.toString()
        startEnd.text = "\(df.string(from: entry.start)) – \(df.string(from: entry.end))"
        
        /// set project color
        tab.backgroundColor = entry.project.color.uiColor()
    }
}
