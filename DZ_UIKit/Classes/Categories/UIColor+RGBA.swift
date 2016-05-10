//
//  UIColor+RGBA.swift
//  DZLib
//
//  Created by Dora.Yuan on 2014/10/08.
//  Copyright (c) 2014 Dora.Yuan All rights reserved.
//

import UIKit

let MAX_COLOR_RGB:CGFloat   = 255.0;
let DEFAULT_ALPHA:CGFloat   = 1.0;
let RED_MASK_HEX            = 0x10000;
let GREEN_MASK_HEX          = 0x100;

public func RGB(r:Int, _ g:Int, _ b:Int)
    -> UIColor { return UIColor.colorWithDec(Red:r, Green:g, Blue:b, Alpha:1.0); };

public func RGBA(r:Int, _ g:Int, _ b:Int, _ a:CGFloat)
    -> UIColor { return UIColor.colorWithDec(Red:r, Green:g, Blue:b, Alpha:a); };

public func RGB_HEX(hex:String, _ a:CGFloat)
    -> UIColor { return UIColor.colorWithHex(Hex: hex, Alpha: a); };

extension UIColor {
    
//// MARK: - Color with Hexadecimal ( like )
//    
//    class func colorWithHexRGB(rgb:Int) -> UIColor {
//        let red:Int     = rgb/RED_MASK_HEX;
//        let green:Int   = (rgb%RED_MASK_HEX)/GREEN_MASK_HEX;
//        let blue:Int    = rgb%GREEN_MASK_HEX;
//        return self.colorWithDec(Red: red, Green: green, Blue: blue, Alpha: 1.0);
//    }
    
// MARK: - Color with HEX string (like 3366CC)
    
    class func colorWithHex( Hex hex:String, Alpha alpha:CGFloat ) -> UIColor
    {
        let colorScanner:NSScanner = NSScanner(string: hex);
        var color:uint = 0;
        colorScanner.scanHexInt(&color);
        let r:CGFloat = CGFloat( ( color & 0xFF0000 ) >> 16 ) / 255.0;
        let g:CGFloat = CGFloat( ( color & 0x00FF00 ) >> 8 ) / 255.0;
        let b:CGFloat = CGFloat( color & 0x0000FF ) / 255.0;
        return UIColor(red: r, green: g, blue: b, alpha: alpha);
    }
    
// MARK: - Color with Dec (like red:33 green:66 blue:240)
    
    class func colorWithDec(Red r:Int, Green g:Int, Blue b:Int, Alpha alpha:CGFloat) -> UIColor {
        return UIColor(
            red: CGFloat(r)/MAX_COLOR_RGB,
            green: CGFloat(g)/MAX_COLOR_RGB,
            blue: CGFloat(b)/MAX_COLOR_RGB,
            alpha: alpha
        );
    }
    
    // MARK: - 
    func getGary() -> Int {
        var r: CGFloat = 1.0;
        var g: CGFloat = 1.0;
        var b: CGFloat = 1.0;
        self.getRed(&r, green: &g, blue: &b, alpha: nil);
        let gray = Int(r*255.0*38.0 + g*255.0*75.0 + b*255.0*15.0) >> 7;
        return gray;
    }
}

//let RGB(r,g,b) = UIColor.colorWithDec(r,g,b);
