//
//  UIImage+Color.swift
//  DZ_UIKit
//
//  Created by Dora.Yuan on 2014/10/08.
//  Copyright (c) 2014 Dora.Yuan All rights reserved.
//

import UIKit

extension UIImage {
    
// MARK: - Make image from color

    class func imageWithColor( _ color:UIColor ) -> UIImage
    {
        let size = CGSize(width: 1, height: 1);
        let image = UIImage.imageWithColor(color, size: size);
        return image;
    }
    
    class func imageWithColor( _ color:UIColor, size: CGSize ) -> UIImage
    {
        let rect:CGRect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height);
        UIGraphicsBeginImageContext(rect.size);
        let context:CGContext = UIGraphicsGetCurrentContext()!;
        
        context.setFillColor(color.cgColor);
        context.fill(rect);
        
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        
        return image;
    }
}
