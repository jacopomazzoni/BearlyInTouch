//
//  tools.swift
//  BearlyInTouch
//
//  Created by super on 12/7/16.
//  Copyright © 2016 BearlyInTouch. All rights reserved.
//

import UIKit



class tools {
    // generates a color starting from the lat 3 letters in the user id,
    // collision possible but rare... Possibly use time as well?

    static func idToColor (id: String) -> (UIColor) {
        var rgb = [Float]()
        let dictionary = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        for i in 0...3 {
            let car = String(id[id.startIndex.advancedBy(i)])
            let range: Range<String.Index> = dictionary.rangeOfString(car)!
            let index: Int = dictionary.startIndex.distanceTo(range.startIndex)
            let tmp =  ( Float(index) / Float( dictionary.characters.count ) )
            rgb.append(tmp)
        }
        
        return UIColor(colorLiteralRed: rgb[0], green: rgb[1], blue: rgb[2], alpha: 0.5)
        
        //return UIColor(hue: CGFloat(rgb[1])/4, saturation: 0.55, brightness: 0.69, alpha: 1)
    }
}