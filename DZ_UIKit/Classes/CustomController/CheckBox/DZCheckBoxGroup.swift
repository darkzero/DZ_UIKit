//
//  DZCheckBoxGroup.swift
//  DZLib
//
//  Created by Dora.Yuan on 2014/10/08.
//  Copyright (c) 2014 Dora.Yuan All rights reserved.
//

import Foundation
import UIKit

public enum DZCheckBoxGroupStyle: Int {
    case Default    = 0;
    case Bar        = 1;
    case List       = 2;
}

protocol DZCheckBoxGroupDelegate {
    func numberOfCheckBoxes() -> Int;
    func checkBoxSizeOfGroup(group : DZCheckBoxGroup, atIndex theIndex : Int)-> CGSize;
    func checkBoxOfGroup(group : DZCheckBoxGroup, atIndex theIndex : Int) -> DZCheckBox;
}

public class DZCheckBoxGroup : UIControl {
    
    public var multipleCheckEnabled:Bool    = false;
    public var style: DZCheckBoxGroupStyle  = .Default;
    
    public var checkedIndexes:NSMutableArray {
        didSet {
            for i in 0 ... (self.checkBoxArray.count - 1) {
                let checkBox:DZCheckBox = self.checkBoxArray[i] as! DZCheckBox;
                if ( self.checkedIndexes.containsObject(i) ) {
                    checkBox.checked = true;
                }
            }
        }
    };
    
    private var checkBoxArray:NSMutableArray;

    required public init?(coder aDecoder: NSCoder) {
        self.multipleCheckEnabled   = false;
        self.checkBoxArray          = NSMutableArray();
        self.checkedIndexes         = NSMutableArray();
        
        super.init(coder: aDecoder);
        self.backgroundColor        = UIColor.clearColor();
    }
    
    override init(frame: CGRect) {
        self.multipleCheckEnabled   = false;
        self.checkBoxArray          = NSMutableArray();
        self.checkedIndexes         = NSMutableArray();
        
        super.init(frame:frame);
        self.backgroundColor        = UIColor.clearColor();
    }
    
    override public func didMoveToSuperview() {
        self.backgroundColor = UIColor.clearColor();
        super.didMoveToSuperview();
    }
    
    override public func layoutSubviews() {
        var _ = self.subviews.map { $0.removeFromSuperview() };
        
        let itemsCount:Int  = self.checkBoxArray.count;
        let theCheckBox     = self.checkBoxArray[0] as! DZCheckBox;
        var theRect:CGRect  = CGRectZero;
        
        
        switch self.style {
        case .List :
            theRect = CGRectMake( self.frame.origin.x, self.frame.origin.y,
                                 theCheckBox.frame.size.width, (theCheckBox.frame.size.height + 5)*CGFloat(itemsCount));
            for i in 0 ... (itemsCount-1) {
                let aCheckBox = self.checkBoxArray[i] as! DZCheckBox;
                aCheckBox.frame.origin = CGPointMake(0, (aCheckBox.frame.size.height+5)*CGFloat(i));
                
                self.addSubview(aCheckBox);
            }
            break;
        case .Bar, .Default :
            theRect = CGRectMake( self.frame.origin.x, self.frame.origin.y,
                                  (theCheckBox.frame.size.width + 5)*CGFloat(itemsCount), theCheckBox.frame.size.height);
            for i in 0 ... (itemsCount-1) {
                let aCheckBox = self.checkBoxArray[i] as! DZCheckBox;
                aCheckBox.frame.origin = CGPointMake((aCheckBox.frame.size.width+5)*CGFloat(i), 0);
                
                self.addSubview(aCheckBox);
            }
            break;
        }
        
        self.frame = theRect;
    }
    
    public class func checkBoxgroupWithFrame(frame : CGRect) -> DZCheckBoxGroup {
        let group:DZCheckBoxGroup! = DZCheckBoxGroup(frame:frame);
        return group;
    }
    
    public class func checkBoxgroupWithFrame(frame : CGRect, Items items : [DZCheckBox]) -> DZCheckBoxGroup {
        let group = DZCheckBoxGroup(frame:frame);
        group.checkBoxArray.addObjectsFromArray(items);
        return group;
    }
    
    public func addCheckBox(checkBox:DZCheckBox) {
        checkBox.addTarget(self, action: #selector(DZCheckBoxGroup.onCheckBoxCheckedChanged(_:)), forControlEvents: UIControlEvents.ValueChanged);
        self.checkBoxArray.addObject(checkBox);
        //self.setNeedsLayout();
    }
    
    public func addCheckBoxes(items:NSArray) {
        for obj: AnyObject in items {
            if let checkBox = obj as? DZCheckBox {
                checkBox.addTarget(self, action: #selector(DZCheckBoxGroup.onCheckBoxCheckedChanged(_:)), forControlEvents: UIControlEvents.ValueChanged);
                self.checkBoxArray.addObject(checkBox);
            }
        }
        //self.setNeedsLayout();
    }
    
    public func onCheckBoxCheckedChanged(sender: AnyObject)
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
        
        self.checkedIndexes.removeAllObjects();
        for i in 0 ... (self.checkBoxArray.count - 1) {
            let checkBox = self.checkBoxArray[i] as! DZCheckBox;
            if ( checkBox.checked ) {
                self.checkedIndexes.addObject(i);
            }
        }
        
        self.sendActionsForControlEvents(UIControlEvents.ValueChanged);
    }
    
//    + (DZCheckBoxGroup*) checkBoxgroupWithFrame:(CGRect)frame;
//    + (DZCheckBoxGroup*) checkBoxgroupWithFrame:(CGRect)frame items:(NSArray*)items;
    
//    - (void) addCheckBox:(DZCheckBox*)checkBox;
//    - (void) addCheckBoxes:(NSArray*)items;
}