//
//  DZCheckBox.swift
//  DZLib
//
//  Created by Dora.Yuan on 2014/10/08.
//  Copyright (c) 2014 Dora.Yuan All rights reserved.
//

import Foundation
import UIKit

//let VALUE_KEY_CHECKED   = "_checked";

let DEFAULT_CHECKED_COLOR   = UIColor.colorWithDec(Red: 184, Green: 208, Blue: 98, Alpha: 1.0);     // RGB(184, 208, 98);
let DEFAULT_UNCHECKED_COLOR = UIColor.colorWithDec(Red: 230, Green: 230, Blue: 230, Alpha: 1.0);    // RGB(230, 230, 230);

public enum DZCheckBoxType {
    case None
    case Circular
    case Square
    case Rounded
}

@IBDesignable
public class DZCheckBox : UIControl {
    
    @IBInspectable public var borderWidth:CGFloat = 4.0;
    
    private var backgroundLayer:CALayer!;
    private var uncheckedLayer:CALayer!;
    private var checkedLayer:CALayer!;
    
    private var imageView: UIImageView!;
    
    private var titleLabel: UILabel!;
    
    // for DZCheckBoxTypeCircular
    private var expansionRect:CGRect!;
    private var contractRect:CGRect!;
    
    // for DZCheckBoxRounded
    private var outterCornerRadius:CGFloat = 8.0;
    private var innerCornerRadius:CGFloat = 4.0;
    
    @IBInspectable public var type:DZCheckBoxType = .None;
    
    @IBInspectable public var checkBoxSize:CGSize = CGSizeMake(48, 48);
    
    var withTitle: Bool = false;
    public var title: String = "" {
        didSet {
            if self.withTitle {
                self.titleLabel?.text = title;
                titleLabel.hidden = false;
                titleLabel.text = self.title;
                let rect = NSString(string: self.title).boundingRectWithSize(CGSizeMake(0, self.bounds.size.height),
                                                                             options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                                                                             attributes: [NSFontAttributeName : UIFont.systemFontOfSize(frame.size.height-4)],
                                                                             context: nil);
                titleLabel.frame.size = rect.size;
                self.frame.size = CGSizeMake(self.frame.size.width + 4 + rect.size.width, self.frame.height);
            }
        }
    }
    
    @IBInspectable public var checked: Bool = false {
        didSet {
            self.playAnimation(checked);
        }
    }
    
    @IBInspectable public var borderColor: UIColor? = nil {
        didSet {
            if ( borderColor != nil ) {
                backgroundLayer.backgroundColor = borderColor!.CGColor;
                self.hasBorder = true;
            }
        }
    };
    
    @IBInspectable public var uncheckedColor: UIColor = DEFAULT_UNCHECKED_COLOR {
        didSet {
            uncheckedLayer.backgroundColor = uncheckedColor.CGColor;
        }
    };
    
    @IBInspectable public var checkedColor: UIColor = DEFAULT_CHECKED_COLOR {
        didSet {
            checkedLayer.backgroundColor = checkedColor.CGColor;
        }
    };
    
    @IBInspectable public var image: UIImage? {
        didSet {
            self.imageView.image = image;
            //self.setNeedsLayout();
        }
    };
    
    internal var hasBorder:Bool = false {
        didSet {
        }
    };
    
    public class func checkBoxWithFrame(frame:CGRect,
        Type type:DZCheckBoxType,
        Title title: String? = nil,
        Image image: UIImage? = nil,
        BorderColorOrNil borderColor:UIColor? = nil,
        UncheckedColorOrNil uncheckedColor:UIColor? = nil,
        CheckedColorOrNil checkedColor:UIColor? = nil) -> DZCheckBox
    {
        let checkbox:DZCheckBox! = DZCheckBox(frame:frame);
        if ( checkbox != nil ) {
            if ( borderColor != nil ) {
                checkbox.hasBorder      = true;
                checkbox.borderColor    = borderColor;
                checkbox.borderWidth    = max(frame.width/16, 2);
                checkbox.innerCornerRadius = checkbox.outterCornerRadius - checkbox.borderWidth;
            }
            else {
                checkbox.hasBorder      = false;
            }
        
            if ( uncheckedColor != nil ) {
                checkbox.uncheckedColor     = uncheckedColor!;
            }
        
            if ( checkedColor != nil ) {
                checkbox.checkedColor       = checkedColor!;
            }
            
            if title != nil {
                checkbox.withTitle = true;
                checkbox.title = title!;
            }
            
            if image != nil {
                checkbox.image = image;
            }
            else {
                var imageStr = NSBundle(forClass: DZCheckBox.self).pathForResource("checked", ofType: "png");
                checkbox.image = UIImage(data: NSData(contentsOfURL: NSURL(fileURLWithPath: imageStr!))!);
            }
            checkbox.type = type;
        }
        return checkbox;
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder);
        self.createControllers();
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame);
        self.createControllers();
    }
    
    private func createControllers() {
        // Initialization code
        self.backgroundColor = UIColor.clearColor();
        
        self.checkBoxSize = frame.size;
        
        self.hasBorder = false;
        
        self.expansionRect  = CGRectMake(self.borderWidth, self.borderWidth, checkBoxSize.width - self.borderWidth * 2, checkBoxSize.height - self.borderWidth * 2);
        self.contractRect   = CGRectMake(checkBoxSize.width/2, checkBoxSize.height/2, 0, 0);
        
        backgroundLayer = CALayer();
        backgroundLayer.frame = self.bounds;
        backgroundLayer.backgroundColor = UIColor.whiteColor().CGColor;
        backgroundLayer.opacity = 1.0;
        self.layer.addSublayer(backgroundLayer);
        
        uncheckedLayer = CALayer();
        uncheckedLayer.frame = self.bounds;
        uncheckedLayer.backgroundColor = self.uncheckedColor.CGColor;
        uncheckedLayer.opacity = 1.0;
        self.layer.addSublayer(uncheckedLayer);
        
        checkedLayer = CALayer();
        checkedLayer.frame = contractRect;
        checkedLayer.backgroundColor = self.checkedColor.CGColor;
        checkedLayer.opacity = 0.0;
        self.layer.addSublayer(checkedLayer);
        
        titleLabel = UILabel();
        titleLabel.frame = CGRectMake(frame.size.width+4, 0, 0, frame.size.height);
        titleLabel.hidden = true;
        self.addSubview(titleLabel);
        
        imageView = UIImageView(frame: self.bounds);
        // set default image
        if self.image == nil {
            var imageStr = NSBundle(forClass: DZCheckBox.self).pathForResource("checked", ofType: "png");
            self.image = UIImage(data: NSData(contentsOfURL: NSURL(fileURLWithPath: imageStr!))!);
        }
        self.addSubview(imageView);
        
        self.addTarget(self, action: #selector(DZCheckBox.onCheckBoxTouched(_:)), forControlEvents: UIControlEvents.TouchUpInside);
    }
    
    
// MARK: - touch handle
    
    func onCheckBoxTouched(sender:AnyObject)
    {
        let oldValue:Bool = self.checked;
        self.checked = !oldValue;
    }
    
    private func playAnimation(checked:Bool)
    {
        if ( checked ) {
            UIView.animateWithDuration(0.1, delay: 0.1, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                self.checkedLayer.opacity   = 1.0;
                self.checkedLayer.frame     = self.expansionRect;
                self.titleLabel.textColor   = self.checkedColor;
            }, completion: { (result) -> Void in
                self.sendActionsForControlEvents(UIControlEvents.ValueChanged);
            });
        }
        else {
            UIView.animateWithDuration(0.3, delay: 0.1, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                self.checkedLayer.opacity   = 0.0;
                self.checkedLayer.frame     = self.contractRect;
                self.titleLabel.textColor   = self.uncheckedColor;
            }, completion: { (result) -> Void in
                self.sendActionsForControlEvents(UIControlEvents.ValueChanged);
            });
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews();
        
        //self.backgroundColor = UIColor.redColor();
        if ( self.borderColor != nil ) {
            self.hasBorder = true;
        }
        
        if  self.hasBorder {
            self.expansionRect      = CGRectMake(self.borderWidth, self.borderWidth, checkBoxSize.width - self.borderWidth * 2, checkBoxSize.height - self.borderWidth * 2);
            self.contractRect       = CGRectMake((checkBoxSize.width - self.borderWidth)/2, (checkBoxSize.height - self.borderWidth)/2, 0, 0);
            imageView.frame         = CGRectMake(self.borderWidth + 2, self.borderWidth + 2, self.expansionRect.size.width-4, self.expansionRect.size.height-4);
        }
        else {
            self.expansionRect      = CGRectMake(0, 0, checkBoxSize.width, checkBoxSize.height);
            self.contractRect       = CGRectMake(checkBoxSize.width/2, checkBoxSize.height/2, 0, 0);
            imageView.frame         = CGRectMake(2, 2, self.expansionRect.size.width-4, self.expansionRect.size.height-4);
            self.innerCornerRadius  = self.outterCornerRadius;
        }
        
        self.backgroundLayer.frame  = CGRectMake(0, 0, checkBoxSize.width, checkBoxSize.height);
        self.uncheckedLayer.frame   = self.expansionRect;
        
        if self.checked {
            self.checkedLayer.opacity   = 1.0;
            self.checkedLayer.frame     = self.expansionRect;
            self.titleLabel.textColor   = self.checkedColor;
        }
        else {
            self.checkedLayer.opacity    = 0.0;
            self.checkedLayer.frame      = self.contractRect;
            self.titleLabel.textColor   = self.uncheckedColor;
        }
        
        uncheckedLayer.backgroundColor = self.uncheckedColor.CGColor;
        checkedLayer.backgroundColor = self.checkedColor.CGColor;
        
        // Drawing code
        switch self.type {
        case .Rounded :
            //self.clipsToBounds                  = true;
            self.backgroundLayer.cornerRadius   = self.outterCornerRadius;
            self.uncheckedLayer.cornerRadius    = self.innerCornerRadius;
            self.checkedLayer.cornerRadius      = self.innerCornerRadius;
            break;
        case .Square :
            break;
        case .Circular, .None :
            //self.clipsToBounds                  = false;
            self.backgroundLayer.cornerRadius   = checkBoxSize.width / 2;
            self.uncheckedLayer.cornerRadius    = self.expansionRect.size.width / 2;
            if self.checked {
                self.checkedLayer.cornerRadius  = self.expansionRect.size.width / 2;
            } else {
                self.checkedLayer.cornerRadius  = innerCornerRadius;
            }
            break;
        }
    }
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
}
