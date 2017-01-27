//
//  DZActionSheet.swift
//  DZ_UIKit
//
//  Created by Dora.Yuan on 2014/10/21.
//  Copyright (c) 2014 Dora.Yuan All rights reserved.
//

import Foundation
import UIKit

//private func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l < r
//  case (nil, _?):
//    return true
//  default:
//    return false
//  }
//}
//
//private func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l >= r
//  default:
//    return !(lhs < rhs)
//  }
//}

// MARK: - delegate protocol
internal protocol DZActionSheetDelegate {
    func onButtonClicked(atIndex index: Int);
    func onCancelButtonClicked();
}

internal class DZActionSheet : UIControl {
    
// MARK: - class define
    
    let BUTTON_FRAME: CGRect            = CGRect(x: 0.0, y: 0.0, width: 64.0, height: 70.0);
    let CANCEL_BUTTON_HEIGHT: CGFloat   = 44.0;
    let CANCEL_BUTTON_WIDTH: CGFloat    = min(SCREEN_BOUNDS().size.width, SCREEN_BOUNDS().size.height) - 20;
    let VIEW_WIDTH: CGFloat             = min(SCREEN_BOUNDS().size.width, SCREEN_BOUNDS().size.height);
    let BUTTON_ROW_HEIGHT: CGFloat      = 70.0;
    let TITLE_LABEL_HEIGHT: CGFloat     = 30.0;
    
// MARK: - internal properties
    
// MARK: - private properties
    
    private var title: String                      = "";
    private var cancelButtonBgColor: UIColor       = UIColor.white;
    private var cancelButtonTitleColor: UIColor    = RGB(109, 109, 109);
    
    private var buttonArray                = [UIButton]();
    private var cancelButton               = UIButton(type: UIButtonType.custom);
    private var titleLabel:UILabel?;
    private var buttonBgView               = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.light));
    
// MARK: - delegate
    var delegate: DZActionSheetDelegate?;
    
// MARK: - init functions
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(frame:CGRect) {
        super.init(frame:frame);
    }
    
    public init() {
        super.init(frame: CGRect.zero);
    }
    
    public init(title: String, cancelTitle: String = "Cancel") {
        let rect:CGRect = CGRect(x: 0,
                                 y: SCREEN_BOUNDS().size.height - CANCEL_BUTTON_HEIGHT,
                                 width: SCREEN_BOUNDS().size.width,
                                 height: CANCEL_BUTTON_HEIGHT);
        super.init(frame: rect);
        self.title = title;
        self.setCancelButton(withTitle: cancelTitle);
    }
    
// MARK: - set Buttons
    
    internal func setCancelButton(withTitle title: String = "Cancel") {
        self.cancelButton.frame            = CGRect(x: 0, y: 0, width: CANCEL_BUTTON_WIDTH, height: CANCEL_BUTTON_HEIGHT);
        self.cancelButton.backgroundColor  = RGB_HEX("ffffff", 1.0);
        self.cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20.0);
        self.cancelButton.setTitle(title, for: UIControlState());
        self.cancelButton.setTitleColor(RGB(109, 109, 109), for: UIControlState());
        self.cancelButton.addTarget(self, action: #selector(DZActionSheet.cancelButtonClicked(_:)), for: UIControlEvents.touchUpInside);
    }
    
    internal func addButton (withTitle buttonTitle: String,
                                characterColor: UIColor?,
                                imageNormal: String?,
                                imageHighlighted: String?,
                                imageDisabled: String?) -> Int {
            
        let btn:UIButton! = UIButton(type: UIButtonType.custom);
        
        btn.setTitle(buttonTitle, for: UIControlState());
        btn.setTitleColor(UIColor.darkGray, for: UIControlState());
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12.0);
        btn.titleLabel?.adjustsFontSizeToFitWidth = true;
        btn.backgroundColor = UIColor.clear;
    
        btn.imageView?.frame.size = CGSize(width: 48, height: 48);
        btn.imageView?.layer.cornerRadius = 24.0;
        var btnImage: UIImage;
        if ( imageNormal != nil ) {
            btnImage = UIImage(named: imageNormal!)!;
        }
        else {
            let g = (characterColor != nil) ? characterColor!.getGary() : 0;
            btnImage = UIImage.imageWithColor(characterColor!, size: CGSize(width: 48, height: 48));
            let initialChar = buttonTitle.substring(to: buttonTitle.characters.index(buttonTitle.startIndex, offsetBy: 1));
            let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 48, height: 48));
            lbl.font = UIFont.boldSystemFont(ofSize: 28.0);
            if g >= 175 {
                lbl.textColor = RGB_HEX("444444", 1.0);
            }
            else {
                lbl.textColor = RGB_HEX("FFFFFF", 1.0);
            }
            lbl.textAlignment = NSTextAlignment.center;
            lbl.text = initialChar;
            btn.imageView?.addSubview(lbl);
        }
        btn.contentMode = UIViewContentMode.scaleAspectFill;
        btn.setImage(btnImage, for: UIControlState());
        
        btn.layer.cornerRadius = 8.0;
        
        if ( imageHighlighted != nil ) {
            btn.setImage(UIImage(named: imageHighlighted!), for: UIControlState.highlighted);
        }
        if ( imageDisabled != nil ) {
            btn.setImage(UIImage(named: imageDisabled!), for: UIControlState.disabled);
        }
        btn.frame = BUTTON_FRAME;
        //btn.backgroundColor = UIColor.redColor();
    
        self.buttonArray.append(btn);
        
        btn.contentHorizontalAlignment  = UIControlContentHorizontalAlignment.center;
        btn.contentVerticalAlignment    = UIControlContentVerticalAlignment.top;
        btn.imageEdgeInsets             = UIEdgeInsetsMake(0.0, 8.0, 22.0, 8.0);
        btn.titleEdgeInsets             = UIEdgeInsetsMake(50, -1*btnImage.size.width, 0, 0);
        
        let index:Int = self.buttonArray.index(of: btn)!;
        btn.tag = index;
        btn.addTarget(self, action: #selector(DZActionSheet.buttonClicked(_:)), for: UIControlEvents.touchUpInside);
        
        return index;
    }
    
    internal func setButtonState(_ buttonState:UIControlState, AtIndex buttonIndex:Int) {
        let btn = self.buttonArray[buttonIndex];
        
        switch ( buttonState ) {
        case UIControlState() :
            btn.isEnabled     = true;
            btn.isHighlighted = false;
            break;
        case UIControlState.disabled :
            btn.isEnabled     = false;
            btn.isHighlighted = false;
            break;
        case UIControlState.highlighted :
            btn.isEnabled     = true;
            btn.isHighlighted = true;
            break;
        default :
            break;
        }
    }
    
    internal func buttonClicked(_ sender:AnyObject) {
        let btnIdx = sender.tag;
        self.delegate?.onButtonClicked(atIndex: btnIdx!);
        return;
    }
    
    internal func cancelButtonClicked(_ sender:AnyObject) {
        self.delegate?.onCancelButtonClicked();
        return;
    }
    
// MARK: - layoutSubviews
    
    override open func layoutSubviews() {
        
        UITraitCollection(horizontalSizeClass: .regular);
        
        let rect:CGRect = CGRect(x: 0.0, y: 0.0, width: CANCEL_BUTTON_WIDTH, height: TITLE_LABEL_HEIGHT);
        
        // calc the height
        let titleHeight         = TITLE_LABEL_HEIGHT;
        let btnCount            = self.buttonArray.count;
        let lineCount           = (btnCount + 3 )/4;
        let buttonAreaHeight    = CGFloat(lineCount) * BUTTON_ROW_HEIGHT + 10
        
        let actionSheetHeight       = CANCEL_BUTTON_HEIGHT + buttonAreaHeight + titleHeight + 20;
    
        // labels
        self.titleLabel                     = UILabel(frame: rect);
        self.titleLabel?.textAlignment      = NSTextAlignment.center;
        self.titleLabel?.backgroundColor    = UIColor.clear;
        self.titleLabel?.font               = UIFont.systemFont(ofSize: 14.0);
        self.titleLabel?.textColor          = UIColor.darkGray;
        self.titleLabel?.text               = self.title;
    
        // buttons
        // calc the height
        self.frame = CGRect(x: 0, y: SCREEN_BOUNDS().size.height - 20 - actionSheetHeight, width: VIEW_WIDTH, height: actionSheetHeight);
        
        self.buttonBgView.frame = CGRect(x: 10, y: 0, width: CANCEL_BUTTON_WIDTH, height: buttonAreaHeight + titleHeight);
        self.buttonBgView.layer.cornerRadius = 8.0;
        self.buttonBgView.clipsToBounds = true;
        self.addSubview(self.buttonBgView);
        
        self.buttonBgView.backgroundColor = RGB_HEX("ffffff", 0.3);
        
        if ( self.titleLabel != nil ) {
            buttonBgView.addSubview(self.titleLabel!);
        }
    
        // cancel button
        self.cancelButton.frame = CGRect(x: 10, y: self.frame.size.height - CANCEL_BUTTON_HEIGHT - 10, width: CANCEL_BUTTON_WIDTH, height: CANCEL_BUTTON_HEIGHT);
        self.cancelButton.layer.cornerRadius = 8.0;
        self.addSubview(self.cancelButton);
    
        // calc buttons' location
        let countInOneLine = ceil(CGFloat(self.buttonArray.count) / CGFloat(lineCount));
        let btnSpacing: CGFloat = (CANCEL_BUTTON_WIDTH - countInOneLine*BUTTON_FRAME.width) / (countInOneLine+1.0);
        for item in self.buttonArray {
            if let btn = item as? UIButton {
                self.buttonBgView.addSubview(btn);
                let idx = btn.tag;
                let btnRect:CGRect  = CGRect(
                    x: (btnSpacing + CGFloat(idx).truncatingRemainder(dividingBy: countInOneLine) * (btnSpacing + BUTTON_FRAME.size.width)),
                    y: titleHeight + BUTTON_ROW_HEIGHT*CGFloat(idx/Int(countInOneLine)) + 5,
                    width: BUTTON_FRAME.size.width,
                    height: BUTTON_FRAME.size.height);
                btn.frame = btnRect;
            }
        }
        
        self.backgroundColor = UIColor.clear; //RGBA(255, 255, 255, 0.7);//
        self.frame.size = CGSize(width: VIEW_WIDTH, height: self.frame.size.height);
        self.center = CGPoint(x: SCREEN_BOUNDS().size.width/2, y: SCREEN_BOUNDS().size.height + self.frame.size.height/2);
    }
}
