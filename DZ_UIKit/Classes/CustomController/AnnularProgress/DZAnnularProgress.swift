//
//  DZAnnularProgress.swift
//  DZLib
//
//  Created by Dora.Yuan on 2014/11/12.
//  Copyright (c) 2014年 Dora.Yuan All rights reserved.
//
//  参考网站:
//  http://evandavis.me/blog/2013/2/13/getting-creative-with-calayer-masks
//  https://github.com/jdg/MBProgressHUD

//#import <UIKit/UIKit.h>
//
//typedef NS_ENUM(NSInteger, DZAnnularProgressType)
//    {
//        DZAnnularProgressType_None      = 0,
//        DZAnnularProgressType_Percent   = 1<<0,
//        DZAnnularProgressType_Progress  = 1<<1,
//};
//
//typedef NS_ENUM(NSInteger, DZAnnularDisplayType)
//    {
//        DZAnnularDisplayType_None      = 0,
//        DZAnnularDisplayType_Last      = 1<<2, // 剩余量模式（倒数），显示剩余的数值或百分比
//        DZAnnularDisplayType_Complete  = 2<<3, // 完成度模式（正数），显示已经完成的数值或百分比
//};
//
//@interface DZAnnularProgress : UIView
//
//@property (nonatomic, assign) DZAnnularProgressType progressType;
//@property (nonatomic, assign) DZAnnularDisplayType  displayType;
//
//@property (nonatomic, assign) CGFloat maxValue;
//@property (nonatomic, assign) CGFloat currentValue;
//
//@property (nonatomic, assign) CGFloat annularWidth;
//
//@property (nonatomic, strong) UIColor* annularBackColor;
//@property (nonatomic, strong) UIColor* annularFrontColor;
//@property (nonatomic, strong) UIColor* centerCircleColor;
//
//@property (nonatomic, strong) NSString* title;
//@property (nonatomic, strong) UIFont*   titleFont;
//@property (nonatomic, strong) UIColor*  titleColor;
//
//@property (nonatomic, strong) NSString* subTitle;
//@property (nonatomic, strong) UIFont*   subTitleFont;
//@property (nonatomic, strong) UIColor*  subTitleColor;
//
//// init with Radius
//- (id) initWithOuterRadius:(CGFloat)outerRadius innerRadius:(CGFloat)innerRadius type:(DZAnnularProgressType)type;
//
//// init with Diameter
//- (id) initWithOuterDiameter:(CGFloat)outerDiameter innerDiameter:(CGFloat)innerDiameter type:(DZAnnularProgressType)type;
//
//// init with frame and annularWidth
//- (id) initWithFrame:(CGRect)frame annularWidth:(CGFloat)annularWidth type:(DZAnnularProgressType)type;
//
//@end

import Foundation
import UIKit


let WIDTH_BETWEEN_ANNULAR_AND_CIRCLE: CGFloat = 3.0;

public enum AnnularProgressType: Int {
    case None       = 0;
    case Percent    = 1;
    case Progress   = 2;
}

public enum AnnularDisplayType: Int {
    case None      = 0;
    case Last      = 1; // 剩余量模式（倒数），显示剩余的数值或百分比
    case Complete  = 2; // 完成度模式（正数），显示已经完成的数值或百分比
}

public class DZAnnularProgress: UIView {
    
    // MARK: - properties
    
    public var progressType: AnnularProgressType   = AnnularProgressType.None;
    public var displayType: AnnularDisplayType     = AnnularDisplayType.None;
    
    public var maxValue: CGFloat            = 100.0 { didSet { self.setNeedsDisplay(); } };
    public var currectValue: CGFloat        = 0.0  { didSet { self.setNeedsDisplay(); } };
    
    public var annularWidth: CGFloat        = 8.0;
    
    public var annularBackColor: UIColor    = UIColor.whiteColor();
    public var annularFrontColor: UIColor   = UIColor.whiteColor();
    public var centerCircleColor: UIColor   = UIColor.whiteColor();
    
    public var title: String                = "";
    public var titleFont: UIFont            = UIFont.systemFontOfSize(16.0);
    public var titleColor: UIColor          = UIColor.darkTextColor();
    
    public var subtitle: String             = "";
    public var subtitleFont: UIFont         = UIFont.systemFontOfSize(12.0);
    public var subtitleColor: UIColor       = UIColor.darkTextColor();
    
    
    public var INNER_CIRCLE_DIAMETER:CGFloat {
        get { return (self.frame.size.width - (self.annularWidth*2.0) - 6.0) }
    };
    
    // MARK: - init functions
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
//        fatalError("init(coder:) has not been implemented")
    }
    
    public class func initWithOuterRadius(outerRadius: CGFloat, InnerRadius innerRadius: CGFloat, Type type: AnnularProgressType) -> DZAnnularProgress {
        let outerDiameter = outerRadius * 2.0;
        let innerDiameter = innerRadius * 2.0;
        return DZAnnularProgress.initWithOuterDiameter(outerDiameter, InnerDiameter: innerDiameter, Type: type);
    }
    
    public class func initWithOuterDiameter(outerDiameter: CGFloat, InnerDiameter innerDiameter: CGFloat, Type type: AnnularProgressType) -> DZAnnularProgress {
        let frame: CGRect           = CGRectMake(0, 0, outerDiameter, outerDiameter);
        let annularWidth: CGFloat   = outerDiameter/2.0 - innerDiameter/2.0;
        return DZAnnularProgress(Frame: frame, AnnularWidth: annularWidth, Type: type);
    }
    
    public init(Frame frame: CGRect, AnnularWidth annularWidth: CGFloat, Type type: AnnularProgressType) {
        super.init(frame: frame);
        
        self.progressType       = type;
        self.annularWidth       = annularWidth;
        self.backgroundColor    = UIColor.clearColor();
    }
    
    // MARK: - life cycle
    public override func didMoveToSuperview() {
    }
    
    public override func layoutSubviews() {
        //
        DebugLog("DZAnnularProgress layoutSubviews", self.frame.width, self.frame.height);
        super.layoutSubviews();
    }
    
    public override func drawRect(rect: CGRect) {
        DebugLog("DZAnnularProgress drawRect", self.frame.width, self.frame.height);
        // draw annular background color
        let lineWidth: CGFloat = self.annularWidth;
        let processBackgroundPath: UIBezierPath = UIBezierPath();
        processBackgroundPath.lineWidth         = lineWidth;
        processBackgroundPath.lineCapStyle      = CGLineCap.Butt;
        let center: CGPoint     = CGPointMake(self.bounds.width / 2, self.bounds.height / 2);
        let radius: CGFloat     = (self.bounds.width - lineWidth) / 2;
        var startAngle: CGFloat = ((self.currectValue/self.maxValue) * 2 * CGFloat(M_PI)) - (CGFloat(M_PI) / 2); // + startAngle;
        var endAngle: CGFloat   = (2 * CGFloat(M_PI)) - (CGFloat(M_PI) / 2);// + startAngle;
        processBackgroundPath.addArcWithCenter(center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true);
        self.annularBackColor.set();
        processBackgroundPath.stroke();
        
        // draw progress
        let processPath = UIBezierPath();
        processPath.lineWidth       = lineWidth;
        processPath.lineCapStyle    = CGLineCap.Butt;
        startAngle                  = -(CGFloat(M_PI) / 2);
        endAngle                    = ((self.currectValue/self.maxValue) * 2 * CGFloat(M_PI)) + startAngle;
        processPath.addArcWithCenter(center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true);
        self.annularFrontColor.set();
        processPath.stroke();
        
        // draw center circle
        let context: CGContextRef = UIGraphicsGetCurrentContext()!;
        CGContextSetLineWidth(context, 2.0);
        
        switch self.progressType {
        case .Percent :
            let per: CGFloat = (self.currectValue/self.maxValue) * 100
            self.title = "\(per)%";
            let titleRect: CGRect = CGRectMake(self.annularWidth + WIDTH_BETWEEN_ANNULAR_AND_CIRCLE,
                self.annularWidth + WIDTH_BETWEEN_ANNULAR_AND_CIRCLE + INNER_CIRCLE_DIAMETER/4.0,
                INNER_CIRCLE_DIAMETER,
                INNER_CIRCLE_DIAMETER/2.0);
            self.titleColor.set();
            let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle();
            paragraphStyle.lineBreakMode = NSLineBreakMode.ByClipping;
            paragraphStyle.alignment = NSTextAlignment.Center;
            (self.title as NSString).drawInRect(titleRect, withAttributes:[NSFontAttributeName: self.titleFont, NSParagraphStyleAttributeName: paragraphStyle])
            break;
        case .Progress :
            self.title = "\(self.currectValue)";
            let titleRect = CGRectMake(self.annularWidth + WIDTH_BETWEEN_ANNULAR_AND_CIRCLE,
                self.annularWidth + WIDTH_BETWEEN_ANNULAR_AND_CIRCLE,
                INNER_CIRCLE_DIAMETER,
                INNER_CIRCLE_DIAMETER/2.0);
            let subtitleRect = CGRectMake(self.annularWidth + WIDTH_BETWEEN_ANNULAR_AND_CIRCLE,
                self.annularWidth + INNER_CIRCLE_DIAMETER/2.0 + WIDTH_BETWEEN_ANNULAR_AND_CIRCLE,
                INNER_CIRCLE_DIAMETER,
                INNER_CIRCLE_DIAMETER/2.0);
            UIColor.whiteColor().set();
            let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle();
            paragraphStyle.lineBreakMode = NSLineBreakMode.ByClipping;
            paragraphStyle.alignment = NSTextAlignment.Center;
            (self.title as NSString).drawInRect(titleRect, withAttributes:[NSFontAttributeName: self.titleFont, NSParagraphStyleAttributeName: paragraphStyle])// darw subtitle
            (self.subtitle as NSString).drawInRect(subtitleRect, withAttributes: [NSFontAttributeName: self.subtitleFont, NSParagraphStyleAttributeName: paragraphStyle]);
            break;
        default :
            break;
        }
    }
    
}
