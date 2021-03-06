//
//  DZActionSheet.swift
//  DZ_UIKit
//
//  Created by Dora.Yuan on 2014/10/21.
//  Copyright (c) 2014 Dora.Yuan All rights reserved.
//

import Foundation
import UIKit

// MARK: - delegate protocol
internal protocol DZActionSheetDelegate {
    func onButtonClicked(atIndex index: Int);
    func onCancelButtonClicked();
}

internal class DZActionSheet : UIControl {
    // MARK: - internal properties
    
    // MARK: - private properties
    private var title: String                      = "";
    private var cancelButtonBgColor: UIColor       = UIColor.white;
    private var cancelButtonTitleColor: UIColor    = RGB(109, 109, 109);
    
    private var buttonArray                = [UIButton]();
    private var cancelButton               = UIButton(type: .custom);
    private var titleLabel:UILabel?;
    private var buttonBgView               = UIVisualEffectView(effect: UIBlurEffect(style: .light));
    
    // MARK: - private const
    private let BUTTON_FRAME: CGRect            = CGRect(x: 0.0, y: 0.0, width: 64.0, height: 70.0);
    private let CANCEL_BUTTON_HEIGHT: CGFloat   = 44.0;
    private let CANCEL_BUTTON_WIDTH: CGFloat    = min(SCREEN_BOUNDS().size.width, SCREEN_BOUNDS().size.height) - 20;
    private let VIEW_WIDTH: CGFloat             = min(SCREEN_BOUNDS().size.width, SCREEN_BOUNDS().size.height);
    private let BUTTON_ROW_HEIGHT: CGFloat      = 70.0;
    private let TITLE_LABEL_HEIGHT: CGFloat     = 30.0;
    
    // MARK: - delegate
    var delegate: DZActionSheetDelegate?;
    
    // MARK: - init functions
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(frame:CGRect) {
        super.init(frame:frame)
    }
    
    public init(title: String, cancelTitle: String = "Cancel") {
        let rect:CGRect = CGRect(x: 0,
                                 y: SCREEN_BOUNDS().size.height - CANCEL_BUTTON_HEIGHT,
                                 width: SCREEN_BOUNDS().size.width,
                                 height: CANCEL_BUTTON_HEIGHT);
        super.init(frame: rect);
        self.title = title;
        self.setCancelButton(title: cancelTitle);
    }
}

// MARK: - cancel button
extension DZActionSheet {
    // MARK: - set Buttons
    internal func setCancelButton(title: String = "Cancel", backgroundColor: UIColor? = nil) {
        self.cancelButton.frame            = CGRect(x: 0, y: 0, width: CANCEL_BUTTON_WIDTH, height: CANCEL_BUTTON_HEIGHT);
        self.cancelButton.backgroundColor  = backgroundColor ?? RGB_HEX("ffffff", 1.0);
        self.cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20.0);
        self.cancelButton.setTitle(title, for: .normal);
        self.cancelButton.setTitleColor(RGB(33, 33, 33), for: .normal);
        self.cancelButton.addTarget(self, action: #selector(cancelButtonClicked(_:)), for: .touchUpInside);
    }
    
    @objc internal func cancelButtonClicked(_ sender:AnyObject) {
        self.delegate?.onCancelButtonClicked();
        return;
    }
}

// MARK: - button list
extension DZActionSheet {
    internal func addButton (title: String,
                             characterColor: UIColor?,
                             imageNormal: String?,
                             imageHighlighted: String?,
                             imageDisabled: String?) -> Int {
        let btn = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
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
            let gary = ( characterColor != nil ) ? characterColor!.getGary() : 0;
            btnImage = UIImage.imageWithColor(characterColor!, size: CGSize(width: 48, height: 48));
            let initialChar = title.prefix(1);//.substring(to: title.characters.index(title.startIndex, offsetBy: 1));
            let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 48, height: 48));
            lbl.font = UIFont.boldSystemFont(ofSize: 28.0);
            if gary >= 175 {
                lbl.textColor = RGB_HEX("444444", 1.0);
            }
            else {
                lbl.textColor = RGB_HEX("FFFFFF", 1.0);
            }
            lbl.textAlignment = NSTextAlignment.center;
            lbl.text = String(initialChar);
            btn.imageView?.addSubview(lbl);
        }
        btn.contentMode = .scaleAspectFill;
        btn.setImage(btnImage, for: .normal);
        
        btn.layer.cornerRadius = 8.0;
        
        if ( imageHighlighted != nil ) {
            btn.setImage(UIImage(named: imageHighlighted!), for: .highlighted);
        }
        if ( imageDisabled != nil ) {
            btn.setImage(UIImage(named: imageDisabled!), for: .disabled);
        }
        btn.frame = BUTTON_FRAME;
    
        self.buttonArray.append(btn);
        
        btn.contentHorizontalAlignment  = .center;
        btn.contentVerticalAlignment    = .top;
        btn.imageEdgeInsets             = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 22.0, right: 8.0);
        btn.titleEdgeInsets             = UIEdgeInsets(top: 50, left: -1*btnImage.size.width, bottom: 0, right: 0);
        
        let index:Int = self.buttonArray.index(of: btn)!;
        btn.tag = index;
        btn.addTarget(self, action: #selector(DZActionSheet.buttonClicked(_:)), for: .touchUpInside);
        
        return index;
    }
    
    internal func setButtonState(_ buttonState: UIControl.State, AtIndex buttonIndex:Int) {
        let btn = self.buttonArray[buttonIndex];
        
        switch ( buttonState ) {
        case .normal :
            btn.isEnabled     = true;
            btn.isHighlighted = false;
            break;
        case .disabled :
            btn.isEnabled     = false;
            btn.isHighlighted = false;
            break;
        case .highlighted :
            btn.isEnabled     = true;
            btn.isHighlighted = true;
            break;
        default :
            break;
        }
    }
    
    @objc internal func buttonClicked(_ sender:AnyObject) {
        let btnIdx = sender.tag;
        self.delegate?.onButtonClicked(atIndex: btnIdx!);
        return;
    }
    
}

// MARK: - layoutSubviews
extension DZActionSheet {
    override open func layoutSubviews() {
        let _ = UITraitCollection(horizontalSizeClass: .regular);
        let rect:CGRect = CGRect(x: 0.0, y: 0.0, width: CANCEL_BUTTON_WIDTH, height: TITLE_LABEL_HEIGHT);
        
        // calc the height
        let titleHeight         = TITLE_LABEL_HEIGHT;
        let btnCount            = self.buttonArray.count;
        let lineCount           = (btnCount + 3 )/4;
        let buttonAreaHeight    = CGFloat(lineCount) * BUTTON_ROW_HEIGHT + 10
        
        let actionSheetHeight       = CANCEL_BUTTON_HEIGHT + buttonAreaHeight + titleHeight + 20;
    
        // labels
        self.titleLabel                     = UILabel(frame: rect);
        self.titleLabel!.textAlignment      = NSTextAlignment.center;
        self.titleLabel!.backgroundColor    = UIColor.clear;
        self.titleLabel!.font               = UIFont.systemFont(ofSize: 14.0);
        self.titleLabel!.textColor          = UIColor.darkGray;
        self.titleLabel!.text               = self.title;
    
        // buttons
        // calc the height
        self.frame = CGRect(x: 0, y: SCREEN_BOUNDS().size.height - 20 - actionSheetHeight, width: VIEW_WIDTH, height: actionSheetHeight);
        
        self.buttonBgView.frame = CGRect(x: 10, y: 0, width: CANCEL_BUTTON_WIDTH, height: buttonAreaHeight + titleHeight);
        self.buttonBgView.layer.cornerRadius = 8.0;
        self.buttonBgView.clipsToBounds = true;
        self.addSubview(self.buttonBgView);
        
        self.buttonBgView.backgroundColor = RGB_HEX("ffffff", 0.3);
        
        //if ( self.titleLabel != nil ) {
            self.addSubview(self.titleLabel!);
        //}
    
        // cancel button
        self.cancelButton.frame = CGRect(x: 10, y: self.frame.size.height - CANCEL_BUTTON_HEIGHT - 10, width: CANCEL_BUTTON_WIDTH, height: CANCEL_BUTTON_HEIGHT);
        self.cancelButton.layer.cornerRadius = 8.0;
        self.addSubview(self.cancelButton);
    
        // calc buttons' location
        let countInOneLine = ceil(CGFloat(self.buttonArray.count) / CGFloat(lineCount));
        let btnSpacing: CGFloat = (CANCEL_BUTTON_WIDTH - countInOneLine*BUTTON_FRAME.width) / (countInOneLine+1.0);
        for btn in self.buttonArray {
            self.addSubview(btn);
            let idx = btn.tag;
            let btnRect:CGRect  = CGRect(
                x: (btnSpacing + CGFloat(idx).truncatingRemainder(dividingBy: countInOneLine) * (btnSpacing + BUTTON_FRAME.size.width)),
                y: titleHeight + BUTTON_ROW_HEIGHT*CGFloat(idx/Int(countInOneLine)) + 5,
                width: BUTTON_FRAME.size.width,
                height: BUTTON_FRAME.size.height);
            btn.frame = btnRect;
        }
        
        self.backgroundColor = UIColor.clear; //RGBA(255, 255, 255, 0.7);//
        self.frame.size = CGSize(width: VIEW_WIDTH, height: self.frame.size.height);
        self.center = CGPoint(x: SCREEN_BOUNDS().size.width/2, y: SCREEN_BOUNDS().size.height + self.frame.size.height/2);
    }
}
