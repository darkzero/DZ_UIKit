//
//  DZAnnularProgress.swift
//  DZ_UIKit
//
//  Created by Dora.Yuan on 2014/11/12.
//  Copyright (c) 2014年 Dora.Yuan All rights reserved.
//
//  参考网站:
//  http://evandavis.me/blog/2013/2/13/getting-creative-with-calayer-masks
//  https://github.com/jdg/MBProgressHUD

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
    
    public var progressType: AnnularProgressType    = AnnularProgressType.none;
    public var displayType: AnnularDisplayType      = AnnularDisplayType.none;
    
    public var maxValue: CGFloat            = 100.0 { didSet { self.setNeedsDisplay(); } };
    public var currectValue: CGFloat        = 0.0  { didSet { self.setNeedsDisplay(); } };
    
    public var annularWidth: CGFloat        = 8.0;
    
    public var annularBackColor: UIColor    = UIColor.white;
    public var annularFrontColor: UIColor   = UIColor.white;
    public var centerCircleColor: UIColor   = UIColor.white;
    
    public var title: String                = "";
    public var titleFont: UIFont            = UIFont.systemFont(ofSize: 16.0);
    public var titleColor: UIColor          = UIColor.darkText;
    
    public var subtitle: String             = "";
    public var subtitleFont: UIFont         = UIFont.systemFont(ofSize: 12.0);
    public var subtitleColor: UIColor       = UIColor.darkText;
    
    
    open var INNER_CIRCLE_DIAMETER:CGFloat {
        get { return (self.frame.size.width - (self.annularWidth*2.0) - 6.0) }
    };
    
// MARK: - init functions
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    public init(outerRadius: CGFloat, innerRadius: CGFloat, type: AnnularProgressType) {
        let outerDiameter = outerRadius * 2.0;
        let innerDiameter = innerRadius * 2.0;
        let frame: CGRect           = CGRect(x: 0, y: 0, width: outerDiameter, height: outerDiameter);
        let annularWidth: CGFloat   = outerDiameter/2.0 - innerDiameter/2.0;
        
        super.init(frame: frame);
        
        self.progressType       = type;
        self.annularWidth       = annularWidth;
        self.backgroundColor    = UIColor.clear;
        //DZAnnularProgress(outerDiameter: outerDiameter, innerDiameter: innerDiameter, type: type);
    }
    
    public init(outerDiameter: CGFloat, innerDiameter: CGFloat, type: AnnularProgressType) {
        let frame: CGRect           = CGRect(x: 0, y: 0, width: outerDiameter, height: outerDiameter);
        let annularWidth: CGFloat   = outerDiameter/2.0 - innerDiameter/2.0;
        
        super.init(frame: frame);
        
        self.progressType       = type;
        self.annularWidth       = annularWidth;
        self.backgroundColor    = UIColor.clear;
        //DZAnnularProgress(frame: frame, annularWidth: annularWidth, type: type);
    }
    
    public init(frame: CGRect, annularWidth: CGFloat, type: AnnularProgressType) {
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
        DebugLog("DZAnnularProgress layoutSubviews : ", self.frame.width, self.frame.height);
        super.layoutSubviews();
    }
    
    open override func draw(_ rect: CGRect) {
        DebugLog("DZAnnularProgress drawRect : ", self.frame.width, self.frame.height);
        // draw annular background color
        let lineWidth: CGFloat = self.annularWidth;
        let processBackgroundPath: UIBezierPath = UIBezierPath();
        processBackgroundPath.lineWidth         = lineWidth;
        processBackgroundPath.lineCapStyle      = CGLineCap.butt;
        let center: CGPoint     = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2);
        let radius: CGFloat     = (self.bounds.width - lineWidth) / 2;
        var startAngle: CGFloat = ((self.currectValue/self.maxValue) * 2 * CGFloat(Float.pi)) - (CGFloat(Float.pi) / 2); // + startAngle;
        var endAngle: CGFloat   = (2 * CGFloat(Float.pi)) - (CGFloat(Float.pi) / 2);// + startAngle;
        processBackgroundPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true);
        self.annularBackColor.set();
        processBackgroundPath.stroke();
        
        // draw progress
        let processPath = UIBezierPath();
        processPath.lineWidth       = lineWidth;
        processPath.lineCapStyle    = CGLineCap.butt;
        startAngle                  = -(CGFloat(Float.pi) / 2);
        endAngle                    = ((self.currectValue/self.maxValue) * 2 * CGFloat(Float.pi)) + startAngle;
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
            (self.title as NSString).draw(in: titleRect, withAttributes:[NSAttributedString.Key.font: self.titleFont, NSAttributedString.Key.paragraphStyle: paragraphStyle])
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
            (self.title as NSString).draw(in: titleRect, withAttributes:[NSAttributedString.Key.font: self.titleFont, NSAttributedString.Key.paragraphStyle: paragraphStyle])// darw subtitle
            (self.subtitle as NSString).draw(in: subtitleRect, withAttributes: [NSAttributedString.Key.font: self.subtitleFont, NSAttributedString.Key.paragraphStyle: paragraphStyle]);
            break;
        default :
            break;
        }
    }
    
}
