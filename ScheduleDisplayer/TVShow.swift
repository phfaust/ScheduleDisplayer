//
//  TVShow.swift
//  ScheduleDisplayer
//
//  Created by Fiel Faustino on 17/07/2018.
//  Copyright © 2018 Fiel Faustino. All rights reserved.
//

import Foundation
import UIKit

class TVShow: Decodable {
    var name = ""
    var startTime = ""
    var endTime = ""
    var channel = ""
    var rating = ""
    
    convenience init(name: String, startTime: String, endTime: String, channel: String, rating: String) {
        self.init()
        
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
        self.channel = channel
        self.rating = rating
    }
    
    func getShowImage() -> UIImage {
        var showImg = UIImage()
        
        if (name == "Extreme Frontiers: Canada") {
            showImg = UIImage(named: "Extreme Frontiers Canada")!
        }
        else {
            showImg = UIImage(named: name)!
        }
        
        return showImg
    }
    
    func getRatingImage() -> UIImage {
        guard let ratingImg = UIImage(named: rating) else { return UIImage(named: "NR")! }
        return ratingImg
    }
    
    func getChannelImage() -> UIImage {
        return UIImage(named: channel)!
    }
    
    func getChannelName() -> String {
        var channelName = ""
        
        if (channel == "7Mate") {
            channelName = "7mate"
        }
        else if (channel == "ELEVEN") {
            channelName = "Eleven"
        } else if (channel == "Nine") {
            channelName = "Nine Network"
        }
        else if (channel == "ONE") {
            channelName = "One"
        }
        else if (channel == "Seven") {
            channelName = "Seven Network"
        }
        else if (channel == "TEN") {
            channelName = "Network Ten"
        }
        else {
            channelName = channel
        }
        
        return channelName
    }
}
