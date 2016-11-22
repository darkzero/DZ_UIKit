//
//  DZActionSheetController.swift
//  Pods
//
//  Created by 胡 昱化 on 16/11/18.
//
//

import Foundation

public class DZActionSheetController: UIViewController, DZActionSheetDelegate {
    
    var actionSheet: DZActionSheet?;
    
    internal var cancelHandler:(() -> Void)?;
    internal var handlerDictionary = Dictionary<Int, (() -> Void)>();

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

// MARK: - init

    public init(title: String, cancelTitle: String = "Cancel", cancelHandler: (() -> Void)? = nil) {
        
        super.init(nibName: nil, bundle: nil);
        
        self.view.backgroundColor = RGBA(100, 100, 100, 0.5);
        self.modalPresentationStyle = .overFullScreen;
        self.modalTransitionStyle = .crossDissolve;
        
        self.actionSheet = DZActionSheet.actionSheet(withTitle: title);
        self.actionSheet!.delegate = self;
        
        // tap to dismiss
        let tap = UITapGestureRecognizer(target: self, action: #selector(hide));
        self.view.addGestureRecognizer(tap);
        
        self.setCancelButton(withTitle: cancelTitle, handler: cancelHandler);
        
        self.view.addSubview(self.actionSheet!);
    }
    
// MARK: - set buttons
    
    private func setCancelButton(withTitle title: String = "Cancel", handler: (() -> Void)? = nil) {
        self.actionSheet?.setCancelButton(withTitle: title);
        self.cancelHandler = handler;
    }
    
    public func addButton(withTitle buttonTitle: String,
                          characterColor: UIColor,
                          handler: (() -> Void)? = nil) {
        
        let buttonIndex = self.actionSheet!.addButton(withTitle: buttonTitle,
                                                      characterColor: characterColor,
                                                      imageNormal: nil,
                                                      imageHighlighted: nil,
                                                      imageDisabled: nil);
        
        self.setHandler(handler, atButtonIndex: buttonIndex);
    }
    
    public func addButton(withTitle buttonTitle: String,
                          imageNormal: String,
                          imageHighlighted: String?,
                          imageDisabled: String?,
                          handler: (() -> Void)? = nil) {
        
        let buttonIndex = actionSheet!.addButton(withTitle: buttonTitle,
                                                 characterColor: nil,
                                                 imageNormal: imageNormal,
                                                 imageHighlighted: imageHighlighted,
                                                 imageDisabled: imageDisabled);
        
        self.setHandler(handler, atButtonIndex: buttonIndex);
    }
    
    
    fileprivate func setHandler(_ handler:(() -> Void)?, atButtonIndex index:Int) {
        if ( handler != nil ) {
            self.handlerDictionary[index] = handler;
        }
        else {
            self.handlerDictionary.removeValue(forKey: index);
        }
    }
    
// MARK: - animation
    
    let ANIMATION_SPEED:TimeInterval = 0.2;
    let ANIMATION_SCALE:CGFloat = 1.15;
    
    public func show(inViewController vc: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        vc.present(self, animated: false, completion: {
            if ( animated ) {
                UIView.animate(withDuration: self.ANIMATION_SPEED, delay: 0.0, options: .allowUserInteraction, animations: {
                    self.actionSheet!.center = CGPoint(x: SCREEN_BOUNDS().size.width/2,
                                                       y: SCREEN_BOUNDS().size.height - self.actionSheet!.frame.size.height/2);
                }, completion: { (finished) in
                    //
                });
            }
            else {
                self.actionSheet!.center = CGPoint(x: SCREEN_BOUNDS().size.width/2,
                                                   y: SCREEN_BOUNDS().size.height - self.actionSheet!.frame.size.height/2);
            }
        });
    }
    
    public override func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        if ( animated ) {
            UIView.animate(withDuration: self.ANIMATION_SPEED, delay: 0.0, options: .allowUserInteraction, animations: {
                self.actionSheet!.center = CGPoint(x: SCREEN_BOUNDS().size.width/2,
                                                  y: SCREEN_BOUNDS().size.height + self.actionSheet!.frame.size.height/2);
            }, completion: { (finished) in
                //
                super.dismiss(animated: true, completion: nil);
            });
        }
        else {
            self.actionSheet!.center = CGPoint(x: SCREEN_BOUNDS().size.width/2,
                                               y: SCREEN_BOUNDS().size.height + self.actionSheet!.frame.size.height/2);
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
        self.dismiss();
    }
    
    internal func onCancelButtonClicked() {
        DebugLog("onCancelButtonClicked");
        self.cancelHandler?();
        self.dismiss();
    }
    
// MARK: - view transition
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        DebugLog("aaaa");
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // reset the position
        UIView.animate(withDuration: self.ANIMATION_SPEED, delay: 0.0, options: .allowUserInteraction, animations: {
            self.actionSheet!.center = CGPoint(x: SCREEN_BOUNDS().size.width/2,
                                               y: SCREEN_BOUNDS().size.height - self.actionSheet!.frame.size.height/2);
        }, completion: { (finished) in
            //
        });
    }
}
