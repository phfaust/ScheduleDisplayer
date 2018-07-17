//
//  TableViewCell.swift
//  ScheduleDisplayer
//
//  Created by Fiel Faustino on 15/07/2018.
//  Copyright © 2018 Fiel Faustino. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var channelImg: UIImageView!
    @IBOutlet weak var ratingImg: UIImageView!
    @IBOutlet weak var showName: UILabel!
    @IBOutlet weak var showTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        channelImg.contentMode = UIViewContentMode.scaleAspectFit
        ratingImg.contentMode = UIViewContentMode.right
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
