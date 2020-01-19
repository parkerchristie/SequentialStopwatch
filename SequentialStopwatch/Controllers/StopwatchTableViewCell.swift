//
//  TimerTableViewCell.swift
//  SequentialStopwatch
//
//  Created by Parker Christie on 2019-10-05.
//  Copyright © 2019 Parker Christie. All rights reserved.
//

import UIKit

class StopwatchTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var stopwatchLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
