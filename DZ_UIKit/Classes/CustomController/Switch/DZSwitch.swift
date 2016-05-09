//
//  DZSwitch.swift
//  DZLib
//
//  Created by Dora.Yuan on 14/10/25.
//  Copyright (c) 2014年 Dora.Yuan All rights reserved.
//

import Foundation
import UIKit

public class DZSwitch : UIControl {
    
    // MARK: - Class define
    
    // MARK: - public properties
    public var on:Bool = false {
        didSet {
            self.changeSwitchWithAnimationTo(self.on);
        }
    }
    
    // MARK: - internal properties
    
    // MARK: - private properties
    private var onImageView:UIImageView     = UIImageView();
    private var offImageView:UIImageView    = UIImageView();
    private var thumbImageView:UIImageView  = UIImageView();
    
    //UIViewController* _target;
    //SEL _action;
    private var startPos:CGPoint            = CGPoint();
    private var isPanning:Bool              = false;
    
    // MARK: - init
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(frame:CGRect, onImage: String, offImage: String, thumbImage: String) {
        super.init(frame: frame);
        
        // Initialization code
        self.layer.cornerRadius     = frame.size.height/2.0;
        self.backgroundColor        = UIColor.clearColor();
        self.layer.masksToBounds    = true;
        
        let pan:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(DZSwitch.onPanHandleImage(_:)));
        self.addGestureRecognizer(pan);
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DZSwitch.onTapHandleImage(_:)));
        self.addGestureRecognizer(tap);
        self.onImageView        = UIImageView(image: UIImage(named: onImage));
        self.offImageView       = UIImageView(image: UIImage(named: offImage));
        self.thumbImageView     = UIImageView(image: UIImage(named: thumbImage));
        
        self.addSubview(self.onImageView);
        self.addSubview(self.offImageView);
        self.addSubview(self.thumbImageView);
        
        //self.addObserver(self, forKeyPath: "on", options: NSKeyValueObservingOptions.Old|NSKeyValueObservingOptions.New, context: nil);
    }
    
    // MARK: - class functions
    
    // MARK: - public functions
    
    // MARK: - internal functions
    
    func onTapHandleImage(tap: UITapGestureRecognizer) {
        self.on = !self.on;
    }
    
    
    func onPanHandleImage(pan: UIPanGestureRecognizer) {
        switch pan.state {
        case UIGestureRecognizerState.Began:
            self.isPanning  = false;
            self.startPos   = pan.locationInView(self);
            if ( CGRectContainsPoint(self.thumbImageView.frame, self.startPos) ) {
                self.isPanning  = true;
            }
            break;
        case UIGestureRecognizerState.Changed:
            let position:CGPoint    = pan.locationInView(self);
            let base:CGFloat        = self.thumbImageView.frame.origin.x;
            let move:CGFloat        = position.x - self.startPos.x;
            var offset:CGFloat      = base + move;
            if ( base + move > 23.0 ) {
                offset = 23.0;
            }
            if ( base + move < 0.0 ) {
                offset = 0.0;
            }
            if ( self.isPanning ) {
                self.onImageView.frame.origin      = CGPointMake(offset-23.0, 0.0); //CGRectMake(offset-23, 0, _onImageView.frame.size.width, _onImageView.frame.size.height);
                self.offImageView.frame.origin     = CGPointMake(offset, 0.0);      //CGRectMake(offset, 0, _offImageView.frame.size.width, _offImageView.frame.size.height);
                self.thumbImageView.frame.origin   = CGPointMake(offset, 0.0);      //CGRectMake(offset, 0, _thumbImageView.frame.size.width, _thumbImageView.frame.size.height);
            }
            break;
        case UIGestureRecognizerState.Cancelled,
        UIGestureRecognizerState.Ended:
            let position:CGPoint    = pan.locationInView(self);
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
    
    private func changeSwitchWithAnimationTo(on:Bool)
    {
        if ( on ) {
            UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                self.onImageView.frame      = CGRectMake(0, 0, self.onImageView.frame.size.width, self.onImageView.frame.size.height);
                self.offImageView.frame     = CGRectMake(23, 0, self.offImageView.frame.size.width, self.offImageView.frame.size.height);
                self.thumbImageView.frame   = CGRectMake(55-32, 0, self.thumbImageView.frame.size.width, self.thumbImageView.frame.size.height);
                }, completion: { (isFinished) -> Void in
                    //
                    self.sendActionsForControlEvents(UIControlEvents.ValueChanged);
            });
        }
        else {
            UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                self.onImageView.frame.origin = CGPointMake(0, 0);//      = CGRectMake(-23, 0, self.onImageView.frame.size.width, self.onImageView.frame.size.height);
                self.offImageView.frame     = CGRectMake(0, 0, self.offImageView.frame.size.width, self.offImageView.frame.size.height);
                self.thumbImageView.frame   = CGRectMake(0, 0, self.thumbImageView.frame.size.width, self.thumbImageView.frame.size.height);
                }, completion: { (isFinished) -> Void in
                    //
                    self.sendActionsForControlEvents(UIControlEvents.ValueChanged);
            });
        }
    }
    
    // MARK: - layoutSubviews
    
    public override func layoutSubviews() {
        if ( self.on ) {
            self.onImageView.frame.origin      = CGPointMake(0.0, 0.0);     //CGRectMake(0, 0, _onImageView.frame.size.width, _onImageView.frame.size.height);
            self.offImageView.frame.origin     = CGPointMake(23.0, 0.0);    //CGRectMake(23, 0, _offImageView.frame.size.width, _offImageView.frame.size.height);
            self.thumbImageView.frame.origin   = CGPointMake(23.0, 0.0);    //CGRectMake(55-32, 0, _thumbImageView.frame.size.width, _thumbImageView.frame.size.height);
        }
        else {
            self.onImageView.frame.origin      = CGPointMake(-23.0, 0.0);   //CGRectMake(-23, 0, _onImageView.frame.size.width, _onImageView.frame.size.height);
            self.offImageView.frame.origin     = CGPointMake(0.0, 0.0);     //CGRectMake(0, 0, _offImageView.frame.size.width, _offImageView.frame.size.height);
            self.thumbImageView.frame.origin   = CGPointMake(0.0, 0.0);     //CGRectMake(0, 0, _thumbImageView.frame.size.width, _thumbImageView.frame.size.height);
        }
    }
}
