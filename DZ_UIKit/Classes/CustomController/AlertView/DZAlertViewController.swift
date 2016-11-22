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
    var alertView: DZAlertView?;
    
    internal var cancelHandler:(() -> Void)?;
    internal var handlerDictionary = Dictionary<Int, (() -> Void)>();

// MARK: - init
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(title: String, message: String? = nil, cancelTitle: String = "Cancel", cancelHandler: (() -> Void)? = nil) {
        
        super.init(nibName: nil, bundle: nil);
        
        self.alertView = DZAlertView.alertView(withTitle: title);
    }

// MARK: - set buttons
    
// MARK: - animation
    
    let ANIMATION_SPEED:TimeInterval = 0.2;
    let ANIMATION_SCALE:CGFloat = 1.15;
    
    public func show(inViewController vc: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        vc.present(self, animated: false, completion: {
            if ( animated ) {
                UIView.animate(withDuration: self.ANIMATION_SPEED, delay: 0.0, options: .allowUserInteraction, animations: {
                    self.alertView!.center = CGPoint(x: SCREEN_BOUNDS().size.width/2,
                                                       y: SCREEN_BOUNDS().size.height - self.alertView!.frame.size.height/2);
                }, completion: { (finished) in
                    //
                });
            }
            else {
                self.alertView!.center = CGPoint(x: SCREEN_BOUNDS().size.width/2,
                                                   y: SCREEN_BOUNDS().size.height - self.alertView!.frame.size.height/2);
            }
        });
    }
    
    public override func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        if ( animated ) {
            UIView.animate(withDuration: self.ANIMATION_SPEED, delay: 0.0, options: .allowUserInteraction, animations: {
                self.alertView!.center = CGPoint(x: SCREEN_BOUNDS().size.width/2,
                                                   y: SCREEN_BOUNDS().size.height + self.alertView!.frame.size.height/2);
            }, completion: { (finished) in
                //
                super.dismiss(animated: true, completion: nil);
            });
        }
        else {
            self.alertView!.center = CGPoint(x: SCREEN_BOUNDS().size.width/2,
                                               y: SCREEN_BOUNDS().size.height + self.alertView!.frame.size.height/2);
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
            DebugLog("no handler");
            handler!();
        }
        //self.dismiss();
    }
    
    internal func onCancelButtonClicked() {
        DebugLog("onCancelButtonClicked");
        self.cancelHandler?();
        //self.dismiss();
    }
    
// MARK: - view transition
    
}
