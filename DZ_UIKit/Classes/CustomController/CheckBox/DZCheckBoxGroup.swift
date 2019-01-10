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
    case bar        = 1;
    case list       = 2;
}

public class DZCheckBoxGroup : UIControl {
    // MARK: - properties
    public var multipleCheckEnabled:Bool    = false;
    public var style: DZCheckBoxGroupStyle  = .bar;
    open var checkedIndexes:[Int];
    private var checkBoxArray:[DZCheckBox];


    /// init
    required public init?(coder aDecoder: NSCoder) {
        self.multipleCheckEnabled   = false;
        self.checkBoxArray          = [DZCheckBox]();
        self.checkedIndexes         = [Int]();
        
        super.init(coder: aDecoder);
        self.backgroundColor        = UIColor.clear;
    }
    
    public init() {
        self.multipleCheckEnabled   = false;
        self.checkBoxArray          = [DZCheckBox]();
        self.checkedIndexes         = [Int]();
        
        super.init(frame:CGRect.zero);
        self.backgroundColor        = UIColor.clear;
    }
    
    override public init(frame: CGRect) {
        self.multipleCheckEnabled   = false;
        self.checkBoxArray          = [DZCheckBox]();
        self.checkedIndexes         = [Int]();
        
        super.init(frame:frame);
        self.backgroundColor        = UIColor.clear;
    }
    
    @available(*, deprecated, message: "no longer available ...")
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
    
    /// add check box at end
    public func addCheckBox(_ checkBox:DZCheckBox) {
        checkBox.group = self;
        self.checkBoxArray.append(checkBox);
    }
    
    /// add check boxes at end
    public func addCheckBoxes(_ items:[DZCheckBox]) {
        for checkBox in items {
            checkBox.group = self;
            self.checkBoxArray.append(checkBox);
        }
    }

    internal func onCheckBoxCheckedChanged(_ sender: AnyObject)
    {
        let box     = sender as! DZCheckBox;
        let checked = box.checked;
        if ( !self.multipleCheckEnabled && checked ) {
            for aBox in self.checkBoxArray {
                if ( !aBox.isEqual(sender) && aBox.checked ) {
                    aBox.checked =  false;
                }
            }
        }
        
        self.checkedIndexes.removeAll();
        for i in 0 ... (self.checkBoxArray.count - 1) {
            let checkBox = self.checkBoxArray[i];
            if ( checkBox.checked ) {
                self.checkedIndexes.append(i);
            }
        }
        
        self.sendActions(for: .valueChanged);
    }
    

    /// layoutSubviews
    override open func layoutSubviews() {
        let itemsCount:Int  = self.checkBoxArray.count;
        let theCheckBox     = self.checkBoxArray[0];
        var theRect:CGRect  = CGRect.zero;
        
        switch self.style {
        case .list :
            theRect = CGRect( x: self.frame.origin.x, y: self.frame.origin.y,
                              width: theCheckBox.frame.size.width, height: (theCheckBox.frame.size.height + 5)*CGFloat(itemsCount));
            for i in 0 ... (itemsCount-1) {
                let aCheckBox = self.checkBoxArray[i];
                aCheckBox.frame.origin = CGPoint(x: 0, y: (aCheckBox.frame.size.height+5)*CGFloat(i));
                
                self.addSubview(aCheckBox);
            }
            break;
        case .bar :
            theRect = CGRect( x: self.frame.origin.x, y: self.frame.origin.y,
                              width: (theCheckBox.frame.size.width + 5)*CGFloat(itemsCount), height: theCheckBox.frame.size.height);
            var preWidth: CGFloat = 0.0
            for i in 0 ... (itemsCount-1) {
                let aCheckBox = self.checkBoxArray[i];
                aCheckBox.frame.origin = CGPoint(x: preWidth, y: 0);
                preWidth = preWidth + aCheckBox.frame.width + 6.0
                self.addSubview(aCheckBox);
            }
            break;
        }
        
        self.frame = theRect;
        
        for i in 0 ... (self.checkBoxArray.count - 1) {
            let checkBox:DZCheckBox = self.checkBoxArray[i];
            if ( self.checkedIndexes.contains(i) ) {
                checkBox.checked = true;
            }
        }
    }
}
