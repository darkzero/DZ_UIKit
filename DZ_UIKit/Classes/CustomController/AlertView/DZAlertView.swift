//
//  DZAlertView.swift
//  DZ_UIKit
//
//  Created by Dora.Yuan on 14/10/25.
//  Copyright (c) 2014年 Dora.Yuan All rights reserved.
//

import Foundation
import UIKit

// MARK: - delegate protocol
internal protocol DZAlertViewDelegate {
    func onButtonClicked(atIndex index: Int);
    func onCancelButtonClicked();
}

open class DZAlertView : UIView {
    
// MARK: - Class define
    
    let ONLY_ONE_BUTTON_FRAME:CGRect    = CGRect(x: 10.0, y: 0.0, width: 260.0, height: 45.0);
    let BUTTON_FRAME:CGRect             = CGRect(x: 0.0, y: 0.0, width: 125.0, height: 45.0);
    let ALERT_VIEW_WIDTH:CGFloat        = 280.0;
    let CANCEL_BUTTON_TAG:Int           = 0;
    
// MARK: - public properties
    
    internal fileprivate(set) var title: String    = "";
    internal fileprivate(set) var message: String?;
    
    // cancel button color / text color
    fileprivate let cancelButtonColor:UIColor       = RGB(92, 177, 173);
    fileprivate let cancelButtonTextColor:UIColor   = RGB(255, 255, 255);
    
    // normal button color / text color
    fileprivate let normalButtonColor:UIColor       = RGB(136, 136, 136);
    fileprivate let normalButtonTextColor:UIColor   = RGB(255, 255, 255);
    
// MARK: - internal properties
    
// MARK: - private properties
    
    fileprivate var buttonArray             = [UIButton]();
    fileprivate var blockDictionary         = [Int: DZBlock]();
    fileprivate var titleLabel:UILabel      = UILabel();
    fileprivate var messageLabel:UILabel    = UILabel();
    //fileprivate var buttonBgView            = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.light));

// MARK: - delegate
    var delegate: DZAlertViewDelegate?;
    
// MARK: - init
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal init(title: String, message: String? = nil, cancelTitle: String = "Cancel") {
        let rect:CGRect = CGRect(x: 0, y: 0, width: ALERT_VIEW_WIDTH, height: 100);
        
        super.init(frame: rect);
        
        self.frame = CGRect(x: 0, y: 0, width: ALERT_VIEW_WIDTH, height: 100);
        
        // cancel button
        self.addCancelButton(title: cancelTitle);
        
        self.backgroundColor = RGB_HEX("ffffff", 0.7);
        
        self.title      = title;
        self.message    = message;
    }
    
// MARK: - internal functions
    
    internal func addCancelButton(title: String) {
        let btn = UIButton(type: .custom);
        btn.setTitle(title, for: .normal);
        btn.setBackgroundImage(UIImage.imageWithColor(self.cancelButtonColor), for: .normal);
        btn.setBackgroundImage(UIImage.imageWithColor(self.cancelButtonColor.withAlphaComponent(0.6)), for: .highlighted);
        
        btn.frame           = BUTTON_FRAME;
        btn.tag             = CANCEL_BUTTON_TAG;
        btn.clipsToBounds = true;
        
        btn.addTarget(self, action: #selector(cancelButtonClicked), for: UIControlEvents.touchUpInside);
        self.buttonArray.append(btn);
    }
    
    @objc internal func cancelButtonClicked() {
        self.delegate?.onCancelButtonClicked();
    }
    
    @objc internal func buttonClicked(sender: AnyObject) {
        let btnIdx = sender.tag;
        self.delegate?.onButtonClicked(atIndex: btnIdx!);
        return;
    }
    
// MARK: - public functions
    
    public func setCancelButton(title: String, bgColor: UIColor? = nil, textColor: UIColor? = nil) {
        var btn:UIButton! = self.buttonArray[CANCEL_BUTTON_TAG];
        if ( btn == nil ) {
            btn = UIButton(type: .custom);
            btn.frame           = BUTTON_FRAME;
            btn.tag             = CANCEL_BUTTON_TAG;
            btn.addTarget(self, action: #selector(cancelButtonClicked), for: UIControlEvents.touchUpInside);
        }
        
        btn.setTitle(title, for: .normal);
        
        let _bgColor    = bgColor ?? self.cancelButtonColor;
        let _textColor  = textColor ?? self.cancelButtonTextColor;
        
        btn.setBackgroundImage(UIImage.imageWithColor(_bgColor), for: .normal);
        btn.setBackgroundImage(UIImage.imageWithColor(_bgColor.withAlphaComponent(0.6)), for: .highlighted);
        
        btn.setTitleColor(_textColor, for: .normal);
        
        return;
    }
    
    public func addButton(title: String, bgColor: UIColor? = nil, textColor: UIColor? = nil) -> Int {
        let btn = UIButton(type: .custom);
        
        btn.setTitle(title, for: UIControlState());
        
        self.buttonArray.append(btn);
        
        let _bgColor    = bgColor ?? self.normalButtonColor;
        let _textColor  = textColor ?? self.normalButtonTextColor;
        
        btn.setBackgroundImage(UIImage.imageWithColor(_bgColor), for: .normal);
        btn.setBackgroundImage(UIImage.imageWithColor(_bgColor.withAlphaComponent(0.6)), for: .highlighted);
        
        btn.setTitleColor(_textColor, for: .normal);
        
        btn.frame   = BUTTON_FRAME;
        let index   = self.buttonArray.index(of: btn)!;
        btn.tag     = index;
        btn.clipsToBounds = true;
        
        btn.addTarget(self, action: #selector(buttonClicked(sender:)), for: UIControlEvents.touchUpInside);
        
        return index;
    }
    
// MARK: - layoutSubviews
    
    open override func layoutSubviews() {
        self.layer.cornerRadius = 8.0;
        
        var rect:CGRect             = CGRect(x: 10, y: 5, width: ALERT_VIEW_WIDTH - 20, height: 40);
        
        self.layer.shadowColor      = UIColor.gray.cgColor;
        self.layer.shadowOffset     = CGSize(width: 0, height: 0);
        self.layer.shadowRadius     = 4.0;
        self.layer.shadowOpacity    = 0.6;
        
        //self.buttonBgView.layer.cornerRadius = 8.0;
        //self.buttonBgView.clipsToBounds = true;
        //self.buttonBgView.backgroundColor = RGB_HEX("ffffff", 0.3);
        //self.addSubview(self.buttonBgView);
        
        var alertViewHeight:CGFloat = rect.size.height + 10.0;
        // labels
        self.titleLabel.frame               = rect;
        self.titleLabel.textAlignment       = NSTextAlignment.center;
        self.titleLabel.backgroundColor     = UIColor.clear;
        self.titleLabel.font                = UIFont.boldSystemFont(ofSize: 18.0);
        self.titleLabel.textColor           = UIColor.darkText;
        self.titleLabel.text                = self.title;
        self.addSubview(self.titleLabel);
        
        if self.message != nil {
            let msgRect:CGRect = self.message!.boundingRect(
                with: CGSize(width: ALERT_VIEW_WIDTH - 20, height: CGFloat.greatestFiniteMagnitude),
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16.0)],
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
            alertViewHeight += 10.0;
        }
        
        //
        if ( self.buttonArray.count <= 2 ) {
            alertViewHeight += 45.0;
        }
        else {
            alertViewHeight += (45.0 + 10.0) * CGFloat(self.buttonArray.count) - 10;
        }
        
        self.frame                  = CGRect(x: 0, y: 0, width: 280, height: alertViewHeight);
        
        self.center = CGPoint(x: SCREEN_BOUNDS().size.width/2,
                              y: SCREEN_BOUNDS().size.height/2);
        self.alpha = 0.2;
        
        // buttons
        if ( self.buttonArray.count == 1 ) {
            let btn = self.buttonArray[0];
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
            for btn in self.buttonArray {
                self.addSubview(btn);
                let btnIdx:Int = btn.tag;
                btn.layer.cornerRadius = 4.0;
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0);
                btn.frame = CGRect(
                    x: 10.0 + 135.0 * CGFloat(1 - btnIdx),
                    y: self.frame.size.height - 55.0,
                    width: BUTTON_FRAME.size.width,
                    height: BUTTON_FRAME.size.height);
            }
        }
        else
        {
            for btn in self.buttonArray {
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
