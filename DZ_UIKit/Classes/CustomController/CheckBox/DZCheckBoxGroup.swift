//
//  DZCheckBoxGroup.swift
//  DZ_UIKit
//
//  Created by Dora.Yuan on 2014/10/08.
//  Copyright (c) 2014 Dora.Yuan All rights reserved.
//

import Foundation
import UIKit

public enum DZCheckBoxGroupStyle: Int {
    case `default`    = 0;
    case bar        = 1;
    case list       = 2;
}

protocol DZCheckBoxGroupDelegate {
    func numberOfCheckBoxes() -> Int;
    func checkBoxSizeOfGroup(_ group : DZCheckBoxGroup, atIndex theIndex : Int)-> CGSize;
    func checkBoxOfGroup(_ group : DZCheckBoxGroup, atIndex theIndex : Int) -> DZCheckBox;
}

open class DZCheckBoxGroup : UIControl {
    
    open var multipleCheckEnabled:Bool    = false;
    open var style: DZCheckBoxGroupStyle  = .default;
    
    open var checkedIndexes:[Int];
    
    fileprivate var checkBoxArray:[DZCheckBox];

    required public init?(coder aDecoder: NSCoder) {
        self.multipleCheckEnabled   = false;
        self.checkBoxArray          = [DZCheckBox]();
        self.checkedIndexes         = [Int]();
        
        super.init(coder: aDecoder);
        self.backgroundColor        = UIColor.clear;
    }
    
    override init(frame: CGRect) {
        self.multipleCheckEnabled   = false;
        self.checkBoxArray          = [DZCheckBox]();
        self.checkedIndexes         = [Int]();
        
        super.init(frame:frame);
        self.backgroundColor        = UIColor.clear;
    }
    
    override open func didMoveToSuperview() {
        self.backgroundColor = UIColor.clear;
        super.didMoveToSuperview();
    }
    
    override open func layoutSubviews() {
        var _ = self.subviews.map { $0.removeFromSuperview() };
        
        let itemsCount:Int  = self.checkBoxArray.count;
        let theCheckBox     = self.checkBoxArray[0] as! DZCheckBox;
        var theRect:CGRect  = CGRect.zero;
        
        
        switch self.style {
        case .list :
            theRect = CGRect( x: self.frame.origin.x, y: self.frame.origin.y,
                                 width: theCheckBox.frame.size.width, height: (theCheckBox.frame.size.height + 5)*CGFloat(itemsCount));
            for i in 0 ... (itemsCount-1) {
                let aCheckBox = self.checkBoxArray[i] as! DZCheckBox;
                aCheckBox.frame.origin = CGPoint(x: 0, y: (aCheckBox.frame.size.height+5)*CGFloat(i));
                
                self.addSubview(aCheckBox);
            }
            break;
        case .bar, .default :
            theRect = CGRect( x: self.frame.origin.x, y: self.frame.origin.y,
                                  width: (theCheckBox.frame.size.width + 5)*CGFloat(itemsCount), height: theCheckBox.frame.size.height);
            for i in 0 ... (itemsCount-1) {
                let aCheckBox = self.checkBoxArray[i] as! DZCheckBox;
                aCheckBox.frame.origin = CGPoint(x: (aCheckBox.frame.size.width+5)*CGFloat(i), y: 0);
                
                self.addSubview(aCheckBox);
            }
            break;
        }
        
        self.frame = theRect;
        
        for i in 0 ... (self.checkBoxArray.count - 1) {
            let checkBox:DZCheckBox = self.checkBoxArray[i] as! DZCheckBox;
            if ( self.checkedIndexes.contains(i) ) {
                checkBox.checked = true;
            }
        }
    }
    
    open class func checkBoxgroupWithFrame(_ frame : CGRect) -> DZCheckBoxGroup {
        let group:DZCheckBoxGroup! = DZCheckBoxGroup(frame:frame);
        return group;
    }
    
    open class func checkBoxgroupWithFrame(_ frame : CGRect, Items items : [DZCheckBox]) -> DZCheckBoxGroup {
        let group = DZCheckBoxGroup(frame:frame);
        group.checkBoxArray.append(contentsOf: items);
        return group;
    }
    
    open func addCheckBox(_ checkBox:DZCheckBox) {
        checkBox.addTarget(self, action: #selector(DZCheckBoxGroup.onCheckBoxCheckedChanged(_:)), for: UIControlEvents.valueChanged);
        self.checkBoxArray.append(checkBox);
        //self.setNeedsLayout();
    }
    
    open func addCheckBoxes(_ items:[DZCheckBox]) {
        for checkBox in items {
            checkBox.addTarget(self, action: #selector(DZCheckBoxGroup.onCheckBoxCheckedChanged(_:)), for: UIControlEvents.valueChanged);
            self.checkBoxArray.append(checkBox);
        }
        //self.setNeedsLayout();
    }
    
    open func onCheckBoxCheckedChanged(_ sender: AnyObject)
    {
        let box     = sender as! DZCheckBox;
        let checked = box.checked;
        if ( !self.multipleCheckEnabled && checked ) {
            for item in self.checkBoxArray {
                if let aBox = item as? DZCheckBox {
                    if ( !aBox.isEqual(sender) && aBox.checked ) {
                        aBox.checked =  false;
                    }
                }
            }
        }
        
        self.checkedIndexes.removeAll();
        for i in 0 ... (self.checkBoxArray.count - 1) {
            let checkBox = self.checkBoxArray[i] as! DZCheckBox;
            if ( checkBox.checked ) {
                self.checkedIndexes.append(i);
            }
        }
        
        self.sendActions(for: UIControlEvents.valueChanged);
    }
    
//    + (DZCheckBoxGroup*) checkBoxgroupWithFrame:(CGRect)frame;
//    + (DZCheckBoxGroup*) checkBoxgroupWithFrame:(CGRect)frame items:(NSArray*)items;
    
//    - (void) addCheckBox:(DZCheckBox*)checkBox;
//    - (void) addCheckBoxes:(NSArray*)items;
}
