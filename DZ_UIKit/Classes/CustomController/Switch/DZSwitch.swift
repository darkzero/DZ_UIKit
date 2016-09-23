//
//  DZSwitch.swift
//  DZLib
//
//  Created by Dora.Yuan on 14/10/25.
//  Copyright (c) 2014年 Dora.Yuan All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
open class DZSwitch : UIControl {
    
    // MARK: - Class define
    
    // MARK: - public properties
    open var on:Bool = false {
        didSet {
            self.changeSwitchWithAnimationTo(self.on);
        }
    }
    
    fileprivate let defaultOnImageName      = "SwitchBackground_on";
    fileprivate let defaultOffImageName     = "SwitchBackground_off";
    fileprivate let defaultThumbImageName   = "SwitchThumb";
    fileprivate let defaultImageType        = "png";
    
    // MARK: - @IBInspectable properties
    @IBInspectable open var onImage: UIImage?;
    @IBInspectable open var offImage: UIImage?;
    @IBInspectable open var thumbImage: UIImage?;
    @IBInspectable open var defaultOn: Bool = false;
    
    // MARK: - private properties
    fileprivate var onImageView:UIImageView     = UIImageView();
    fileprivate var offImageView:UIImageView    = UIImageView();
    fileprivate var thumbImageView:UIImageView  = UIImageView();
    
    //UIViewController* _target;
    //SEL _action;
    fileprivate var startPos:CGPoint            = CGPoint();
    fileprivate var isPanning:Bool              = false;
    
    // MARK: - init
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    public init(frame:CGRect, onImage: String? = nil, offImage: String? = nil, thumbImage: String? = nil) {
        super.init(frame: frame);
        
        // Initialization code
        self.layer.cornerRadius     = frame.size.height/2.0;
        self.backgroundColor        = UIColor.clear;
        self.layer.masksToBounds    = true;
        
        let pan:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(DZSwitch.onPanHandleImage(_:)));
        self.addGestureRecognizer(pan);
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DZSwitch.onTapHandleImage(_:)));
        self.addGestureRecognizer(tap);
        
        self.onImageView    = UIImageView(frame: self.bounds);
        self.offImageView   = UIImageView(frame: self.bounds);
        self.thumbImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.height, height: self.bounds.size.height));
        
        // On Image
        if onImage == nil {
            let imageStr = Bundle(for: DZCheckBox.self).path(forResource: defaultOnImageName, ofType: defaultImageType);
            self.onImageView.image = UIImage(data: try! Data(contentsOf: URL(fileURLWithPath: imageStr!)));
            
        }
        else {
            self.onImageView.image = UIImage(named: onImage!);
        }
        
        // Off Image
        if offImage == nil {
            let imageStr = Bundle(for: DZCheckBox.self).path(forResource: defaultOffImageName, ofType: defaultImageType);
            self.offImageView.image = UIImage(data: try! Data(contentsOf: URL(fileURLWithPath: imageStr!)));
        }
        else {
            self.offImageView.image = UIImage(named: offImage!);
        }
        
        // Thumb Image
        if thumbImage == nil {
            let imageStr = Bundle(for: DZCheckBox.self).path(forResource: defaultThumbImageName, ofType: defaultImageType);
            self.thumbImageView.image = UIImage(data: try! Data(contentsOf: URL(fileURLWithPath: imageStr!)));
        }
        else {
            self.thumbImageView.image = UIImage(named: thumbImage!);
        }
        
        self.addSubview(self.onImageView);
        self.addSubview(self.offImageView);
        self.addSubview(self.thumbImageView);
        
        //self.addObserver(self, forKeyPath: "on", options: NSKeyValueObservingOptions.Old|NSKeyValueObservingOptions.New, context: nil);
    }
    
    // MARK: - class functions
    
    // MARK: - public functions
    
    // MARK: - internal functions
    
    func onTapHandleImage(_ tap: UITapGestureRecognizer) {
        self.on = !self.on;
    }
    
    
    func onPanHandleImage(_ pan: UIPanGestureRecognizer) {
        switch pan.state {
        case UIGestureRecognizerState.began:
            self.isPanning  = false;
            self.startPos   = pan.location(in: self);
            if ( self.thumbImageView.frame.contains(self.startPos) ) {
                self.isPanning  = true;
            }
            break;
        case UIGestureRecognizerState.changed:
            let position:CGPoint    = pan.location(in: self);
            let base:CGFloat        = self.thumbImageView.frame.origin.x;
            let move:CGFloat        = position.x - self.startPos.x;
            var offset:CGFloat      = base + move;
            let standardOffset: CGFloat = self.onImageView.frame.size.width - self.thumbImageView.frame.size.width;
            if ( base + move > standardOffset ) {
                offset = standardOffset;
            }
            if ( base + move < 0.0 ) {
                offset = 0.0;
            }
            if ( self.isPanning ) {
                self.onImageView.frame.origin      = CGPoint(x: offset - standardOffset, y: 0.0); //CGRectMake(offset-23, 0, _onImageView.frame.size.width, _onImageView.frame.size.height);
                self.offImageView.frame.origin     = CGPoint(x: offset, y: 0.0);      //CGRectMake(offset, 0, _offImageView.frame.size.width, _offImageView.frame.size.height);
                self.thumbImageView.frame.origin   = CGPoint(x: offset, y: 0.0);      //CGRectMake(offset, 0, _thumbImageView.frame.size.width, _thumbImageView.frame.size.height);
            }
            break;
        case UIGestureRecognizerState.cancelled,
             UIGestureRecognizerState.ended:
            let position:CGPoint    = pan.location(in: self);
            let base:CGFloat        = self.thumbImageView.frame.origin.x;
            let move:CGFloat        = position.x - self.startPos.x;
            let offset:CGFloat      = base + move;
            if ( offset < 6.0 ) {
                self.on = false;
            }
            if ( offset >= 6.0 ) {
                self.on = true;
            }
            break;
        default:
            break;
        }
    }
    
    // MARK: - private functions
    
    fileprivate func changeSwitchWithAnimationTo(_ on:Bool)
    {
        let standardOffset: CGFloat = self.onImageView.frame.size.width - self.thumbImageView.frame.size.width;
        if ( on ) {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                self.onImageView.frame      = CGRect(x: 0, y: 0, width: self.onImageView.frame.size.width, height: self.onImageView.frame.size.height);
                self.offImageView.frame     = CGRect(x: standardOffset, y: 0, width: self.offImageView.frame.size.width, height: self.offImageView.frame.size.height);
                self.thumbImageView.frame   = CGRect(x: standardOffset, y: 0, width: self.thumbImageView.frame.size.width, height: self.thumbImageView.frame.size.height);
                }, completion: { (isFinished) -> Void in
                    self.sendActions(for: UIControlEvents.valueChanged);
            });
        }
        else {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                self.onImageView.frame.origin   = CGPoint(x: 0, y: 0);//      = CGRectMake(-23, 0, self.onImageView.frame.size.width, self.onImageView.frame.size.height);
                self.offImageView.frame         = CGRect(x: 0, y: 0, width: self.offImageView.frame.size.width, height: self.offImageView.frame.size.height);
                self.thumbImageView.frame       = CGRect(x: 0, y: 0, width: self.thumbImageView.frame.size.width, height: self.thumbImageView.frame.size.height);
                }, completion: { (isFinished) -> Void in
                    //
                    self.sendActions(for: UIControlEvents.valueChanged);
            });
        }
    }
    
    // MARK: - layoutSubviews
    
    open override func layoutSubviews() {
        let standardOffset: CGFloat = self.onImageView.frame.size.width - self.thumbImageView.frame.size.width;
        if ( self.on ) {
            self.onImageView.frame.origin      = CGPoint(x: 0.0, y: 0.0);     //CGRectMake(0, 0, _onImageView.frame.size.width, _onImageView.frame.size.height);
            self.offImageView.frame.origin     = CGPoint(x: standardOffset, y: 0.0);    //CGRectMake(23, 0, _offImageView.frame.size.width, _offImageView.frame.size.height);
            self.thumbImageView.frame.origin   = CGPoint(x: standardOffset, y: 0.0);    //CGRectMake(55-32, 0, _thumbImageView.frame.size.width, _thumbImageView.frame.size.height);
        }
        else {
            self.onImageView.frame.origin      = CGPoint(x: -1.0*standardOffset, y: 0.0);   //CGRectMake(-23, 0, _onImageView.frame.size.width, _onImageView.frame.size.height);
            self.offImageView.frame.origin     = CGPoint(x: 0.0, y: 0.0);     //CGRectMake(0, 0, _offImageView.frame.size.width, _offImageView.frame.size.height);
            self.thumbImageView.frame.origin   = CGPoint(x: 0.0, y: 0.0);     //CGRectMake(0, 0, _thumbImageView.frame.size.width, _thumbImageView.frame.size.height);
        }
    }
}
