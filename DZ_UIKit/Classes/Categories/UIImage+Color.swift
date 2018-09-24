//
//  UIImage+Color.swift
//  DZ_UIKit
//
//  Created by Dora.Yuan on 2014/10/08.
//  Copyright (c) 2014 Dora.Yuan All rights reserved.
//

import UIKit

enum GradientDirection: String {
    case vertical   = "vertical"
    case horizontal = "horizontal"
}

extension UIImage {
    
    /// Make image from color
    public class func imageWithColor( _ color:UIColor, size: CGSize? = nil) -> UIImage {
        var rect:CGRect;
        if let _size = size {
            rect = CGRect(x: 0.0, y: 0.0, width: _size.width, height: _size.height);
        }
        else {
            rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0);
        }
        UIGraphicsBeginImageContext(rect.size);
        let context:CGContext = UIGraphicsGetCurrentContext()!;
        
        context.setFillColor(color.cgColor);
        context.fill(rect);
        
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        
        return image;
    }
    
    /// Make image with layer
    ///
    /// - Parameter layer: layer
    /// - Returns: Image(UIImage)
    class func imageWithLayer(layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0);
        layer.render(in: UIGraphicsGetCurrentContext()!);
        let outputImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return outputImage!;
    }
    
    /// Make image with gradient
    /// default size is 64x64
    ///
    /// - Parameters:
    ///   - direction: direction(GradientDirection.horizontal or .vertical
    ///   - colors: colors(CGColor)
    /// - Returns: UIImage
    class func imageWithGradient(direction: GradientDirection = .horizontal, colors: CGColor...) -> UIImage {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 64, height: 64));
        gradient.colors = colors;
        switch direction {
        case .horizontal:
            gradient.startPoint = CGPoint(x: 0, y: 0.5);
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
        case .vertical:
            gradient.startPoint = CGPoint(x: 0.5, y: 0);
            gradient.endPoint = CGPoint(x: 0.5, y: 1)
        }
        let outputImage = UIImage.imageWithLayer(layer: gradient);
        return outputImage;
    }
}
