//
//  UIImage+Color.swift
//  DZLib
//
//  Created by Dora.Yuan on 2014/10/08.
//  Copyright (c) 2014 Dora.Yuan All rights reserved.
//

import UIKit

extension UIImage {
    
// MARK: - Make image from color

    class func imageWithColor( color:UIColor ) -> UIImage
    {
        let size = CGSizeMake(1, 1);
        let image = UIImage.imageWithColor(color, size: size);
        return image;
    }
    
    class func imageWithColor( color:UIColor, size: CGSize ) -> UIImage
    {
        let rect:CGRect = CGRectMake(0.0, 0.0, size.width, size.height);
        UIGraphicsBeginImageContext(rect.size);
        let context:CGContextRef = UIGraphicsGetCurrentContext()!;
        
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
        
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }
}