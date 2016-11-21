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

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil);
        
        // tap to dismiss
        let tap = UITapGestureRecognizer(target: self, action: #selector(DZActionSheetController.hide));
        self.view.addGestureRecognizer(tap);
    }
    
    public class func actionSheet(withTitle title: String, message: String) -> DZActionSheetController {
        let instace = DZActionSheetController();
        instace.actionSheet = DZActionSheet.actionSheet(withTitle: title);
        instace.actionSheet!.delegate = instace;
        instace.view.backgroundColor = RGBA(100, 100, 100, 0.5);
        instace.modalPresentationStyle = .overFullScreen;
        instace.modalTransitionStyle = .crossDissolve;
        instace.view.addSubview(instace.actionSheet!);
        
        return instace;
    }
    
    
    public func addButton(withTitle buttonTitle: String,
                          characterColor: UIColor,
                          handler: (() -> Void)? = nil) {
        
        self.actionSheet?.addButton(withTitle: buttonTitle,
                       characterColor: characterColor,
                       imageNormal: nil,
                       imageHighlighted: nil,
                       imageDisabled: nil,
                       handler: handler);
    }
    
    public func addButton(withTitle buttonTitle: String,
                          imageNormal: String,
                          imageHighlighted: String?,
                          imageDisabled: String?,
                          handler: (() -> Void)? = nil) {
        
        actionSheet?.addButton(withTitle: buttonTitle,
                       characterColor: nil,
                       imageNormal: imageNormal,
                       imageHighlighted: imageHighlighted,
                       imageDisabled: imageDisabled,
                       handler: handler);
    }
    
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
    
    public func hide() {
        self.dismiss();
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
    
// MARK: -
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
