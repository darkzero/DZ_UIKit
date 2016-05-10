//
//  DZActionSheet.swift
//  DZLib
//
//  Created by Dora.Yuan on 2014/10/21.
//  Copyright (c) 2014 Dora.Yuan All rights reserved.
//

import Foundation
import UIKit

public class DZActionSheet : UIView {
    
    let BUTTON_FRAME: CGRect            = CGRectMake(0.0, 0.0, 64.0, 70.0);
    let CANCEL_BUTTON_HEIGHT: CGFloat   = 44.0;
    let CANCEL_BUTTON_WIDTH: CGFloat    = SCREEN_BOUNDS.size.width - 20;
    let BUTTON_ROW_HEIGHT: CGFloat      = 70.0;
    let TITLE_LABEL_HEIGHT: CGFloat     = 30.0;
    
    // MARK: - public properties
    public var title: String = "";
    public var cancelButtonBgColor: UIColor = UIColor.whiteColor();
    public var cancelButtonTitleColor: UIColor = RGB(109, 109, 109);
    
    // MARK: - internal properties
    internal var buttonArray:NSMutableArray = NSMutableArray();
    internal var blockDictionary            = Dictionary<Int, DZBlock>();
    internal var cancelButton               = UIButton(type: UIButtonType.Custom);
    internal var cancelBlock:DZBlock?;
    internal var titleLabel:UILabel?;
    internal var theWindow                  = UIWindow(frame: UIScreen.mainScreen().bounds);
    internal var buttonBgView               = UIView(frame: CGRect.zero);
    
    // MARK: - private properties
    
    // MARK: - init functions
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(frame:CGRect) {
        super.init(frame:frame);
    }
    
    private init(title: String) {
        let rect:CGRect = CGRectMake(0, SCREEN_BOUNDS.size.height - CANCEL_BUTTON_HEIGHT, SCREEN_BOUNDS.size.width, CANCEL_BUTTON_HEIGHT);
        super.init(frame: rect);
        self.title = title;
        self.setCancelButtonWithTitle("Cancel", CancelBlock: nil);
        
        // tap to dismiss
        let tap = UITapGestureRecognizer(target: self, action: #selector(DZActionSheet.dismiss));
        self.theWindow.addGestureRecognizer(tap);
    }
    
    // MARK: - class functions
    public class func actionSheetWithTitle(title: String) -> DZActionSheet {
        
        let obj:DZActionSheet = DZActionSheet(title: title);
        return obj;
    }
    
    public class func actionSheetWith(Title title: String, CancelTitle cancelTitle: String, CancelBlock cancelBlock: DZBlock) -> DZActionSheet {
        let obj:DZActionSheet = DZActionSheet(title: title);
        obj.setCancelButtonWithTitle(cancelTitle, CancelBlock: cancelBlock);
        return obj;
    }
    
    // MARK: - set Buttons
    public func setCancelButtonWithTitle(cancelTitle: String, CancelBlock cancelBlock: DZBlock?) {
        
        self.cancelButton.frame            = CGRectMake(0, 0, CANCEL_BUTTON_WIDTH, CANCEL_BUTTON_HEIGHT);
        self.cancelButton.backgroundColor  = RGB_HEX("ffffff", 1.0);
        self.cancelButton.titleLabel?.font = UIFont.boldSystemFontOfSize(20.0);
        self.cancelButton.setTitle(cancelTitle, forState: UIControlState.Normal);
        //Red:0.220000 Green:0.330000 Blue:0.530000 Alpha:1.000000
        self.cancelButton.setTitleColor(RGB(109, 109, 109), forState: UIControlState.Normal);
        self.cancelButton.addTarget(self, action: #selector(DZActionSheet.cancelButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside);
        
        self.cancelBlock = cancelBlock;
    }
    
    
    public func addButtonWithTitle(
        buttonTitle: String,
        characterColor characterColor: UIColor,
        Handler buttonBlock: DZBlock?) {
        
        self.addButtonWithTitle(buttonTitle,
                                characterColor: characterColor,
                                ImageNormal: nil,
                                ImageHighlighted: nil,
                                ImageDisabled: nil,
                                Handler: buttonBlock);
    }
    
    public func addButtonWithTitle(
        buttonTitle: String,
        ImageNormal buttonImageNormal: String,
        ImageHighlighted buttonImageHighlighted: String?,
        ImageDisabled buttonImageDisabled: String?,
        Handler buttonBlock: DZBlock?) {
        
        self.addButtonWithTitle(buttonTitle,
                                characterColor: nil,
                                ImageNormal: buttonImageNormal,
                                ImageHighlighted: buttonImageHighlighted,
                                ImageDisabled: buttonImageDisabled,
                                Handler: buttonBlock);
    }

    ///
    ///
    private func addButtonWithTitle (
        buttonTitle: String,
        characterColor: UIColor?,
        ImageNormal buttonImageNormal: String?,
        ImageHighlighted buttonImageHighlighted: String?,
        ImageDisabled buttonImageDisabled: String?, Handler buttonBlock: DZBlock?) {
            
        let btn:UIButton! = UIButton(type: UIButtonType.Custom);
        
        btn.setTitle(buttonTitle, forState: UIControlState.Normal);
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal);
        btn.titleLabel?.font = UIFont.systemFontOfSize(12.0);
        btn.titleLabel?.adjustsFontSizeToFitWidth = true;
        btn.backgroundColor = UIColor.clearColor();
    
        btn.imageView?.frame.size = CGSizeMake(48, 48);
        btn.imageView?.layer.cornerRadius = 24.0;
        var btnImage: UIImage;
        if ( buttonImageNormal != nil ) {
            btnImage = UIImage(named: buttonImageNormal!)!;
        }
        else {
            let g = characterColor?.getGary();
            print("%d", g);
            btnImage = UIImage.imageWithColor(characterColor!, size: CGSizeMake(48, 48));
            let initialChar = buttonTitle.substringToIndex(buttonTitle.startIndex.advancedBy(1));
            let lbl = UILabel(frame: CGRectMake(0, 0, 48, 48));
            lbl.font = UIFont.boldSystemFontOfSize(28.0);
            if g >= 175 {
                lbl.textColor = RGB_HEX("444444", 1.0);
            }
            else {
                lbl.textColor = RGB_HEX("dddddd", 1.0);
            }
            lbl.textAlignment = NSTextAlignment.Center;
            lbl.text = initialChar;
            btn.imageView?.addSubview(lbl);
        }
        btn.contentMode = UIViewContentMode.ScaleAspectFill;
        btn.setImage(btnImage, forState: UIControlState.Normal);
        
        btn.layer.cornerRadius = 8.0;
        
        if ( buttonImageHighlighted != nil ) {
            btn.setImage(UIImage(named: buttonImageHighlighted!), forState: UIControlState.Highlighted);
        }
        if ( buttonImageDisabled != nil ) {
            btn.setImage(UIImage(named: buttonImageDisabled!), forState: UIControlState.Disabled);
        }
        btn.frame = BUTTON_FRAME;
        //btn.backgroundColor = UIColor.redColor();
    
        self.buttonArray.addObject(btn);
        
        btn.contentHorizontalAlignment  = UIControlContentHorizontalAlignment.Center;
        btn.contentVerticalAlignment    = UIControlContentVerticalAlignment.Top;
        btn.imageEdgeInsets             = UIEdgeInsetsMake(0.0, 8.0, 22.0, 8.0);
        btn.titleEdgeInsets             = UIEdgeInsetsMake(50, -1*btnImage.size.width, 0, 0);
        
        let index:Int = self.buttonArray.indexOfObject(btn);
        btn.tag = index;
        btn.addTarget(self, action: #selector(DZActionSheet.buttonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside);
        self.setHandler(buttonBlock!, forButtonAtIndex: index);
        return;
    }
    
    internal func setHandler(block:DZBlock?, forButtonAtIndex index:Int) {
        if ( block != nil ) {
            self.blockDictionary[index] = block;
        }
        else {
            self.blockDictionary.removeValueForKey(index);
        }
    }
    
    public func setButtonState(buttonState:UIControlState, AtIndex buttonIndex:Int) {
        let btn = self.buttonArray.objectAtIndex(buttonIndex) as! UIButton;
        
        switch ( buttonState ) {
        case UIControlState.Normal :
            btn.enabled     = true;
            btn.highlighted = false;
            break;
        case UIControlState.Disabled :
            btn.enabled     = false;
            btn.highlighted = false;
            break;
        case UIControlState.Highlighted :
            btn.enabled     = true;
            btn.highlighted = true;
            break;
        default :
            break;
        }
    }
    
    internal func buttonClicked(sender:AnyObject) {
        let btnIdx = sender.tag;
        let block:DZBlock? = self.blockDictionary[btnIdx];
        if block != nil {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC/2)), dispatch_get_main_queue(), block!);
        }
        
        self.dismiss();
        
        return;
    }
    
    internal func cancelButtonClicked(sender:AnyObject) {
        if self.cancelBlock != nil {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC/2)), dispatch_get_main_queue(), self.cancelBlock!);
        }
        
        self.dismiss();
        return;
    }
    
    // MARK: - popup and dismiss
    let ANIMATION_SPEED:NSTimeInterval = 0.2;
    let ANIMATION_SCALE:CGFloat = 1.15;
    private var queue:dispatch_queue_t?;
    private var group:dispatch_group_t?;
    private var semaphore:dispatch_semaphore_t?;
    
    public func show() {
        self.showWithAnimation(true);
    }
    
    public func dismiss() {
        self.dismissWithAnimation(true);
    }
    
    public func showWithAnimation(flag:Bool) {
        
        // set all items
        self.setNeedsLayout();
        
        //self.theWindow = UIWindow(frame: UIScreen.mainScreen().bounds);
        self.theWindow.windowLevel = UIWindowLevelNormal;
        self.theWindow.opaque = false;
        self.theWindow.backgroundColor = RGBA(0, 0, 0, 0.5);
        
        self.theWindow.addSubview(self);
        self.theWindow.hidden = false;
        
        self.theWindow.alpha = 0.0;
        self.theWindow.transform = CGAffineTransformMakeScale(ANIMATION_SCALE, ANIMATION_SCALE);
        
        UIView.animateWithDuration(ANIMATION_SPEED, delay: 0.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            self.theWindow.alpha = 1.0;
            self.theWindow.transform = CGAffineTransformIdentity;
            }, completion: { (finished) -> Void in
            UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                self.frame = CGRectMake(0, SCREEN_BOUNDS.size.height - self.frame.size.height, 320, self.frame.size.height);
            }, completion: { (finished) -> Void in
                //
            })
        });
        
        self.queue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 );
        self.group = dispatch_group_create();
        self.semaphore = dispatch_semaphore_create(0);
        
        // 参考 http://www.swiftmi.com/topic/96.html
        dispatch_group_async(self.group!, self.queue!, { () -> Void in
            var _:Int = dispatch_semaphore_wait(self.semaphore!, DISPATCH_TIME_FOREVER);
        });
    }
    
    public func dismissWithAnimation(flag:Bool) {
        self.dismissWindowWithAnimation(true, Finish:true);
    }
    
    private func dismissWindowWithAnimation(animated:Bool, Finish finish:Bool) {
        
        self.theWindow.alpha = 1.0;
        self.theWindow.transform = CGAffineTransformIdentity;
    
        if( animated ) {
            UIView.animateWithDuration(ANIMATION_SPEED, animations: { () -> Void in
                self.frame = CGRectMake(0, SCREEN_BOUNDS.size.height, 320, self.frame.size.height);
                self.onWindowWillDismiss();
            }, completion: { (finished) -> Void in
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    //self.onWindowWillDismiss();
                }, completion: { (finished) -> Void in
                    self.onWindowDidDismiss(finish);
                })
            });
        }
        else {
            self.onWindowWillDismiss();
            self.onWindowDidDismiss(finish);
        }
    }
    
    private func onWindowWillDismiss() {
        self.theWindow.alpha = 0.0;
        self.theWindow.transform = CGAffineTransformMakeScale( ANIMATION_SCALE, ANIMATION_SCALE );
    }
    
    private func onWindowDidDismiss(finish:Bool) {
        self.theWindow.hidden = true;
        self.removeFromSuperview();
        self.theWindow.removeFromSuperview();
        //self.theWindow = nil;
    
        if( self.group != nil && self.queue != nil ) {
            weak var weakSelf:DZActionSheet? = self;
            dispatch_group_async( self.group!, self.queue!, { ()->Void in
                let strongSelf:DZActionSheet? = weakSelf;
    
                if( strongSelf != nil && strongSelf?.semaphore != nil ) {
                    dispatch_semaphore_signal( strongSelf!.semaphore! );
    
                    //dispatch_release( strongSelf.semaphore );
                    strongSelf?.semaphore = nil;
            
                    if( strongSelf?.group != nil ) {
                        //dispatch_release( strongSelf.group );
                        strongSelf?.group = nil;
                    }
            
                    strongSelf?.queue = nil;
                }
            });
        }
    }
    
    // MARK: - layoutSubviews
    
    override public func layoutSubviews() {
        let rect:CGRect = CGRectMake(0.0, 0.0, CANCEL_BUTTON_WIDTH, TITLE_LABEL_HEIGHT);
        
        // calc the height
        let titleHeight         = TITLE_LABEL_HEIGHT;
        let btnCount            = self.buttonArray.count;
        let lineCount           = (btnCount + 3 )/4;
        let buttonAreaHeight    = CGFloat(lineCount) * BUTTON_ROW_HEIGHT + 10
        
        let actionSheetHeight       = CANCEL_BUTTON_HEIGHT + buttonAreaHeight + titleHeight + 20;
    
        // labels
        self.titleLabel                     = UILabel(frame: rect);
        self.titleLabel?.textAlignment      = NSTextAlignment.Center;
        self.titleLabel?.backgroundColor    = UIColor.clearColor();
        self.titleLabel?.font               = UIFont.systemFontOfSize(14.0);
        self.titleLabel?.textColor          = UIColor.darkGrayColor();
        self.titleLabel?.text               = self.title;
    
        // buttons
        // calc the height
        self.frame = CGRectMake(0, SCREEN_BOUNDS.size.height - 20 - actionSheetHeight, 320, actionSheetHeight);
        
        self.buttonBgView.frame = CGRectMake(10, 0, CANCEL_BUTTON_WIDTH, buttonAreaHeight + titleHeight);
        self.buttonBgView.backgroundColor = RGB_HEX("ffffff", 0.9);
        self.buttonBgView.layer.cornerRadius = 4.0;
        self.buttonBgView.clipsToBounds = true;
        self.addSubview(self.buttonBgView);
        
        if SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO("8.0") {
            self.buttonBgView.backgroundColor = RGB_HEX("ffffff", 0.3);
            let effectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
            effectView.frame = CGRectMake(0, 0, CANCEL_BUTTON_WIDTH, buttonAreaHeight + titleHeight);
            self.buttonBgView.addSubview(effectView);
        }
        
        if ( self.titleLabel != nil ) {
            buttonBgView.addSubview(self.titleLabel!);
        }
    
        // cancel button
        self.cancelButton.frame = CGRectMake(10, self.frame.size.height - CANCEL_BUTTON_HEIGHT - 10, CANCEL_BUTTON_WIDTH, CANCEL_BUTTON_HEIGHT);
        self.cancelButton.layer.cornerRadius = 4.0;
        self.addSubview(self.cancelButton);
    
        // calc buttons' location
        let countInOneLine = ceil(CGFloat(self.buttonArray.count) / CGFloat(lineCount));
        let btnSpacing: CGFloat = (CANCEL_BUTTON_WIDTH - countInOneLine*BUTTON_FRAME.width) / (countInOneLine+1.0);
        for item in self.buttonArray {
            if let btn = item as? UIButton {
                self.buttonBgView.addSubview(btn);
                let idx = btn.tag;
                let btnRect:CGRect  = CGRectMake(
                    (btnSpacing + CGFloat(idx)%countInOneLine * (btnSpacing + BUTTON_FRAME.size.width)),
                    titleHeight + BUTTON_ROW_HEIGHT*CGFloat(idx/Int(countInOneLine)) + 5,
                    BUTTON_FRAME.size.width,
                    BUTTON_FRAME.size.height);
                btn.frame = btnRect;
            }
        }
        
        self.backgroundColor = UIColor.clearColor(); //RGBA(255, 255, 255, 0.7);//
        self.frame = CGRectMake(0, SCREEN_BOUNDS.size.height, 320, self.frame.size.height);
    }
}
