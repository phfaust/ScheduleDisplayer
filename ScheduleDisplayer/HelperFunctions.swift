//
//  HelperFunctions.swift
//  ScheduleDisplayer
//
//  Created by Fiel Faustino on 17/07/2018.
//  Copyright © 2018 Fiel Faustino. All rights reserved.
//

import Foundation
import UIKit

class HelperFunctions {
    static func scaleImagetoHeight(image: UIImage, desiredHeight: CGFloat) -> UIImage{
        let imageSize = image.size
        
        let imageRatio = imageSize.width / imageSize.height
        
        let newSize = CGSize(width: imageRatio * desiredHeight, height: desiredHeight)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 50.0)
        image.draw(in: rect)
        
        let scaledImg = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return scaledImg!
    }
}
