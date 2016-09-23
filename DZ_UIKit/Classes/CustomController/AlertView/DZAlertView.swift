//
//  DZAlertView.swift
//  DZLib
//
//  Created by Dora.Yuan on 14/10/25.
//  Copyright (c) 2014年 Dora.Yuan All rights reserved.
//

import Foundation
import UIKit

open class DZAlertView : UIView {
    
// MARK: - Class define
    
    let ONLY_ONE_BUTTON_FRAME:CGRect    = CGRect(x: 10.0, y: 0.0, width: 260.0, height: 45.0);
    let BUTTON_FRAME:CGRect             = CGRect(x: 0.0, y: 0.0, width: 125.0, height: 45.0);
    let ALERT_VIEW_WIDTH:CGFloat        = 280.0;
    let CANCEL_BUTTON_TAG:Int           = 0;
    
// MARK: - public properties
    
    open fileprivate(set) var title: String    = "";
    open fileprivate(set) var message: String  = "";
    
    // cancel button color / text color
    fileprivate let cancelButtonColor:UIColor       = RGB(92, 177, 173);
    fileprivate let cancelButtonTextColor:UIColor   = RGB(255, 255, 255);
    
    // normal button color / text color
    fileprivate let normalButtonColor:UIColor       = RGB(136, 136, 136);
    fileprivate let normalButtonTextColor:UIColor   = RGB(255, 255, 255);
    
// MARK: - internal properties
    
    fileprivate var buttonArray:NSMutableArray                  = NSMutableArray();
    fileprivate var blockDictionary:Dictionary<Int, DZBlock>    = Dictionary();
    fileprivate var titleLabel:UILabel      = UILabel();
    fileprivate var messageLabel:UILabel    = UILabel();
    fileprivate var theWindow:UIWindow      = UIWindow(frame: UIScreen.main.bounds);
    
// MARK: - private properties
    
// MARK: - init
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate init(title: String, Message message: String) {
        let rect:CGRect = CGRect(x: 0, y: 0, width: ALERT_VIEW_WIDTH, height: 100);
        
        super.init(frame: rect);
        
        self.frame = CGRect(x: 0, y: 0, width: ALERT_VIEW_WIDTH, height: 100);
        
        // cancel button
        self.addCancelButtonWithTitle("Cancel", CancelBlock:nil);
        
        self.backgroundColor = UIColor.white;
        
        self.title      = title;
        self.message    = message;
    }
    
    fileprivate init(title: String, Message message: String = "", CancelTitle cancelTitle: String, CancelBlock cancelBlock:@escaping DZBlock) {
        let rect:CGRect = CGRect(x: 0, y: 0, width: ALERT_VIEW_WIDTH, height: 100);
        
        super.init(frame: rect);
        
        self.frame = CGRect(x: 0, y: 0, width: ALERT_VIEW_WIDTH, height: 100);
        
        // cancel button
        self.addCancelButtonWithTitle(cancelTitle, CancelBlock:cancelBlock);
        
        self.backgroundColor = UIColor.white;
        
        self.title      = title;
        self.message    = message;
    }
    
// MARK: - class functions
    
    open class func alertViewWithTitle(_ title: String, Message message: String = "") -> DZAlertView {
        return DZAlertView(title: title, Message: message);
    }
    
// MARK: - internal functions
    
    internal func addCancelButtonWithTitle(_ cancelTitle: String, CancelBlock cancelBlock:DZBlock?) {
        let btn = UIButton(type: UIButtonType.custom);
        btn.setTitle(cancelTitle, for: UIControlState());
        btn.backgroundColor = self.cancelButtonColor;
        btn.frame           = BUTTON_FRAME;
        btn.tag             = CANCEL_BUTTON_TAG;
        btn.addTarget(self, action: #selector(DZAlertView.buttonClicked(_:)), for: UIControlEvents.touchUpInside);
        self.buttonArray.add(btn);
    
        if ( cancelBlock != nil ) {
            self.blockDictionary[CANCEL_BUTTON_TAG] = cancelBlock;
        }
        else {
            self.blockDictionary.removeValue(forKey: CANCEL_BUTTON_TAG);
        }
    }
    
    internal func setHandler(_ handler:DZBlock?, forButtonAtIndex index:Int) {
        if ( handler != nil ) {
            self.blockDictionary[index] = handler;
        }
        else {
            self.blockDictionary.removeValue(forKey: index);
        }
    }
    
    internal func buttonClicked(_ sender: AnyObject) {
        let btnIdx = sender.tag;
        
        let block:DZBlock? = self.blockDictionary[btnIdx!];
        
        if ( block != nil ) {
            block?();
        }
        
        self.dismiss();
        return;
    }
    
// MARK: - public functions
    
    open func setCancelButtonWithTitle(_ title: String, bgColor: UIColor? = nil, textColor: UIColor? = nil, handler: DZBlock?) {
        var btn:UIButton! = self.buttonArray.object(at: CANCEL_BUTTON_TAG) as? UIButton;
        if ( btn == nil ) {
            btn = UIButton(type: UIButtonType.custom);
        }
        
        btn.setTitle(title, for: UIControlState());
        btn.backgroundColor = (bgColor == nil) ? self.cancelButtonColor : bgColor;
        btn.setTitleColor((textColor == nil) ? self.cancelButtonTextColor : textColor, for: UIControlState());
        btn.frame           = BUTTON_FRAME;
        btn.tag             = CANCEL_BUTTON_TAG;
        btn.addTarget(self, action: #selector(DZAlertView.buttonClicked(_:)), for: UIControlEvents.touchUpInside);
        self.setHandler(handler, forButtonAtIndex: CANCEL_BUTTON_TAG);
    }
    
    open func addButtonWithTitle(_ title: String, bgColor: UIColor? = nil, textColor: UIColor? = nil, handler:DZBlock?) {
        let btn = UIButton(type: UIButtonType.custom);
        
        btn.setTitle(title, for: UIControlState());
        self.buttonArray.add(btn);
        btn.backgroundColor = (bgColor == nil) ? self.normalButtonColor : bgColor;
        btn.setTitleColor((textColor == nil) ? self.normalButtonTextColor : textColor, for: UIControlState());
        btn.frame           = BUTTON_FRAME;
        let index:Int       = self.buttonArray.index(of: btn);
        btn.tag             = index;
        btn.addTarget(self, action: #selector(DZAlertView.buttonClicked(_:)), for: UIControlEvents.touchUpInside);
        
        self.setHandler(handler, forButtonAtIndex: index);
        return;
    }
    
    // MARK: - popup and dissmis
    
    let ANIMATION_SPEED:TimeInterval = 0.2;
    let ANIMATION_SCALE:CGFloat = 1.15;
    fileprivate var queue:DispatchQueue?;
    fileprivate var group:DispatchGroup?;
    fileprivate var semaphore:DispatchSemaphore?;
    
    open func show() {
        self.showWithAnimation(true);
    }
    
    open func dismiss() {
        self.dismissWithAnimation(true);
    }
    
    open func showWithAnimation(_ flag:Bool) {
        
        // set all items
        self.setNeedsLayout();
        self.theWindow.isHidden = false;
        
        //self.theWindow = UIWindow(frame: UIScreen.mainScreen().bounds);
        self.theWindow.windowLevel = UIWindowLevelNormal;
        self.theWindow.isOpaque = false;
        self.theWindow.backgroundColor = RGBA(0, 0, 0, 0.3);
        
        self.theWindow.addSubview(self);
        
        if flag {
            self.theWindow.alpha = 0.0;
            self.theWindow.transform = CGAffineTransform(scaleX: ANIMATION_SCALE, y: ANIMATION_SCALE);
            
            UIView.animate(withDuration: ANIMATION_SPEED, delay: 0.0, options: UIViewAnimationOptions.allowUserInteraction,
                animations: { () -> Void in
                    self.theWindow.alpha = 1.0;
                    self.theWindow.transform = CGAffineTransform.identity;
                },
                completion: nil);
        }
        
        self.queue = DispatchQueue.global( priority: DispatchQueue.GlobalQueuePriority.default);
        self.group = DispatchGroup();
        self.semaphore = DispatchSemaphore(value: 0);
        
        // 参考 http://www.swiftmi.com/topic/96.html
        self.queue!.async(group: self.group!, execute: { () -> Void in
            var _:DispatchTimeoutResult = self.semaphore!.wait(timeout: DispatchTime.distantFuture);
        });
    }
    
    open func dismissWithAnimation(_ flag:Bool) {
        self.dismissWindowWithAnimation(true, Finish:true);
    }
    
    fileprivate func dismissWindowWithAnimation(_ animated:Bool, Finish finish:Bool) {
        
        self.theWindow.alpha = 1.0;
        self.theWindow.transform = CGAffineTransform.identity;

        if( animated ) {
            UIView.animate(withDuration: ANIMATION_SPEED,
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
    
    fileprivate func onWindowWillDismiss() {
        self.theWindow.alpha = 0.0;
        self.theWindow.transform = CGAffineTransform( scaleX: ANIMATION_SCALE, y: ANIMATION_SCALE );
    }
    
    fileprivate func onWindowDidDismiss(_ finish:Bool) {
        self.theWindow.isHidden = true;
        self.removeFromSuperview();
        self.theWindow.removeFromSuperview();
        //self.theWindow = nil;
        
        if( self.group != nil && self.queue != nil ) {
            weak var weakSelf:DZAlertView? = self;
            self.queue!.async( group: self.group!, execute: { ()->Void in
                let strongSelf:DZAlertView? = weakSelf;
                
                if( strongSelf != nil && strongSelf?.semaphore != nil ) {
                    strongSelf!.semaphore!.signal();
                    
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
    
    open override func layoutSubviews() {
        self.layer.cornerRadius = 8.0;
        
        var rect:CGRect             = CGRect(x: 10, y: 5, width: ALERT_VIEW_WIDTH - 20, height: 40);
        
        var alertViewHeight:CGFloat = rect.size.height + 10.0;
        // labels
        self.titleLabel.frame               = rect;
        self.titleLabel.textAlignment       = NSTextAlignment.center;
        self.titleLabel.backgroundColor     = UIColor.clear;
        self.titleLabel.font                = UIFont.boldSystemFont(ofSize: 18.0);
        self.titleLabel.textColor           = UIColor.darkText;
        self.titleLabel.text                = self.title;
        self.addSubview(self.titleLabel);
        
        //var messageSize:CGSize = self.message.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(16.0)]);
        
        if self.message != "" {
            let msgRect:CGRect = self.message.boundingRect(
                with: CGSize(width: ALERT_VIEW_WIDTH - 20, height: CGFloat.greatestFiniteMagnitude),
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 16.0)],
                context: nil);
            
            rect = CGRect(x: 10, y: 10 + 40, width: ALERT_VIEW_WIDTH-20, height: msgRect.size.height);
            alertViewHeight += (msgRect.size.height + 30.0);
            self.messageLabel.frame = rect;
            self.messageLabel.lineBreakMode     = NSLineBreakMode.byWordWrapping;
            self.messageLabel.numberOfLines     = 0;
            
            if ( msgRect.size.height > 20 ) {
                self.messageLabel.textAlignment     = NSTextAlignment.center;
            }
            else {
                self.messageLabel.textAlignment     = NSTextAlignment.center;
            }
            self.messageLabel.backgroundColor   = UIColor.clear;
            self.messageLabel.font              = UIFont.systemFont(ofSize: 16.0);
            self.messageLabel.textColor         = UIColor.darkText;
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
        
        self.frame                  = CGRect(x: 0, y: 0, width: 280, height: alertViewHeight);
        self.center                 = self.theWindow.center;
        self.layer.shadowColor      = UIColor.gray.cgColor;
        self.layer.shadowOffset     = CGSize(width: 0, height: 0);
        self.layer.shadowRadius     = 4.0;
        self.layer.shadowOpacity    = 0.6;
        
        // buttons
        if ( self.buttonArray.count == 1 ) {
            let btn = self.buttonArray.object(at: 0) as! UIButton;
            self.addSubview(btn);
            let btnIdx:Int = btn.tag;
            btn.layer.cornerRadius = 4.0;
            btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0);
            btn.frame = CGRect(
                x: 10.0 + 135.0 * CGFloat(btnIdx),
                y: self.frame.size.height - 55.0,
                width: ONLY_ONE_BUTTON_FRAME.size.width,
                height: ONLY_ONE_BUTTON_FRAME.size.height);
        }
        else if ( self.buttonArray.count == 2 ) {
            for item in self.buttonArray {
                if let btn = item as? UIButton {
                    self.addSubview(btn);
                    let btnIdx:Int = btn.tag;
                    btn.layer.cornerRadius = 4.0;
                    btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0);
                    btn.frame = CGRect(
                        x: 10.0 + 135.0 * CGFloat(btnIdx),
                        y: self.frame.size.height - 55.0,
                        width: BUTTON_FRAME.size.width,
                        height: BUTTON_FRAME.size.height);
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
                    btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0);
                    btn.frame = CGRect(
                        x: 10.0,
                        y: self.frame.size.height - 55.0 * CGFloat(btnIdx+1),
                        width: ONLY_ONE_BUTTON_FRAME.size.width,
                        height: ONLY_ONE_BUTTON_FRAME.size.height);
                }
            }
        }
    }

}
