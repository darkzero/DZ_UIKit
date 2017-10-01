//
//  DZButtonMenu.swift
//  DZ_UIKit
//
//  Created by Dora.Yuan on 14/10/25.
//  Copyright (c) 2014年 Dora.Yuan All rights reserved.
//

import Foundation
import UIKit

public enum DZButtonMenuState: Int {
    case closed     = 0;
    case opened     = 1;
    case closing    = 2;
    case opening    = 3;
}

public enum DZButtonMenuLocation: Int {
    case free           = 0;
    case leftTop        = 1;
    case rightTop       = 2;
    case leftBottom     = 3;
    case rightBottom    = 4;
}

public enum DZButtonMenuDirection: Int {
    case none   = 0;
    case left   = 1;
    case right  = 2;
    case up     = 3;
    case down   = 4;
}

public protocol DZButtonMenuDelegate {
    // click event
    func buttonMenu(_ aButtonMenu: DZButtonMenu, ClickedButtonAtIndex index: Int);
}

let MAIN_BTN_OPEN_STR: String   = "▲";
let MAIN_BTN_CLOSE_STR: String  = "▼";

open class DZButtonMenu : UIView {
    
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
            return CGRect(
                x: self.superview!.frame.size.width - BUTTON_DIAMETER-PADDING,
                y: self.superview!.frame.size.height - BUTTON_DIAMETER-PADDING,
                width: BUTTON_DIAMETER,
                height: BUTTON_DIAMETER);
        }
    };
    
    var LOCATION_LEFT_BOTTOM: CGRect {
        get {
            return CGRect(
                x: PADDING,
                y: self.superview!.frame.size.height - BUTTON_DIAMETER - PADDING,
                width: BUTTON_DIAMETER,
                height: BUTTON_DIAMETER);
        }
    }
    
    var LOCATION_RIGHT_TOP: CGRect {
        get {
            return CGRect(
                x: self.superview!.frame.size.width - BUTTON_DIAMETER-PADDING,
                y: PADDING + topPadding,
                width: BUTTON_DIAMETER,
                height: BUTTON_DIAMETER);
        }
    }
    
    var LOCATION_LEFT_TOP:CGRect {
        get {
            return CGRect(x: PADDING,y: PADDING + topPadding,width: BUTTON_DIAMETER,height: BUTTON_DIAMETER)
        }
    }
    
    var COLOR_SEARCH_ITEM_OFF:UIColor {
        get {
            return RGBA(47, 47, 47, 0.6);
        }
    }
    
// MARK: - public properties
    
    public var delegate:DZButtonMenuDelegate?;
    
    public var topPadding: CGFloat = 0.0;
    
// MARK: - internal properties
    
    var location:DZButtonMenuLocation   = .free;
    var direction:DZButtonMenuDirection = .none;
    var menuState:DZButtonMenuState     = .closed;
    
    var buttonArray = Array<UIButton>();
    var labelArray = Array<UILabel>();
    var frameClose  = CGRect.zero;
    var frameOpen   = CGRect.zero;
    
    var maxLabelWidth:CGFloat = 0.0;
    
    var openImage: String?;
    var closeImage: String?;
    
     open var maskBg: UIView?;
    
// MARK: - private properties
    
// MARK: - init
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(location: DZButtonMenuLocation, direction: DZButtonMenuDirection, closeImage: String?, openImage: String?, titleArray: [String], imageArray: [String]?) {
        super.init(frame: CGRect.zero);
        
        self.maskBg = UIView.init(frame: UIScreen.main.bounds);
        self.maskBg?.backgroundColor = RGB_HEX("ffffff", 0.7);
        self.maskBg?.isHidden = true;
        
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
        
        self.backgroundColor = UIColor.clear;
        //self.backgroundColor = UIColor.redColor();
        
        if ( imageArray != nil ) {
            // create buttons
            for i in 1 ... imageArray!.count {
                let imgName             = imageArray![i-1];
                let btn                 = UIButton(type: UIButtonType.custom);
                btn.frame               = CGRect(x: 0, y: 0, width: BUTTON_DIAMETER, height: BUTTON_DIAMETER);
                btn.backgroundColor     = COLOR_SEARCH_ITEM_OFF;
                btn.layer.cornerRadius  = BUTTON_DIAMETER/2
                btn.tag                 = TAG_MAIN_BUTTON + i;
                btn.alpha               = 0.0;
                btn.setImage(UIImage(named: imgName), for: UIControlState());
                self.addSubview(btn);
                
                btn.addTarget(self, action: #selector(DZButtonMenu.buttonClicked(_:)), for: UIControlEvents.touchUpInside);
                buttonArray.append(btn);
            }
        }
        else {
            // create buttons
            for i in 1 ... titleArray.count {
                let title               = titleArray[i-1];
                let btn                 = UIButton(type: UIButtonType.custom);
                btn.frame               = CGRect(x: 0, y: 0, width: BUTTON_DIAMETER, height: BUTTON_DIAMETER);
                btn.backgroundColor     = COLOR_SEARCH_ITEM_OFF;
                btn.layer.cornerRadius  = BUTTON_DIAMETER/2
                btn.tag                 = TAG_MAIN_BUTTON + i;
                btn.alpha               = 0.0;
                btn.titleLabel?.font    = UIFont.boldSystemFont(ofSize: 16);
                btn.setTitle(title.substring(to: title.characters.index(title.startIndex, offsetBy: 1)).uppercased(), for:UIControlState());
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 24.0);
                self.addSubview(btn);
                
                btn.addTarget(self, action: #selector(DZButtonMenu.buttonClicked(_:)), for: UIControlEvents.touchUpInside);
                buttonArray.append(btn);
            }
        }
        
        // create labels
        maxLabelWidth = 0.0;
        for j in 1 ... titleArray.count {
            let titleStr = titleArray[j-1];
            let lbl = UILabel.init();
            lbl.font = UIFont.systemFont(ofSize: 12.0);
            lbl.numberOfLines = 1;
            let lblRect = titleStr.boundingRect(with: CGSize(width: 200, height: LABEL_HEIGHT),
                                                        options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                        attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12.0)],
                                                        context: nil);
            if ( lblRect.size.width > maxLabelWidth ) {
                maxLabelWidth = lblRect.size.width;
            }
            lbl.frame = CGRect(x: 0, y: 0, width: lblRect.size.width+20, height: LABEL_HEIGHT);
            lbl.backgroundColor = COLOR_SEARCH_ITEM_OFF;
            lbl.textAlignment = NSTextAlignment.center;
            lbl.textColor = UIColor.white;
            lbl.layer.cornerRadius = LABEL_HEIGHT/2;
            lbl.clipsToBounds = true;
            lbl.text = titleStr;
            lbl.alpha = 0.0;
            self.addSubview(lbl);
            labelArray.append(lbl);
        }
        
        // main button
        self.createMainButton(closeImage: closeImage, openImage: openImage);
    }
    
    public init(location: DZButtonMenuLocation, direction: DZButtonMenuDirection, closeImage: String?, openImage: String?, imageArray: [String]) {
        super.init(frame: CGRect.zero);
        
        self.location   = location;
        self.direction  = direction;
        self.closeImage = closeImage;
        if ( openImage != nil ) {
            self.openImage = openImage!;
        }
        else {
            self.openImage = closeImage;
        }
        
        self.backgroundColor = UIColor.clear;
        
        // create buttons
        for i in 1 ... imageArray.count {
            let imgName             = imageArray[i-1];
            let btn                 = UIButton(type: UIButtonType.custom);
            btn.frame               = CGRect(x: 0, y: 0, width: BUTTON_DIAMETER, height: BUTTON_DIAMETER);
            btn.backgroundColor     = COLOR_SEARCH_ITEM_OFF;
            btn.layer.cornerRadius  = BUTTON_DIAMETER/2
            btn.tag                 = TAG_MAIN_BUTTON + i;
            btn.alpha               = 0.0;
            btn.setImage(UIImage(named: imgName), for: UIControlState());
            self.addSubview(btn);
            
            btn.addTarget(self, action: #selector(DZButtonMenu.buttonClicked(_:)), for: UIControlEvents.touchUpInside);
            buttonArray.append(btn);
        }
        
        // main button
        self.createMainButton(closeImage: closeImage, openImage: openImage);
        
        self.calcOpenFrame();
    }
    
    // MARK: - class functions
    
    // MARK: - public functions
    
    // MARK: - private functions
    fileprivate func setFrame(withLocation location: DZButtonMenuLocation)
    {
        switch location {
            case .rightBottom:
                self.frame = LOCATION_RIGHT_BOTTOM;
                break;
            case .leftBottom:
                self.frame = LOCATION_LEFT_BOTTOM;
                break;
            case .leftTop:
                self.frame = LOCATION_LEFT_TOP;
                break;
            case .rightTop:
                self.frame = LOCATION_RIGHT_TOP;
                break;
            default:
                self.frame = LOCATION_RIGHT_BOTTOM;
                break;
        }
    }
    
    fileprivate func createMainButton(closeImage: String?, openImage: String?)
    {
        let btnMain = UIButton(type: UIButtonType.custom);
        
        btnMain.frame           = CGRect(x: 0, y: 0, width: BUTTON_DIAMETER, height: BUTTON_DIAMETER);
        btnMain.backgroundColor = COLOR_SEARCH_ITEM_OFF;
    
        // image
        if( closeImage != nil ) {
            btnMain.setImage(UIImage(named: closeImage!), for:UIControlState());
        }
        else {
            btnMain.setTitle(MAIN_BTN_OPEN_STR, for:UIControlState());
        }
        
        btnMain.tag = TAG_MAIN_BUTTON;
        btnMain.layer.cornerRadius = BUTTON_DIAMETER/2;
        self.addSubview(btnMain);
        
        btnMain.addTarget(self, action: #selector(DZButtonMenu.switchMenuStatus), for: UIControlEvents.touchUpInside);
    }
    
    fileprivate func calcOpenFrame() {
        
        self.frameClose = self.frame;
        
        let buttonCount = CGFloat(BUTTON_COUNT);
        // calc frame of open
        switch (self.direction) {
        case .left:
            //
            NSLog("%lu", buttonCount);
            NSLog("%f,%f,%lu,%d",self.frame.origin.x-BUTTON_DIAMETER*buttonCount-BUTTON_PADDING*buttonCount,
                  self.frame.origin.y,
                  BUTTON_DIAMETER*(buttonCount+1)+BUTTON_PADDING*buttonCount,
                  BUTTON_DIAMETER);
            self.frameOpen = CGRect(x: self.frame.origin.x-BUTTON_DIAMETER*buttonCount-BUTTON_PADDING*buttonCount,
                                    y: self.frame.origin.y,
                                    width: BUTTON_DIAMETER*(buttonCount+1)+BUTTON_PADDING*buttonCount,
                                    height: BUTTON_DIAMETER);
            break;
        case .right:
            //
            self.frameOpen = CGRect(x: self.frame.origin.x,
                                    y: self.frame.origin.y,
                                    width: BUTTON_DIAMETER*(buttonCount+1)+BUTTON_PADDING*buttonCount,
                                    height: BUTTON_DIAMETER);
            break;
        case .up:
            //
            self.frameOpen = CGRect(x: self.frame.origin.x,
                                    y: self.frame.origin.y-BUTTON_DIAMETER*buttonCount-BUTTON_PADDING*buttonCount,
                                    width: BUTTON_DIAMETER,
                                    height: BUTTON_DIAMETER*(buttonCount+1)+BUTTON_PADDING*buttonCount);
            break;
        case .down:
            //
            self.frameOpen = CGRect(x: self.frame.origin.x,
                                    y: self.frame.origin.y,
                                    width: BUTTON_DIAMETER,
                                    height: BUTTON_DIAMETER*(buttonCount+1)+BUTTON_PADDING*buttonCount);
            break;
        default:
            break;
        }
    }
    
    fileprivate func calcButtonFrame(_ index:Int) -> CGRect {
        var ret = CGRect.zero;
        
        let idx_f = CGFloat(index);
        let btnCount_f = CGFloat(BUTTON_COUNT);
        switch self.direction {
        case .left:
            ret = CGRect(x: self.frame.size.width - (idx_f+1.0)*BUTTON_DIAMETER - idx_f*BUTTON_PADDING,
                             y: self.frame.size.height - BUTTON_DIAMETER,
                             width: BUTTON_DIAMETER,
                             height: BUTTON_DIAMETER);
            break;
        case .right:
            ret = CGRect(x: self.frame.size.width - (btnCount_f-idx_f+1.0)*BUTTON_DIAMETER - (btnCount_f-idx_f)*BUTTON_PADDING,
                             y: self.frame.size.height - BUTTON_DIAMETER,
                             width: BUTTON_DIAMETER,
                             height: BUTTON_DIAMETER);
            break;
        case .up:
            ret = CGRect(x: self.frame.size.width - BUTTON_DIAMETER,
                             y: self.frame.size.height - (idx_f+1)*BUTTON_DIAMETER - idx_f*BUTTON_PADDING,
                             width: BUTTON_DIAMETER,
                             height: BUTTON_DIAMETER);
            break;
        case .down:
            ret = CGRect(x: self.frame.size.width - BUTTON_DIAMETER,
                             y: self.frame.size.height - (btnCount_f-idx_f+1)*BUTTON_DIAMETER - (btnCount_f-idx_f)*BUTTON_PADDING,
                             width: BUTTON_DIAMETER,
                             height: BUTTON_DIAMETER);
            break;
        default:
            //
            break;
        }
    
        return ret;
    }
    
    fileprivate func calcLabelFrame(_ label: UILabel, AtIndex index: NSInteger) -> CGRect {
        var ret = CGRect.zero;
        let idx_f = CGFloat(index);
        let btnCount_f = CGFloat(BUTTON_COUNT);
        switch (self.direction) {
        case .up:
            var x:CGFloat = 0.0;
            if ( self.location == .rightBottom ) {
                x = self.frame.size.width - BUTTON_DIAMETER - label.bounds.size.width - 10
            }
            else if ( self.location == .leftBottom ) {
                x = self.frame.size.width + 10
            }
            
            let btnSizeSum = (idx_f+2.0)*BUTTON_DIAMETER;
            let btnPaddingSum = (idx_f+1.0)*BUTTON_PADDING;
            let y = self.frame.size.height - btnSizeSum - btnPaddingSum + (BUTTON_DIAMETER-LABEL_HEIGHT)/2;
            ret = CGRect(x: x,
                         y: y,
                         width: label.bounds.size.width,
                         height: LABEL_HEIGHT);
            break;
        case .down:
            ret = CGRect(x: self.frame.size.width - BUTTON_DIAMETER - label.bounds.size.width - 10,
                             y: self.frame.size.height - (btnCount_f-idx_f+1.0)*BUTTON_DIAMETER - (btnCount_f-idx_f)*BUTTON_PADDING,
                             width: label.bounds.size.width,
                             height: LABEL_HEIGHT);
            break;
            
        default:
            break;
        }
    
        return ret;
    }
    
// MARK: - button action
    
    @objc func buttonClicked(_ sender:AnyObject) {
        self.delegate?.buttonMenu(self, ClickedButtonAtIndex: (sender.tag - TAG_MAIN_BUTTON));
    }
    
    @objc internal func switchMenuStatus() {
        if ( self.menuState == .closed ) {
            self.showMenu(withAnimation: true);
        }
        else if ( self.menuState == .opened ) {
            self.hideMenu(withAnimation: true);
        }
    }
    
// MARK: - Menu Animations
    
    fileprivate func showMenu(withAnimation animation:Bool = true) {
        self.menuState = .opening;
        
        self.superview?.addSubview(self.maskBg!);
        self.maskBg?.isHidden = false;
        self.superview?.bringSubview(toFront: self);
        
        UIView.animate(withDuration: ANIMATION_DURATION, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.frame =  self.frameOpen;
            
            // set main button position
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
                let targetFrame = self.calcLabelFrame(lbl, AtIndex: self.labelArray.index(of: lbl)!);
                lbl.frame = targetFrame;
                lbl.alpha = 1.0;
            }
        }) { (finished) in
                self.afterShow();
        };
    }
    
    fileprivate func afterShow() {
        let mainBtn = self.viewWithTag(self.TAG_MAIN_BUTTON) as! UIButton;
        if ( self.openImage != nil ) {
            mainBtn.setImage(UIImage(named: self.openImage!), for: UIControlState());
        }
        else {
            mainBtn.setTitle(MAIN_BTN_CLOSE_STR, for:UIControlState());
        }
        self.menuState = .opened;
    }
    
    fileprivate func hideMenu(withAnimation animation:Bool = true) {
        self.menuState = .closing;
        
        UIView.animate(withDuration: ANIMATION_DURATION, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.frame =  self.frameClose;
            
            for subView in self.subviews {
                let tag = subView.tag;
                let targetFrame = CGRect(x: 0, y: 0, width: subView.frame.size.width, height: subView.frame.size.height);
                subView.frame = targetFrame;
                if ( tag != self.TAG_MAIN_BUTTON ) {
                    subView.alpha = 0.0;
                }
            }
        }) { (finished) in
            self.afterHide();
        };
        
    }
    
    fileprivate func afterHide() {
        self.maskBg?.removeFromSuperview();
        self.maskBg?.isHidden = true;
        
        let mainBtn = self.viewWithTag(self.TAG_MAIN_BUTTON) as! UIButton;
        if ( self.closeImage != nil ) {
            mainBtn.setImage(UIImage(named: self.closeImage!), for: UIControlState());
        }
        else {
            mainBtn.setTitle(MAIN_BTN_OPEN_STR, for:UIControlState());
        }
        self.menuState = .closed;
    }
    
// MARK: - layoutSubviews
    
    open override func didMoveToSuperview() {
        if ( self.superview != nil ) {
            self.setFrame(withLocation: self.location);
            self.calcOpenFrame();
        }
    }
}
