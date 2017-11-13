//
//  DZStepper.swift
//  DZ_UIKit
//
//  Created by 胡 昱化 on 16/5/24.
//
//

import UIKit

@IBDesignable
open class DZStepper: UIControl {
    
// MARK: - properties
    
    @IBInspectable open var maxValue: Int = 10;
    @IBInspectable open var minValue: Int = 0;
    
    @IBInspectable open var mainColor: UIColor    = UIColor.orange;
    @IBInspectable open var textColor: UIColor    = UIColor.white;
    
    @IBInspectable open var plusImage: UIImage?;
    @IBInspectable open var minusImage: UIImage?;
    
    @IBInspectable open var currentValue: Int = 0;
    
    fileprivate var changeTimer: Timer = Timer();
    
    fileprivate var numberLabel: UILabel = UILabel();
    fileprivate var increaseButton: UIImageView = UIImageView();
    fileprivate var decreaseButton: UIImageView = UIImageView();
    fileprivate var pushedDur: CGFloat = 0.0;
    fileprivate var stepLength = 1;

// MARK: - init
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.createControllers();
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame);
        self.createControllers();
    }
    
    fileprivate func createControllers() {
        self.addSubview(self.increaseButton);
        self.addSubview(self.decreaseButton);
        self.addSubview(self.numberLabel);
    }
    
// MARK: - Touches handle
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: self);
        if ( location != nil ) {
            self.changeValue(withTouchLocation: location!);
        }
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: self);
        if ( location != nil ) {
            if ( !self.increaseButton.frame.contains(location!) && !self.decreaseButton.frame.contains(location!) ) {
                self.increaseButton.backgroundColor = self.increaseButton.backgroundColor?.withAlphaComponent(1.0);
                self.decreaseButton.backgroundColor = self.decreaseButton.backgroundColor?.withAlphaComponent(1.0);
                self.changeTimer.invalidate();
                self.stepLength = 1;
                self.pushedDur = 0.0;
            }
        }
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.increaseButton.backgroundColor = self.increaseButton.backgroundColor?.withAlphaComponent(1.0);
        self.decreaseButton.backgroundColor = self.decreaseButton.backgroundColor?.withAlphaComponent(1.0);
        changeTimer.invalidate();
        self.stepLength = 1;
        self.pushedDur = 0.0;
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.increaseButton.backgroundColor = self.increaseButton.backgroundColor?.withAlphaComponent(1.0);
        self.decreaseButton.backgroundColor = self.decreaseButton.backgroundColor?.withAlphaComponent(1.0);
        changeTimer.invalidate();
        self.stepLength = 1;
        self.pushedDur = 0.0;
    }
    
// MARK: - change value functions
    
    fileprivate func changeValue(withTouchLocation location: CGPoint) {
        if ( self.increaseButton.frame.contains(location) ) {
            self.increase();
            changeTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(DZStepper.increase), userInfo: nil, repeats: true);

        }
        else if ( self.decreaseButton.frame.contains(location) ) {
            self.decrease();
            changeTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(DZStepper.decrease), userInfo: nil, repeats: true);
        }
        else {
            self.changeTimer.invalidate();
            self.stepLength = 1;
            self.pushedDur = 0.0;
        }
    }
    
    @objc internal func increase() {
        self.pushedDur += 0.5;
        //DebugLog("self.pushedDur =  ", self.pushedDur);
        if  self.pushedDur > 5.0 {
            self.stepLength = max(self.maxValue/20, 5);
        }
        if ( self.currentValue < self.maxValue ) {
            self.increaseButton.backgroundColor = self.increaseButton.backgroundColor?.withAlphaComponent(0.5);
            self.currentValue = (self.currentValue+stepLength > self.maxValue) ? self.maxValue : (self.currentValue+stepLength);
            self.numberLabel.text = String(self.currentValue);
            self.sendActions(for: UIControlEvents.valueChanged);
        }
    }
    
    @objc internal func decrease() {
        if ( self.currentValue > self.minValue ) {
            self.decreaseButton.backgroundColor = self.decreaseButton.backgroundColor?.withAlphaComponent(0.5);
            self.currentValue = (self.currentValue-stepLength<self.minValue) ? self.minValue : (self.currentValue-stepLength);
            self.numberLabel.text = String(self.currentValue);
            self.sendActions(for: UIControlEvents.valueChanged);
        }
    }

// MARK: - layoutSubviews

    override open func layoutSubviews() {
        super.layoutSubviews();
        
        self.increaseButton.frame = CGRect(x: self.frame.width-self.frame.height, y: 0, width: self.frame.height, height: self.frame.height);
        self.decreaseButton.frame = CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height);
        
        if ( self.plusImage == nil || self.minusImage == nil ) {
            self.layer.cornerRadius = self.frame.height/2;
            self.clipsToBounds = true;
            
            var imageStr = Bundle(for: DZStepper.self).path(forResource: "plus", ofType: "png");
            increaseButton.image = UIImage(data: try! Data(contentsOf: URL(fileURLWithPath: imageStr!)));
            imageStr = Bundle(for: DZStepper.self).path(forResource: "minus", ofType: "png");
            decreaseButton.image = UIImage(data: try! Data(contentsOf: URL(fileURLWithPath: imageStr!)));
            
            self.increaseButton.backgroundColor = self.mainColor;
            increaseButton.layer.cornerRadius = increaseButton.frame.width/2;
            
            self.decreaseButton.backgroundColor = self.mainColor;
            decreaseButton.layer.cornerRadius = decreaseButton.frame.width/2;
        }
        else {
            increaseButton.image = self.plusImage;
            decreaseButton.image = self.minusImage;
        }
        
        self.numberLabel.frame = CGRect(x: self.frame.height, y: 0, width: self.frame.width-self.frame.height*2, height: self.frame.height);
        self.numberLabel.font = UIFont.boldSystemFont(ofSize: self.frame.height*0.7);
        self.numberLabel.text = String(self.currentValue);
        self.numberLabel.textAlignment = .center;
        self.numberLabel.textColor = self.textColor;
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
