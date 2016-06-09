//
//  DZAlertView.swift
//  DZLib
//
//  Created by Dora.Yuan on 14/10/25.
//  Copyright (c) 2014年 Dora.Yuan All rights reserved.
//

import Foundation
import UIKit

public class DZAlertView : UIView {
    
// MARK: - Class define
    
    let ONLY_ONE_BUTTON_FRAME:CGRect    = CGRectMake(10.0, 0.0, 260.0, 45.0);
    let BUTTON_FRAME:CGRect             = CGRectMake(0.0, 0.0, 125.0, 45.0);
    let ALERT_VIEW_WIDTH:CGFloat        = 280.0;
    let CANCEL_BUTTON_TAG:Int           = 0;
    
// MARK: - public properties
    
    public private(set) var title: String    = "";
    public private(set) var message: String  = "";
    
    // cancel button color / text color
    private let cancelButtonColor:UIColor       = RGB(92, 177, 173);
    private let cancelButtonTextColor:UIColor   = RGB(255, 255, 255);
    
    // normal button color / text color
    private let normalButtonColor:UIColor       = RGB(136, 136, 136);
    private let normalButtonTextColor:UIColor   = RGB(255, 255, 255);
    
// MARK: - internal properties
    
    private var buttonArray:NSMutableArray                  = NSMutableArray();
    private var blockDictionary:Dictionary<Int, DZBlock>    = Dictionary();
    private var titleLabel:UILabel      = UILabel();
    private var messageLabel:UILabel    = UILabel();
    private var theWindow:UIWindow      = UIWindow(frame: UIScreen.mainScreen().bounds);
    
// MARK: - private properties
    
// MARK: - init
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private init(title: String, Message message: String) {
        let rect:CGRect = CGRectMake(0, 0, ALERT_VIEW_WIDTH, 100);
        
        super.init(frame: rect);
        
        self.frame = CGRectMake(0, 0, ALERT_VIEW_WIDTH, 100);
        
        // cancel button
        self.addCancelButtonWithTitle("Cancel", CancelBlock:nil);
        
        self.backgroundColor = UIColor.whiteColor();
        
        self.title      = title;
        self.message    = message;
    }
    
    private init(title: String, Message message: String = "", CancelTitle cancelTitle: String, CancelBlock cancelBlock:DZBlock) {
        let rect:CGRect = CGRectMake(0, 0, ALERT_VIEW_WIDTH, 100);
        
        super.init(frame: rect);
        
        self.frame = CGRectMake(0, 0, ALERT_VIEW_WIDTH, 100);
        
        // cancel button
        self.addCancelButtonWithTitle(cancelTitle, CancelBlock:cancelBlock);
        
        self.backgroundColor = UIColor.whiteColor();
        
        self.title      = title;
        self.message    = message;
    }
    
// MARK: - class functions
    
    public class func alertViewWithTitle(title: String, Message message: String = "") -> DZAlertView {
        return DZAlertView(title: title, Message: message);
    }
    
// MARK: - internal functions
    
    internal func addCancelButtonWithTitle(cancelTitle: String, CancelBlock cancelBlock:DZBlock?) {
        let btn = UIButton(type: UIButtonType.Custom);
        btn.setTitle(cancelTitle, forState: UIControlState.Normal);
        btn.backgroundColor = self.cancelButtonColor;
        btn.frame           = BUTTON_FRAME;
        btn.tag             = CANCEL_BUTTON_TAG;
        btn.addTarget(self, action: #selector(DZAlertView.buttonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside);
        self.buttonArray.addObject(btn);
    
        if ( cancelBlock != nil ) {
            self.blockDictionary[CANCEL_BUTTON_TAG] = cancelBlock;
        }
        else {
            self.blockDictionary.removeValueForKey(CANCEL_BUTTON_TAG);
        }
    }
    
    internal func setHandler(handler:DZBlock?, forButtonAtIndex index:Int) {
        if ( handler != nil ) {
            self.blockDictionary[index] = handler;
        }
        else {
            self.blockDictionary.removeValueForKey(index);
        }
    }
    
    internal func buttonClicked(sender: AnyObject) {
        let btnIdx = sender.tag;
        
        let block:DZBlock? = self.blockDictionary[btnIdx];
        
        if ( block != nil ) {
            block?();
        }
        
        self.dismiss();
        return;
    }
    
// MARK: - public functions
    
    public func setCancelButtonWithTitle(title: String, bgColor: UIColor? = nil, textColor: UIColor? = nil, handler: DZBlock?) {
        var btn:UIButton! = self.buttonArray.objectAtIndex(CANCEL_BUTTON_TAG) as? UIButton;
        if ( btn == nil ) {
            btn = UIButton(type: UIButtonType.Custom);
        }
        
        btn.setTitle(title, forState: UIControlState.Normal);
        btn.backgroundColor = (bgColor == nil) ? self.cancelButtonColor : bgColor;
        btn.setTitleColor((textColor == nil) ? self.cancelButtonTextColor : textColor, forState: UIControlState.Normal);
        btn.frame           = BUTTON_FRAME;
        btn.tag             = CANCEL_BUTTON_TAG;
        btn.addTarget(self, action: #selector(DZAlertView.buttonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside);
        self.setHandler(handler, forButtonAtIndex: CANCEL_BUTTON_TAG);
    }
    
    public func addButtonWithTitle(title: String, bgColor: UIColor? = nil, textColor: UIColor? = nil, handler:DZBlock?) {
        let btn = UIButton(type: UIButtonType.Custom);
        
        btn.setTitle(title, forState: UIControlState.Normal);
        self.buttonArray.addObject(btn);
        btn.backgroundColor = (bgColor == nil) ? self.normalButtonColor : bgColor;
        btn.setTitleColor((textColor == nil) ? self.normalButtonTextColor : textColor, forState: UIControlState.Normal);
        btn.frame           = BUTTON_FRAME;
        let index:Int       = self.buttonArray.indexOfObject(btn);
        btn.tag             = index;
        btn.addTarget(self, action: #selector(DZAlertView.buttonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside);
        
        self.setHandler(handler, forButtonAtIndex: index);
        return;
    }
    
    // MARK: - popup and dissmis
    
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
        self.theWindow.hidden = false;
        
        //self.theWindow = UIWindow(frame: UIScreen.mainScreen().bounds);
        self.theWindow.windowLevel = UIWindowLevelNormal;
        self.theWindow.opaque = false;
        self.theWindow.backgroundColor = RGBA(0, 0, 0, 0.3);
        
        self.theWindow.addSubview(self);
        
        if flag {
            self.theWindow.alpha = 0.0;
            self.theWindow.transform = CGAffineTransformMakeScale(ANIMATION_SCALE, ANIMATION_SCALE);
            
            UIView.animateWithDuration(ANIMATION_SPEED, delay: 0.0, options: UIViewAnimationOptions.AllowUserInteraction,
                animations: { () -> Void in
                    self.theWindow.alpha = 1.0;
                    self.theWindow.transform = CGAffineTransformIdentity;
                },
                completion: nil);
        }
        
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
            UIView.animateWithDuration(ANIMATION_SPEED,
                animations: { () -> Void in
                    self.onWindowWillDismiss();
                }, completion: { (finished) -> Void in
                    self.onWindowDidDismiss(finish);
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
            weak var weakSelf:DZAlertView? = self;
            dispatch_group_async( self.group!, self.queue!, { ()->Void in
                let strongSelf:DZAlertView? = weakSelf;
                
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
    
    public override func layoutSubviews() {
        self.layer.cornerRadius = 8.0;
        
        var rect:CGRect             = CGRectMake(10, 5, ALERT_VIEW_WIDTH - 20, 40);
        
        var alertViewHeight:CGFloat = rect.size.height + 10.0;
        // labels
        self.titleLabel.frame               = rect;
        self.titleLabel.textAlignment       = NSTextAlignment.Center;
        self.titleLabel.backgroundColor     = UIColor.clearColor();
        self.titleLabel.font                = UIFont.boldSystemFontOfSize(18.0);
        self.titleLabel.textColor           = UIColor.darkTextColor();
        self.titleLabel.text                = self.title;
        self.addSubview(self.titleLabel);
        
        //var messageSize:CGSize = self.message.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(16.0)]);
        
        if self.message != "" {
            let msgRect:CGRect = self.message.boundingRectWithSize(
                CGSizeMake(ALERT_VIEW_WIDTH - 20, CGFloat.max),
                options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                attributes: [NSFontAttributeName:UIFont.systemFontOfSize(16.0)],
                context: nil);
            
            rect = CGRectMake(10, 10 + 40, ALERT_VIEW_WIDTH-20, msgRect.size.height);
            alertViewHeight += (msgRect.size.height + 30.0);
            self.messageLabel.frame = rect;
            self.messageLabel.lineBreakMode     = NSLineBreakMode.ByWordWrapping;
            self.messageLabel.numberOfLines     = 0;
            
            if ( msgRect.size.height > 20 ) {
                self.messageLabel.textAlignment     = NSTextAlignment.Center;
            }
            else {
                self.messageLabel.textAlignment     = NSTextAlignment.Center;
            }
            self.messageLabel.backgroundColor   = UIColor.clearColor();
            self.messageLabel.font              = UIFont.systemFontOfSize(16.0);
            self.messageLabel.textColor         = UIColor.darkTextColor();
            self.messageLabel.text              = self.message;
            self.addSubview(self.messageLabel);
        }
        else {
            alertViewHeight += 30.0;
        }
        
        //
        if ( self.buttonArray.count <= 2 ) {
            alertViewHeight += 45.0;
        }
        else {
            alertViewHeight += (45.0 + 10.0) * CGFloat(self.buttonArray.count) - 10;
        }
        
        self.frame                  = CGRectMake(0, 0, 280, alertViewHeight);
        self.center                 = self.theWindow.center;
        self.layer.shadowColor      = UIColor.grayColor().CGColor;
        self.layer.shadowOffset     = CGSizeMake(0, 0);
        self.layer.shadowRadius     = 4.0;
        self.layer.shadowOpacity    = 0.6;
        
        // buttons
        if ( self.buttonArray.count == 1 ) {
            let btn = self.buttonArray.objectAtIndex(0) as! UIButton;
            self.addSubview(btn);
            let btnIdx:Int = btn.tag;
            btn.layer.cornerRadius = 4.0;
            btn.titleLabel?.font = UIFont.boldSystemFontOfSize(18.0);
            btn.frame = CGRectMake(
                10.0 + 135.0 * CGFloat(btnIdx),
                self.frame.size.height - 55.0,
                ONLY_ONE_BUTTON_FRAME.size.width,
                ONLY_ONE_BUTTON_FRAME.size.height);
        }
        else if ( self.buttonArray.count == 2 ) {
            for item in self.buttonArray {
                if let btn = item as? UIButton {
                    self.addSubview(btn);
                    let btnIdx:Int = btn.tag;
                    btn.layer.cornerRadius = 4.0;
                    btn.titleLabel?.font = UIFont.boldSystemFontOfSize(18.0);
                    btn.frame = CGRectMake(
                        10.0 + 135.0 * CGFloat(btnIdx),
                        self.frame.size.height - 55.0,
                        BUTTON_FRAME.size.width,
                        BUTTON_FRAME.size.height);
                }
            }
        }
        else
        {
            for item in self.buttonArray {
                if let btn = item as? UIButton {
                    self.addSubview(btn);
                    let btnIdx:Int = btn.tag;
                    btn.layer.cornerRadius = 4.0;
                    btn.titleLabel?.font = UIFont.boldSystemFontOfSize(18.0);
                    btn.frame = CGRectMake(
                        10.0,
                        self.frame.size.height - 55.0 * CGFloat(btnIdx+1),
                        ONLY_ONE_BUTTON_FRAME.size.width,
                        ONLY_ONE_BUTTON_FRAME.size.height);
                }
            }
        }
    }

}