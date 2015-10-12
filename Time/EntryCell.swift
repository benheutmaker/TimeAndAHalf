//
//  EntryCell.swift
//  Time
//
//  Created by Benjamin Heutmaker on 8/7/15.
//  Copyright © 2015 Benjamin Heutmaker. All rights reserved.
//

import UIKit

class EntryCell: UITableViewCell {
    
    @IBOutlet var startTimeLabel: UILabel!
    @IBOutlet var endTimeLabel: UILabel!
    
    @IBOutlet var totalTimeLabel: UILabel!
    @IBOutlet var totalEarningsLabel: UILabel!
    
    @IBOutlet var colorView: UIView!
    
    override func setSelected(selected: Bool, animated: Bool) {
        let color = colorView.backgroundColor
        super.setSelected(selected, animated: animated)
        
        if(selected) {
            colorView.backgroundColor = color
        }
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        let color = colorView.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        
        if(highlighted) {
            colorView.backgroundColor = color
        }
    }
}
