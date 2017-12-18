//
//  UIColor+RGBA.swift
//  DZ_UIKit
//
//  Created by Dora.Yuan on 2014/10/08.
//  Copyright (c) 2014 Dora.Yuan All rights reserved.
//

import UIKit

let MAX_COLOR_RGB:CGFloat   = 255.0;
let DEFAULT_ALPHA:CGFloat   = 1.0;
let RED_MASK_HEX            = 0x10000;
let GREEN_MASK_HEX          = 0x100;

public func RGB(_ r:Int, _ g:Int, _ b:Int)
    -> UIColor { return UIColor.colorWithDec(Red:r, Green:g, Blue:b, Alpha:1.0); };

public func RGBA(_ r:Int, _ g:Int, _ b:Int, _ a:CGFloat)
    -> UIColor { return UIColor.colorWithDec(Red:r, Green:g, Blue:b, Alpha:a); };

public func RGB_HEX(_ hex:String, _ a:CGFloat)
    -> UIColor { return UIColor.colorWithHex(Hex: hex, Alpha: a); };

extension UIColor {
    
// MARK: - Color with HEX string (like 3366CC)
    
    /**
     Create and return a color object with HEX string (like "3366CC") and alpha (0.0 ~ 1.0)
     - Parameters hex: HEX string
     - Parameters alpha: alpha
     - Return: color
     */
    fileprivate class func colorWithHex( Hex hex:String, Alpha alpha:CGFloat ) -> UIColor {
        let colorScanner:Scanner = Scanner(string: hex);
        var color:uint = 0;
        colorScanner.scanHexInt32(&color);
        let r:CGFloat = CGFloat( ( color & 0xFF0000 ) >> 16 ) / 255.0;
        let g:CGFloat = CGFloat( ( color & 0x00FF00 ) >> 8 ) / 255.0;
        let b:CGFloat = CGFloat( color & 0x0000FF ) / 255.0;
        return UIColor(red: r, green: g, blue: b, alpha: alpha);
    }
    
// MARK: - Color with Dec (like r:33 g:66 b:240)
    
    /**
     Create and return a color object with red, green, blue (0 ~ 255) and alpha (0.0 ~ 1.0)
     - Parameters Red: red (0 ~ 255)
     - Parameters Green: green (0 ~ 255)
     - Parameters Blue: blue (0 ~ 255)
     - Parameters Alpha: alpha ( 0.0 ~ 1.0 )
     - Return: color
     */
    fileprivate class func colorWithDec(Red r:Int, Green g:Int, Blue b:Int, Alpha alpha:CGFloat) -> UIColor {
        return UIColor(
            red: CGFloat(r)/MAX_COLOR_RGB,
            green: CGFloat(g)/MAX_COLOR_RGB,
            blue: CGFloat(b)/MAX_COLOR_RGB,
            alpha: alpha
        );
    }
    
// MARK: - Gray
    
    /**
     Return gray level of the color object
     - Return: gray color
     */
    public func getGary() -> Int {
        var r: CGFloat = 1.0;
        var g: CGFloat = 1.0;
        var b: CGFloat = 1.0;
        var a: CGFloat = 1.0;
        self.getRed(&r, green: &g, blue: &b, alpha: &a);
        var gray = Int(r*255.0*38.0 + g*255.0*75.0 + b*255.0*15.0) >> 7;
        gray = Int(ceil(CGFloat(gray) * a));
        return gray;
    }
}
