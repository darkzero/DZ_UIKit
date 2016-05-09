//
//  DZButtonMenu.swift
//  DZLib
//
//  Created by Dora.Yuan on 14/10/25.
//  Copyright (c) 2014年 Dora.Yuan All rights reserved.
//

import Foundation
import UIKit

public enum DZButtonMenuState: Int {
    case Closed     = 0;
    case Opened     = 1;
    case Closing    = 2;
    case Opening    = 3;
}

public enum DZButtonMenuLocation: Int {
    case Free           = 0;
    case LeftTop        = 1;
    case RightTop       = 2;
    case LeftBottom     = 3;
    case RightBottom    = 4;
}

public enum DZButtonMenuDirection: Int {
    case None   = 0;
    case Left   = 1;
    case Right  = 2;
    case Up     = 3;
    case Down   = 4;
}

protocol DZButtonMenuDelegate {
    // click event
    func buttonMenu(aButtonMenu: DZButtonMenu, ClickedButtonAtIndex index: Int);
}

public class DZButtonMenu : UIView {
    
    // MARK: - Class define
    
    let PADDING:CGFloat             = 10.0;
    let BUTTON_DIAMETER:CGFloat     = 48.0;
    let BUTTON_PADDING:CGFloat      = 8.0;
    let LABEL_HEIGHT:CGFloat        = 22.0;
    
    // Duration of animation
    let ANIMATION_DURATION:Double   = 0.3;
    // main button tag
    let TAG_MAIN_BUTTON:Int         = 10000;
    
    var BUTTON_COUNT:Int {
        get{ return self.buttonArray.count; }
    };
    
    var LOCATION_RIGHT_BOTTOM:CGRect {
        get{
            return CGRectMake(
                self.superview!.frame.size.width - BUTTON_DIAMETER-PADDING,
                self.superview!.frame.size.height - BUTTON_DIAMETER-PADDING,
                BUTTON_DIAMETER,
                BUTTON_DIAMETER);
        }
    };
    
    var LOCATION_LEFT_BOTTOM: CGRect {
        get {
            return CGRectMake(
                PADDING,
                self.superview!.frame.size.height - BUTTON_DIAMETER-PADDING,
                BUTTON_DIAMETER,
                BUTTON_DIAMETER);
        }
    }
    
    var LOCATION_RIGHT_TOP: CGRect {
        get {
            return CGRectMake(
                self.superview!.frame.size.width - BUTTON_DIAMETER-PADDING,
                PADDING,
                BUTTON_DIAMETER,
                BUTTON_DIAMETER);
        }
    }
    
    var LOCATION_LEFT_TOP:CGRect {
        get {
            return CGRectMake(PADDING,PADDING,BUTTON_DIAMETER,BUTTON_DIAMETER)
        }
    }
    
    var COLOR_SEARCH_ITEM_OFF:UIColor {
        get {
            return RGBA(47, 47, 47, 0.6);
        }
    }
    
    // MARK: - public properties
    var delegate:DZButtonMenuDelegate?;
    
    // MARK: - internal properties
    var location:DZButtonMenuLocation   = .Free;
    var direction:DZButtonMenuDirection = .None;
    var menuState:DZButtonMenuState     = .Closed;
    
    var buttonArray = Array<UIButton>();
    var labelArray = Array<UILabel>();
    var frameClose  = CGRect.zero;
    var frameOpen   = CGRect.zero;
    
    var maxLabelWidth:CGFloat = 0.0;
    
    var openImage   = "";
    var closeImage  = "";
    
    var mask: UIView?;
    
    // MARK: - private properties
    
    // MARK: - init
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(location: DZButtonMenuLocation, direction: DZButtonMenuDirection, closeImage: String, openImage: String?, titleArray: NSArray, imageArray: NSArray?) {
        super.init(frame: CGRectZero);
        
        self.mask = UIView.init(frame: UIScreen.mainScreen().bounds);
        self.mask?.backgroundColor = RGB_HEX("ffffff", 0.7);
        self.mask?.hidden = true;
        
        self.clipsToBounds = false;
        
        self.location   = location;
        self.direction  = direction;
        self.closeImage = closeImage;
        if ( openImage != nil ) {
            self.openImage = openImage!;
        }
        else {
            self.openImage = closeImage;
        }
        
        self.backgroundColor = UIColor.clearColor();
        //self.backgroundColor = UIColor.redColor();
        
        if ( imageArray != nil ) {
            // create buttons
            for i in 1 ... imageArray!.count {
                let imgName             = imageArray!.objectAtIndex(i-1) as! String;
                let btn                 = UIButton(type: UIButtonType.Custom);
                btn.frame               = CGRectMake(0, 0, BUTTON_DIAMETER, BUTTON_DIAMETER);
                btn.backgroundColor     = COLOR_SEARCH_ITEM_OFF;
                btn.layer.cornerRadius  = BUTTON_DIAMETER/2
                btn.tag                 = TAG_MAIN_BUTTON + i;
                btn.alpha               = 0.0;
                btn.setImage(UIImage(named: imgName), forState: UIControlState.Normal);
                self.addSubview(btn);
                
                btn.addTarget(self, action: #selector(DZButtonMenu.buttonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside);
                buttonArray.append(btn);
            }
        }
        else {
            // create buttons
            for i in 1 ... titleArray.count {
                let title               = titleArray.objectAtIndex(i-1) as! String;
                let btn                 = UIButton(type: UIButtonType.Custom);
                btn.frame               = CGRectMake(0, 0, BUTTON_DIAMETER, BUTTON_DIAMETER);
                btn.backgroundColor     = COLOR_SEARCH_ITEM_OFF;
                btn.layer.cornerRadius  = BUTTON_DIAMETER/2
                btn.tag                 = TAG_MAIN_BUTTON + i;
                btn.alpha               = 0.0;
                btn.setTitle(title.substringToIndex(title.startIndex.advancedBy(1)).uppercaseString, forState:UIControlState.Normal);
                btn.titleLabel?.font = UIFont.systemFontOfSize(24.0);
                self.addSubview(btn);
                
                btn.addTarget(self, action: #selector(DZButtonMenu.buttonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside);
                buttonArray.append(btn);
            }
        }
        
        // create labels
        maxLabelWidth = 0.0;
        for j in 1 ... titleArray.count {
            let titleStr = titleArray.objectAtIndex(j-1) as! String;
            let lbl = UILabel.init();
            lbl.font = UIFont.systemFontOfSize(12.0);
            lbl.numberOfLines = 1;
            let lblRect = titleStr.boundingRectWithSize(CGSizeMake(200, LABEL_HEIGHT),
                                                        options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                                                        attributes: [NSFontAttributeName: UIFont.systemFontOfSize(12.0)],
                                                        context: nil);
            if ( lblRect.size.width > maxLabelWidth ) {
                maxLabelWidth = lblRect.size.width;
            }
            lbl.frame = CGRectMake(0, 0, lblRect.size.width+20, LABEL_HEIGHT);
            lbl.backgroundColor = COLOR_SEARCH_ITEM_OFF;
            lbl.textAlignment = NSTextAlignment.Center;
            lbl.textColor = UIColor.whiteColor();
            lbl.layer.cornerRadius = LABEL_HEIGHT/2;
            lbl.clipsToBounds = true;
            lbl.text = titleStr;
            lbl.alpha = 0.0;
            self.addSubview(lbl);
            labelArray.append(lbl);
        }
        
        // main button
        self.createMainButtonCloseImage(closeImage, OpenImage: openImage);
    }
    
    public init(location: DZButtonMenuLocation, direction: DZButtonMenuDirection, closeImage: String, openImage: String?, imageArray: NSArray) {
        super.init(frame: CGRectZero);
        
        self.location   = location;
        self.direction  = direction;
        self.closeImage = closeImage;
        if ( openImage != nil ) {
            self.openImage = openImage!;
        }
        else {
            self.openImage = closeImage;
        }
        
        self.backgroundColor = UIColor.clearColor();
        
        // create buttons
        for i in 1 ... imageArray.count {
            let imgName             = imageArray.objectAtIndex(i-1) as! String;
            let btn                 = UIButton(type: UIButtonType.Custom);
            btn.frame               = CGRectMake(0, 0, BUTTON_DIAMETER, BUTTON_DIAMETER);
            btn.backgroundColor     = COLOR_SEARCH_ITEM_OFF;
            btn.layer.cornerRadius  = BUTTON_DIAMETER/2
            btn.tag                 = TAG_MAIN_BUTTON + i;
            btn.alpha               = 0.0;
            btn.setImage(UIImage(named: imgName), forState: UIControlState.Normal);
            self.addSubview(btn);
            
            btn.addTarget(self, action: #selector(DZButtonMenu.buttonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside);
            buttonArray.append(btn);
        }
        
        // main button
        self.createMainButtonCloseImage(closeImage, OpenImage: openImage);
        
        self.calcOpenFrame();
    }
    
    // MARK: - class functions
    
    // MARK: - public functions
    
    // MARK: - private functions
    private func setFrameWithLocation(location: DZButtonMenuLocation)
    {
        switch location {
            case .RightBottom:
                self.frame = LOCATION_RIGHT_BOTTOM;
                break;
            case .LeftBottom:
                self.frame = LOCATION_LEFT_BOTTOM;
                break;
            case .LeftTop:
                self.frame = LOCATION_LEFT_TOP;
                break;
            case .RightTop:
                self.frame = LOCATION_RIGHT_TOP;
                break;
            default:
                self.frame = LOCATION_RIGHT_BOTTOM;
                break;
        }
    }
    
    private func createMainButtonCloseImage(closeImg: String?,  OpenImage openImg: String?)
    {
        let btnMain = UIButton(type: UIButtonType.Custom);
        
        btnMain.frame           = CGRectMake(0, 0, BUTTON_DIAMETER, BUTTON_DIAMETER);
        btnMain.backgroundColor = COLOR_SEARCH_ITEM_OFF;
    
        // image
        if( closeImg != nil )
        {
            btnMain.setImage(UIImage(named: closeImg!), forState:UIControlState.Normal);
        }
        else
        {
            btnMain.setTitle("▲", forState:UIControlState.Normal);
        }
        
        btnMain.tag = TAG_MAIN_BUTTON;
        btnMain.layer.cornerRadius = BUTTON_DIAMETER/2;
        self.addSubview(btnMain);
        
        btnMain.addTarget(self, action: #selector(DZButtonMenu.switchMenuStatus), forControlEvents: UIControlEvents.TouchUpInside);
    }
    
    private func calcOpenFrame() {
        
        self.frameClose = self.frame;
        
        let buttonCount = CGFloat(BUTTON_COUNT);
        // calc frame of open
        switch (self.direction) {
        case .Left:
            //
            NSLog("%lu", buttonCount);
            NSLog("%f,%f,%lu,%d",self.frame.origin.x-BUTTON_DIAMETER*buttonCount-BUTTON_PADDING*buttonCount,
                  self.frame.origin.y,
                  BUTTON_DIAMETER*(buttonCount+1)+BUTTON_PADDING*buttonCount,
                  BUTTON_DIAMETER);
            self.frameOpen
                = CGRectMake(self.frame.origin.x-BUTTON_DIAMETER*buttonCount-BUTTON_PADDING*buttonCount,
                             self.frame.origin.y,
                             BUTTON_DIAMETER*(buttonCount+1)+BUTTON_PADDING*buttonCount,
                             BUTTON_DIAMETER);
            break;
        case .Right:
            //
            self.frameOpen
                = CGRectMake(self.frame.origin.x,
                             self.frame.origin.y,
                             BUTTON_DIAMETER*(buttonCount+1)+BUTTON_PADDING*buttonCount,
                             BUTTON_DIAMETER);
            break;
        case .Up:
            //
            self.frameOpen
                = CGRectMake(self.frame.origin.x,
                             self.frame.origin.y-BUTTON_DIAMETER*buttonCount-BUTTON_PADDING*buttonCount,
                             BUTTON_DIAMETER,
                             BUTTON_DIAMETER*(buttonCount+1)+BUTTON_PADDING*buttonCount);
            break;
        case .Down:
            //
            self.frameOpen
                = CGRectMake(self.frame.origin.x,
                             self.frame.origin.y,
                             BUTTON_DIAMETER,
                             BUTTON_DIAMETER*(buttonCount+1)+BUTTON_PADDING*buttonCount);
            break;
        default:
            break;
        }
    }
    
    private func calcButtonFrame(index:Int) -> CGRect {
        var ret = CGRectZero;
        
        let idx_f = CGFloat(index);
        let btnCount_f = CGFloat(BUTTON_COUNT);
        switch self.direction {
        case .Left:
            ret = CGRectMake(self.frame.size.width - (idx_f+1.0)*BUTTON_DIAMETER - idx_f*BUTTON_PADDING,
                             self.frame.size.height - BUTTON_DIAMETER,
                             BUTTON_DIAMETER,
                             BUTTON_DIAMETER);
            break;
        case .Right:
            ret = CGRectMake(self.frame.size.width - (btnCount_f-idx_f+1.0)*BUTTON_DIAMETER - (btnCount_f-idx_f)*BUTTON_PADDING,
                             self.frame.size.height - BUTTON_DIAMETER,
                             BUTTON_DIAMETER,
                             BUTTON_DIAMETER);
            break;
        case .Up:
            ret = CGRectMake(self.frame.size.width - BUTTON_DIAMETER,
                             self.frame.size.height - (idx_f+1)*BUTTON_DIAMETER - idx_f*BUTTON_PADDING,
                             BUTTON_DIAMETER,
                             BUTTON_DIAMETER);
            break;
        case .Down:
            ret = CGRectMake(self.frame.size.width - BUTTON_DIAMETER,
                             self.frame.size.height - (btnCount_f-idx_f+1)*BUTTON_DIAMETER - (btnCount_f-idx_f)*BUTTON_PADDING,
                             BUTTON_DIAMETER,
                             BUTTON_DIAMETER);
            break;
        default:
            //
            break;
        }
    
        return ret;
    }
    
    private func calcLabelFrame(label: UILabel, AtIndex index: NSInteger) -> CGRect {
        var ret = CGRectZero;
        let idx_f = CGFloat(index);
        let btnCount_f = CGFloat(BUTTON_COUNT);
        switch (self.direction) {
        case .Up:
            var x:CGFloat = 0.0;
            if ( self.location == .RightBottom ) {
                x = self.frame.size.width - BUTTON_DIAMETER - label.bounds.size.width - 10
            }
            else if ( self.location == .LeftBottom ) {
                x = self.frame.size.width + 10
            }
            ret = CGRectMake(x,
                             self.frame.size.height - (idx_f+2.0)*BUTTON_DIAMETER - (idx_f+1.0)*BUTTON_PADDING + (BUTTON_DIAMETER-LABEL_HEIGHT)/2,
                             label.bounds.size.width,
                             LABEL_HEIGHT);
            break;
        case .Down:
            ret = CGRectMake(self.frame.size.width - BUTTON_DIAMETER - label.bounds.size.width - 10,
                             self.frame.size.height - (btnCount_f-idx_f+1.0)*BUTTON_DIAMETER - (btnCount_f-idx_f)*BUTTON_PADDING,
                             label.bounds.size.width,
                             LABEL_HEIGHT);
            break;
            
        default:
            break;
        }
    
        return ret;
    }
    
    // MARK: - button action
    func buttonClicked(sender:AnyObject) {
        
    }
    
    @objc private func switchMenuStatus() {
        if ( self.menuState == .Closed ) {
            self.showMenuWithAnimation(true);
        }
        else if ( self.menuState == .Opened ) {
            self.hideMenuWithAnimation(true);
        }
    }
    
    // MARK: - Menu Animations
    private func showMenuWithAnimation(animation:Bool) {
        self.menuState = .Opening;
        
        self.superview?.addSubview(self.mask!);
        self.mask?.hidden = false;
        self.superview?.bringSubviewToFront(self);
//        self.mask
        
        UIView.animateWithDuration(ANIMATION_DURATION, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            self.frame =  self.frameOpen;
            
            // set main button position
            //var targetFrame = self.calcButtonFrame(0);
            let btnMain = self.viewWithTag(self.TAG_MAIN_BUTTON);
            let targetFrame = self.calcButtonFrame(0);
            btnMain?.frame = targetFrame;
            
            // set buttons position
            for btn in self.buttonArray {
                let tag = btn.tag;
                let targetFrame = self.calcButtonFrame(tag-self.TAG_MAIN_BUTTON);
                btn.frame = targetFrame;
                btn.alpha = 1.0;
            }
            
            // set labels positon
            for lbl in self.labelArray {
                let targetFrame = self.calcLabelFrame(lbl, AtIndex: self.labelArray.indexOf(lbl)!);
                lbl.frame = targetFrame;
                lbl.alpha = 1.0;
            }
        }) { (finished) in
                self.afterShow();
        };
    }
    
    private func afterShow() {
        let mainBtn = self.viewWithTag(self.TAG_MAIN_BUTTON) as! UIButton;
        mainBtn.setImage(UIImage(named: self.openImage), forState: .Normal);
        self.menuState = .Opened;
    }
    
    private func hideMenuWithAnimation(animation:Bool) {
        self.menuState = .Closing;
        
        UIView.animateWithDuration(ANIMATION_DURATION, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            self.frame =  self.frameClose;
            
            for subView in self.subviews {
                let tag = subView.tag;
                let targetFrame = CGRectMake(0, 0, subView.frame.size.width, subView.frame.size.height);
                subView.frame = targetFrame;
                if ( tag != self.TAG_MAIN_BUTTON ) {
                    subView.alpha = 0.0;
                }
            }
        }) { (finished) in
            self.afterHide();
        };
        
    }
    
    private func afterHide() {
        self.mask?.removeFromSuperview();
        self.mask?.hidden = true;
        
        let mainBtn = self.viewWithTag(self.TAG_MAIN_BUTTON) as! UIButton;
        mainBtn.setImage(UIImage(named: self.closeImage), forState: .Normal);
        self.menuState = .Closed;
    }
    
    // MARK: - layoutSubviews
    public override func didMoveToSuperview() {
        if ( self.superview != nil ) {
            self.setFrameWithLocation(self.location);
            self.calcOpenFrame();
        }
    }
    
    public override func layoutSubviews() {
    }
}