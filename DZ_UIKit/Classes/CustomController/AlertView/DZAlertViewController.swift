//
//  DZAlertViewController.swift
//  Pods
//
//  Created by 胡 昱化 on 16/11/22.
//
//

import Foundation

public class DZAlertViewController : UIViewController, DZAlertViewDelegate {

// MARK: - properties
    var alertView: DZAlertView;
    
    internal var cancelHandler:(() -> Void)?;
    internal var handlerDictionary = Dictionary<Int, (() -> Void)>();

// MARK: - init
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(title: String, message: String? = nil, cancelTitle: String = "Cancel", cancelHandler: (() -> Void)? = nil) {
        self.alertView = DZAlertView(title: title, message: message, cancelTitle: cancelTitle);
        
        super.init(nibName: nil, bundle: nil);
        
        self.view.backgroundColor = RGBA(100, 100, 100, 0.5);
        self.modalPresentationStyle = .overFullScreen;
        self.modalTransitionStyle = .crossDissolve;
        
        self.alertView.delegate = self;
        
        // tap to dismiss
        //let tap = UITapGestureRecognizer(target: self, action: #selector(hide));
        //self.view.addGestureRecognizer(tap);
        
        self.cancelHandler = cancelHandler;
        
        self.view.addSubview(self.alertView);
    }

// MARK: - set buttons
    
    public func setCancelButton(title: String, bgColor: UIColor? = nil, textColor: UIColor? = nil, handler: (() -> Void)? = nil) {
        self.alertView.setCancelButton(title: title, bgColor: bgColor, textColor: textColor);
        self.cancelHandler = handler;
    }
    
    public func addButton(title: String, bgColor: UIColor? = nil, textColor: UIColor? = nil, handler: (() -> Void)? = nil) {
        let buttonIndex = self.alertView.addButton(title: title, bgColor: bgColor, textColor: textColor);
        self.setHandler(handler, atIndex: buttonIndex);
    }
    
    internal func setHandler(_ handler:DZBlock?, atIndex index:Int) {
        if ( handler != nil ) {
            self.handlerDictionary[index] = handler;
        }
        else {
            self.handlerDictionary.removeValue(forKey: index);
        }
    }
    
// MARK: - animation
    
    let ANIMATION_SPEED:TimeInterval = 0.2;
    let ANIMATION_SCALE:CGFloat = 0.5;
    
    public func show(inViewController vc: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        let transform = CGAffineTransform(scaleX: ANIMATION_SCALE, y: ANIMATION_SCALE);
        self.alertView.center = CGPoint(x: SCREEN_BOUNDS().size.width/2,
                                        y: SCREEN_BOUNDS().size.height/2);
        self.alertView.layer.sublayerTransform = CATransform3DMakeAffineTransform(transform);
        vc.present(self, animated: false, completion: {
            if ( animated ) {
                UIView.animate(withDuration: self.ANIMATION_SPEED, delay: 0.0, options: .allowUserInteraction, animations: {
                    self.alertView.layer.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransform.identity);
                    self.alertView.alpha = 1.0;
                    self.alertView.center = CGPoint(x: SCREEN_BOUNDS().size.width/2,
                                                    y: SCREEN_BOUNDS().size.height/2);
                }, completion: { (finished) in
                    //
                });
            }
            else {
                self.alertView.center = CGPoint(x: SCREEN_BOUNDS().size.width/2,
                                                y: SCREEN_BOUNDS().size.height - self.alertView.frame.size.height/2);
            }
        });
    }
    
    public override func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        if ( animated ) {
            UIView.animate(withDuration: self.ANIMATION_SPEED, delay: 0.0, options: .allowUserInteraction, animations: {
                self.alertView.center = CGPoint(x: SCREEN_BOUNDS().size.width/2,
                                                y: SCREEN_BOUNDS().size.height/2);
            }, completion: { (finished) in
                super.dismiss(animated: true, completion: nil);
            });
        }
        else {
            self.alertView.center = CGPoint(x: SCREEN_BOUNDS().size.width/2,
                                            y: SCREEN_BOUNDS().size.height/2);
            super.dismiss(animated: true, completion: nil);
        }
    }
    
    internal func hide() {
        self.dismiss();
    }
    
// MARK: - delegate func
    
    internal func onButtonClicked(atIndex index: Int) {
        DebugLog("onButtonClicked at index \(index)");
        let handler = self.handlerDictionary[index];
        if ( handler != nil ) {
            DebugLog("call handler");
            handler!();
        }
        self.dismiss();
    }
    
    internal func onCancelButtonClicked() {
        DebugLog("onCancelButtonClicked");
        self.cancelHandler?();
        self.dismiss();
    }
    
// MARK: - view transition
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // reset the position
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .allowUserInteraction, animations: {
            self.alertView.center = CGPoint(x: SCREEN_BOUNDS().size.width/2,
                                            y: SCREEN_BOUNDS().size.height/2);
        }, completion: { (finished) in
            //
        });
    }
}
