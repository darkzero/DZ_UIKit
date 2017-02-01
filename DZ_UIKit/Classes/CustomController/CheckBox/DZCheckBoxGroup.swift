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

public class DZCheckBoxGroup : UIControl {
    
// MARK: - properties
    
    open var multipleCheckEnabled:Bool    = false;
    open var style: DZCheckBoxGroupStyle  = .default;
    
    open var checkedIndexes:[Int];
    
    fileprivate var checkBoxArray:[DZCheckBox];

// MARK: - init
    
    required public init?(coder aDecoder: NSCoder) {
        self.multipleCheckEnabled   = false;
        self.checkBoxArray          = [DZCheckBox]();
        self.checkedIndexes         = [Int]();
        
        super.init(coder: aDecoder);
        self.backgroundColor        = UIColor.clear;
    }
    
    override public init(frame: CGRect) {
        self.multipleCheckEnabled   = false;
        self.checkBoxArray          = [DZCheckBox]();
        self.checkedIndexes         = [Int]();
        
        super.init(frame:frame);
        self.backgroundColor        = UIColor.clear;
    }
    
    public init(frame: CGRect, items : [DZCheckBox]) {
        self.multipleCheckEnabled   = false;
        self.checkBoxArray          = items;
        self.checkedIndexes         = [Int]();
        
        super.init(frame:frame);
        self.backgroundColor        = UIColor.clear;
    }
    
    override open func didMoveToSuperview() {
        self.backgroundColor = UIColor.clear;
        super.didMoveToSuperview();
    }
    
    public func addCheckBox(_ checkBox:DZCheckBox) {
        checkBox.addTarget(self, action: #selector(DZCheckBoxGroup.onCheckBoxCheckedChanged(_:)), for: UIControlEvents.valueChanged);
        self.checkBoxArray.append(checkBox);
        //self.setNeedsLayout();
    }
    
    public func addCheckBoxes(_ items:[DZCheckBox]) {
        for checkBox in items {
            checkBox.addTarget(self, action: #selector(DZCheckBoxGroup.onCheckBoxCheckedChanged(_:)), for: UIControlEvents.valueChanged);
            self.checkBoxArray.append(checkBox);
        }
        //self.setNeedsLayout();
    }
    
    internal func onCheckBoxCheckedChanged(_ sender: AnyObject)
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
    
// MARK: - layoutSubviews
    
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
    
//    + (DZCheckBoxGroup*) checkBoxgroupWithFrame:(CGRect)frame;
//    + (DZCheckBoxGroup*) checkBoxgroupWithFrame:(CGRect)frame items:(NSArray*)items;
    
//    - (void) addCheckBox:(DZCheckBox*)checkBox;
//    - (void) addCheckBoxes:(NSArray*)items;
}
