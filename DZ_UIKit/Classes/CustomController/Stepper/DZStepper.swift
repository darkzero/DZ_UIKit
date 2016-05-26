//
//  DZStepper.swift
//  Pods
//
//  Created by 胡 昱化 on 16/5/24.
//
//

import UIKit

@IBDesignable
public class DZStepper: UIControl {
    
    @IBInspectable public var maxValue: Int = 10;
    @IBInspectable public var minValue: Int = 0;
    
    @IBInspectable public var firstColor   = UIColor.whiteColor();
    @IBInspectable public var secondColor  = UIColor.orangeColor();
    
    private var changeTimer: NSTimer = NSTimer();
    
    public var currentValue: Int = 0;
    
    private var numberLabel: UILabel = UILabel();
    private var increaseButton: UIButton = UIButton(type: UIButtonType.Custom);
    private var decreaseButton: UIButton = UIButton(type: UIButtonType.Custom);
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.createControllers();
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame);
        self.createControllers();
        
        self.layer.cornerRadius = 10.0;
        self.clipsToBounds = true;
    }
    
    private func createControllers() {
        
        self.addSubview(self.increaseButton);
        self.addSubview(self.decreaseButton);
        self.addSubview(self.numberLabel);
    }
    
    func onIncreaseButtonClicked(sender: UIButton) {
        changeTimer.invalidate();
        self.increase();
    }
    
    func onDecreaseButtonClicked(sender: UIButton) {
        changeTimer.invalidate();
        self.decrease();
    }
    
    func onIncreaseButtonPushed(sender: UIButton) {
        if ( self.currentValue < self.maxValue ) {
            changeTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(DZStepper.increase), userInfo: nil, repeats: true);
        }
    }
    
    func onDecreaseButtonPushed(sender: UIButton) {
        if ( self.currentValue > self.minValue ) {
            changeTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(DZStepper.decrease), userInfo: nil, repeats: true);
        }
    }
    
    func increase() {
        if ( self.currentValue < self.maxValue ) {
            self.currentValue += 1;
            self.numberLabel.text = String(self.currentValue);
            self.sendActionsForControlEvents(UIControlEvents.ValueChanged);
        }
    }
    
    func decrease() {
        if ( self.currentValue > self.minValue ) {
            self.currentValue -= 1;
            self.numberLabel.text = String(self.currentValue);
            self.sendActionsForControlEvents(UIControlEvents.ValueChanged);
        }
    }
    
    override public func layoutSubviews() {
        print("DZStepper layoutSubviews");
        super.layoutSubviews();
        
        self.increaseButton.frame = CGRectMake(self.frame.width-self.frame.height, 0, self.frame.height, self.frame.height);
        self.increaseButton.setTitle("+", forState: UIControlState.Normal);
        self.increaseButton.setTitleColor(self.firstColor, forState: .Normal);
        self.increaseButton.titleLabel?.font = UIFont.boldSystemFontOfSize(20.0);
        self.increaseButton.backgroundColor = self.secondColor;
        
        self.decreaseButton.frame = CGRectMake(0, 0, self.frame.height, self.frame.height);
        self.decreaseButton.setTitle("-", forState: UIControlState.Normal);
        self.decreaseButton.setTitleColor(self.firstColor, forState: .Normal);
        self.decreaseButton.titleLabel?.font = UIFont.boldSystemFontOfSize(20.0);
        self.decreaseButton.backgroundColor = self.secondColor;
        
        self.numberLabel.frame = CGRectMake(self.frame.height, 0, self.frame.width-self.frame.height*2, self.frame.height);
        self.numberLabel.text = String(self.minValue);
        self.numberLabel.textAlignment = .Center;
        self.numberLabel.textColor = self.secondColor;
        
        self.increaseButton.addTarget(self, action: #selector(DZStepper.onIncreaseButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside);
        self.increaseButton.addTarget(self, action: #selector(DZStepper.onIncreaseButtonPushed(_:)), forControlEvents: UIControlEvents.TouchDown);
        self.increaseButton.addTarget(self, action: #selector(DZStepper.onIncreaseButtonClicked(_:)), forControlEvents: UIControlEvents.TouchDragOutside);
        
        self.decreaseButton.addTarget(self, action: #selector(DZStepper.onDecreaseButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside);
        self.decreaseButton.addTarget(self, action: #selector(DZStepper.onDecreaseButtonPushed(_:)), forControlEvents: UIControlEvents.TouchDown);
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
