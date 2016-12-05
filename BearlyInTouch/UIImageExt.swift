//
//  UIImageExt.swift
//  BearlyInTouch
//
//  Created by super on 12/4/16.
//  Copyright © 2016 BearlyInTouch. All rights reserved.
//

import UIKit

public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.CGImage else { return nil }
        self.init(CGImage: cgImage)
    }
}