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

public enum DZCheckBoxType : Int {
    case None       = 0
    case Circular   = 1
    case Square     = 2
    case Rounded    = 3
}

public class DZCheckBox : UIControl {

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var borderWidth:CGFloat = 4.0;
    
    private var backgroundLayer:CALayer!;
    private var uncheckedLayer:CALayer!;
    private var checkedLayer:CALayer!;
    
    private var imageView:UIImageView!;
    
    // for DZCheckBoxRounded
    private var outterCornerRadius:CGFloat = 8.0;
    private var innerCornerRadius:CGFloat = 4.0;
    
    // for DZCheckBoxTypeCircular
    private var expansionRect:CGRect!;
    private var contractRect:CGRect!;
    
    public var checked:Bool = false {
        didSet {
            self.playAnimation(checked);
        }
    }
    
    var type:DZCheckBoxType = .None;
    
    internal var borderColor:UIColor! {
        didSet {
            backgroundLayer.backgroundColor = borderColor.CGColor;
        }
    };
    
    internal var uncheckedColor:UIColor! = DEFAULT_UNCHECKED_COLOR {
        didSet {
            uncheckedLayer.backgroundColor = uncheckedColor.CGColor;
        }
    };
    
    internal var checkedColor:UIColor! = DEFAULT_CHECKED_COLOR {
        didSet {
            checkedLayer.backgroundColor = checkedColor.CGColor;
        }
    };
    
    public var image:UIImage! {
        didSet {
            self.setNeedsLayout();
        }
    };
    
    internal var hasBorder:Bool = false;
    
    public class func checkBoxWithFrame(frame:CGRect,
        Type type:DZCheckBoxType,
        BorderColorOrNil borderColor:UIColor?,
        UncheckedColorOrNil uncheckedColor:UIColor?,
        CheckedColorOrNil checkedColor:UIColor?) -> DZCheckBox
    {
        let checkbox:DZCheckBox! = DZCheckBox(frame:frame);
        if ( checkbox != nil ) {
            if ( borderColor != nil ) {
                checkbox.hasBorder      = true;
                checkbox.borderColor    = borderColor;
            }
            else {
                checkbox.hasBorder      = false;
            }
        
            if ( uncheckedColor != nil ) {
                checkbox.uncheckedColor     = uncheckedColor;
            }
            else {
            }
        
            if ( checkedColor != nil ) {
                checkbox.checkedColor       = checkedColor;
            }
            else {
            }
            
            checkbox.type = type;
        }
        return checkbox;
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame);
        
        // Initialization code
        self.backgroundColor = UIColor.clearColor();
        
        self.hasBorder = false;
        
        contractRect    = CGRectMake(self.bounds.size.width/2, self.bounds.size.height/2, 0, 0);
        
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
        
        imageView = UIImageView(frame: self.bounds); //[[UIImageView alloc] initWithFrame:ExpansionRect];
        imageView.hidden = true;
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
                self.checkedLayer.opacity    = 1.0;
                self.checkedLayer.frame      = self.expansionRect;
            }, completion: { (result) -> Void in
                self.sendActionsForControlEvents(UIControlEvents.ValueChanged);
            });
        }
        else {
            UIView.animateWithDuration(0.3, delay: 0.1, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                self.checkedLayer.opacity    = 0.0;
                self.checkedLayer.frame      = self.contractRect;
            }, completion: { (result) -> Void in
                self.sendActionsForControlEvents(UIControlEvents.ValueChanged);
            });
        }
    }
    
    override public func layoutSubviews()
    {
        let theRect     = self.bounds;
        
        if  self.hasBorder {
            self.expansionRect      = CGRectMake(self.borderWidth, self.borderWidth, theRect.size.width - self.borderWidth * 2, theRect.size.height - self.borderWidth * 2);
            self.contractRect       = CGRectMake((theRect.size.width - self.borderWidth)/2, (theRect.size.height - self.borderWidth)/2, 0, 0);
        }
        else {
            self.expansionRect      = theRect;
            self.contractRect       = CGRectMake(theRect.size.width/2, theRect.size.height/2, 0, 0);
            self.innerCornerRadius  = self.outterCornerRadius;
        }
        
        uncheckedLayer.frame    = self.expansionRect;
        
        if ( self.image != nil ) {
            imageView.image = self.image;
        }
        imageView.frame = CGRectMake(self.borderWidth + 2, self.borderWidth + 2, self.expansionRect.size.width-4, self.expansionRect.size.height-4);
        
        if self.checked {
            self.checkedLayer.opacity   = 1.0;
            self.checkedLayer.frame     = self.expansionRect;
        }
        else {
            self.checkedLayer.opacity    = 0.0;
            self.checkedLayer.frame      = self.contractRect;
        }
        
        // Drawing code
        switch self.type {
        case .Rounded :
            self.clipsToBounds                  = true;
            self.backgroundLayer.cornerRadius   = self.outterCornerRadius;
            self.uncheckedLayer.cornerRadius    = self.innerCornerRadius;
            self.checkedLayer.cornerRadius      = self.innerCornerRadius;
            break;
        case .Square :
            break;
        case .Circular, .None :
            fallthrough;
        default:
            self.clipsToBounds                  = true;
            self.backgroundLayer.cornerRadius   = self.frame.size.width / 2;
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
