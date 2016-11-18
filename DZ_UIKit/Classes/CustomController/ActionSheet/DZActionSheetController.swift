//
//  DZActionSheetController.swift
//  Pods
//
//  Created by 胡 昱化 on 16/11/18.
//
//

import Foundation

public class DZActionSheetController: UIViewController {
    var actionSheet: DZActionSheet?;
    
//    required public init(coder aDecoder: NSCoder) {
//        //
//        super.init(coder: aDecoder)!;
//    }
    
    /*public class func actionSheet(withTitle title: String, message: String) -> DZActionSheetController {
    
    }*/
    
    public func addButton(withTitle buttonTitle: String,
                          characterColor: UIColor,
                          handler: DZBlock?) {
        
        actionSheet!.addButton(withTitle: buttonTitle,
                       characterColor: characterColor,
                       handler: handler);
    }
    
    public func show() {
    
    }
    
    public func dissmis() {
        
    }
    
// MARK: -
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        DebugLog("");
    }
}
