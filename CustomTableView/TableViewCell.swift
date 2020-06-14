//
//  TableViewCell.swift
//  CustomTableView
//
//  Created by Peter Ent on 12/5/19.
//  Copyright © 2019 Peter Ent. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var subheading: UILabel!
    @IBOutlet weak var tab: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    /**
     fills cell with time entry data
     */
    func populate(entry:TimeEntry) -> Void {
        if entry.description != "" {
            heading.text = entry.description
            heading.isHidden = false
        } else {
            heading.isHidden = true
        }
        
        if let project = entry.project {
            subheading.text = project
            subheading.isHidden = false
        } else {
            subheading.isHidden = true
        }
        
        
        // set the color to the project color
        tab.backgroundColor = entry.project_hex_color.uiColor()
    }
}
