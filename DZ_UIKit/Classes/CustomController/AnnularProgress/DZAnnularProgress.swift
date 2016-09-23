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
    case none       = 0;
    case percent    = 1;
    case progress   = 2;
}

public enum AnnularDisplayType: Int {
    case none      = 0;
    case last      = 1; // 剩余量模式（倒数），显示剩余的数值或百分比
    case complete  = 2; // 完成度模式（正数），显示已经完成的数值或百分比
}

open class DZAnnularProgress: UIView {
    
    // MARK: - properties
    
    open var progressType: AnnularProgressType   = AnnularProgressType.none;
    open var displayType: AnnularDisplayType     = AnnularDisplayType.none;
    
    open var maxValue: CGFloat            = 100.0 { didSet { self.setNeedsDisplay(); } };
    open var currectValue: CGFloat        = 0.0  { didSet { self.setNeedsDisplay(); } };
    
    open var annularWidth: CGFloat        = 8.0;
    
    open var annularBackColor: UIColor    = UIColor.white;
    open var annularFrontColor: UIColor   = UIColor.white;
    open var centerCircleColor: UIColor   = UIColor.white;
    
    open var title: String                = "";
    open var titleFont: UIFont            = UIFont.systemFont(ofSize: 16.0);
    open var titleColor: UIColor          = UIColor.darkText;
    
    open var subtitle: String             = "";
    open var subtitleFont: UIFont         = UIFont.systemFont(ofSize: 12.0);
    open var subtitleColor: UIColor       = UIColor.darkText;
    
    
    open var INNER_CIRCLE_DIAMETER:CGFloat {
        get { return (self.frame.size.width - (self.annularWidth*2.0) - 6.0) }
    };
    
    // MARK: - init functions
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
//        fatalError("init(coder:) has not been implemented")
    }
    
    open class func initWithOuterRadius(_ outerRadius: CGFloat, InnerRadius innerRadius: CGFloat, Type type: AnnularProgressType) -> DZAnnularProgress {
        let outerDiameter = outerRadius * 2.0;
        let innerDiameter = innerRadius * 2.0;
        return DZAnnularProgress.initWithOuterDiameter(outerDiameter, InnerDiameter: innerDiameter, Type: type);
    }
    
    open class func initWithOuterDiameter(_ outerDiameter: CGFloat, InnerDiameter innerDiameter: CGFloat, Type type: AnnularProgressType) -> DZAnnularProgress {
        let frame: CGRect           = CGRect(x: 0, y: 0, width: outerDiameter, height: outerDiameter);
        let annularWidth: CGFloat   = outerDiameter/2.0 - innerDiameter/2.0;
        return DZAnnularProgress(Frame: frame, AnnularWidth: annularWidth, Type: type);
    }
    
    public init(Frame frame: CGRect, AnnularWidth annularWidth: CGFloat, Type type: AnnularProgressType) {
        super.init(frame: frame);
        
        self.progressType       = type;
        self.annularWidth       = annularWidth;
        self.backgroundColor    = UIColor.clear;
    }
    
    // MARK: - life cycle
    open override func didMoveToSuperview() {
    }
    
    open override func layoutSubviews() {
        //
        DebugLog("DZAnnularProgress layoutSubviews" as AnyObject, self.frame.width as AnyObject, self.frame.height as AnyObject);
        super.layoutSubviews();
    }
    
    open override func draw(_ rect: CGRect) {
        DebugLog("DZAnnularProgress drawRect" as AnyObject, self.frame.width as AnyObject, self.frame.height as AnyObject);
        // draw annular background color
        let lineWidth: CGFloat = self.annularWidth;
        let processBackgroundPath: UIBezierPath = UIBezierPath();
        processBackgroundPath.lineWidth         = lineWidth;
        processBackgroundPath.lineCapStyle      = CGLineCap.butt;
        let center: CGPoint     = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2);
        let radius: CGFloat     = (self.bounds.width - lineWidth) / 2;
        var startAngle: CGFloat = ((self.currectValue/self.maxValue) * 2 * CGFloat(M_PI)) - (CGFloat(M_PI) / 2); // + startAngle;
        var endAngle: CGFloat   = (2 * CGFloat(M_PI)) - (CGFloat(M_PI) / 2);// + startAngle;
        processBackgroundPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true);
        self.annularBackColor.set();
        processBackgroundPath.stroke();
        
        // draw progress
        let processPath = UIBezierPath();
        processPath.lineWidth       = lineWidth;
        processPath.lineCapStyle    = CGLineCap.butt;
        startAngle                  = -(CGFloat(M_PI) / 2);
        endAngle                    = ((self.currectValue/self.maxValue) * 2 * CGFloat(M_PI)) + startAngle;
        processPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true);
        self.annularFrontColor.set();
        processPath.stroke();
        
        // draw center circle
        let context: CGContext = UIGraphicsGetCurrentContext()!;
        context.setLineWidth(2.0);
        
        switch self.progressType {
        case .percent :
            let per: CGFloat = (self.currectValue/self.maxValue) * 100
            self.title = "\(per)%";
            let titleRect: CGRect = CGRect(x: self.annularWidth + WIDTH_BETWEEN_ANNULAR_AND_CIRCLE,
                y: self.annularWidth + WIDTH_BETWEEN_ANNULAR_AND_CIRCLE + INNER_CIRCLE_DIAMETER/4.0,
                width: INNER_CIRCLE_DIAMETER,
                height: INNER_CIRCLE_DIAMETER/2.0);
            self.titleColor.set();
            let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle();
            paragraphStyle.lineBreakMode = NSLineBreakMode.byClipping;
            paragraphStyle.alignment = NSTextAlignment.center;
            (self.title as NSString).draw(in: titleRect, withAttributes:[NSFontAttributeName: self.titleFont, NSParagraphStyleAttributeName: paragraphStyle])
            break;
        case .progress :
            self.title = "\(self.currectValue)";
            let titleRect = CGRect(x: self.annularWidth + WIDTH_BETWEEN_ANNULAR_AND_CIRCLE,
                y: self.annularWidth + WIDTH_BETWEEN_ANNULAR_AND_CIRCLE,
                width: INNER_CIRCLE_DIAMETER,
                height: INNER_CIRCLE_DIAMETER/2.0);
            let subtitleRect = CGRect(x: self.annularWidth + WIDTH_BETWEEN_ANNULAR_AND_CIRCLE,
                y: self.annularWidth + INNER_CIRCLE_DIAMETER/2.0 + WIDTH_BETWEEN_ANNULAR_AND_CIRCLE,
                width: INNER_CIRCLE_DIAMETER,
                height: INNER_CIRCLE_DIAMETER/2.0);
            UIColor.white.set();
            let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle();
            paragraphStyle.lineBreakMode = NSLineBreakMode.byClipping;
            paragraphStyle.alignment = NSTextAlignment.center;
            (self.title as NSString).draw(in: titleRect, withAttributes:[NSFontAttributeName: self.titleFont, NSParagraphStyleAttributeName: paragraphStyle])// darw subtitle
            (self.subtitle as NSString).draw(in: subtitleRect, withAttributes: [NSFontAttributeName: self.subtitleFont, NSParagraphStyleAttributeName: paragraphStyle]);
            break;
        default :
            break;
        }
    }
    
}
