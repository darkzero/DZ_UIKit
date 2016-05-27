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
    
    @IBInspectable public var mainColor: UIColor    = UIColor.orangeColor();
    @IBInspectable public var textColor: UIColor    = UIColor.whiteColor();
    
    @IBInspectable public var plusImage: UIImage?;
    @IBInspectable public var minusImage: UIImage?;
    
    private var changeTimer: NSTimer = NSTimer();
    
    @IBInspectable public var currentValue: Int = 0;
    
    private var numberLabel: UILabel = UILabel();
    private var increaseButton: UIImageView = UIImageView();
    private var decreaseButton: UIImageView = UIImageView();
    private var pushedDur: CGFloat = 0.0;
    private var stepLength = 1;
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.createControllers();
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame);
        self.createControllers();
    }
    
    private func createControllers() {
        
        self.addSubview(self.increaseButton);
        self.addSubview(self.decreaseButton);
        self.addSubview(self.numberLabel);
    }
    
    func increase() {
        self.pushedDur += 0.5;
        print("self.pushedDur =  ", self.pushedDur);
        if  self.pushedDur > 5.0 {
            self.stepLength = max(self.maxValue/20, 5);
        }
        if ( self.currentValue < self.maxValue ) {
            self.increaseButton.backgroundColor = self.increaseButton.backgroundColor?.colorWithAlphaComponent(0.5);
            self.currentValue += stepLength;
            self.numberLabel.text = String(self.currentValue);
            self.sendActionsForControlEvents(UIControlEvents.ValueChanged);
        }
    }
    
    func decrease() {
        if ( self.currentValue > self.minValue ) {
            self.decreaseButton.backgroundColor = self.decreaseButton.backgroundColor?.colorWithAlphaComponent(0.5);
            self.currentValue -= stepLength;
            self.numberLabel.text = String(self.currentValue);
            self.sendActionsForControlEvents(UIControlEvents.ValueChanged);
        }
    }
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let location = touches.first?.locationInView(self);
        if ( location != nil ) {
            self.changeValueWithTouchLocation(location!);
        }
    }
    
    public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let location = touches.first?.locationInView(self);
        if ( location != nil ) {
            if ( !self.increaseButton.frame.contains(location!) && !self.decreaseButton.frame.contains(location!) ) {
                self.increaseButton.backgroundColor = self.increaseButton.backgroundColor?.colorWithAlphaComponent(1.0);
                self.decreaseButton.backgroundColor = self.decreaseButton.backgroundColor?.colorWithAlphaComponent(1.0);
                self.changeTimer.invalidate();
                self.stepLength = 1;
                self.pushedDur = 0.0;
            }
        }
    }
    
    public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        self.increaseButton.backgroundColor = self.increaseButton.backgroundColor?.colorWithAlphaComponent(1.0);
        self.decreaseButton.backgroundColor = self.decreaseButton.backgroundColor?.colorWithAlphaComponent(1.0);
        changeTimer.invalidate();
        self.stepLength = 1;
        self.pushedDur = 0.0;
    }
    
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.increaseButton.backgroundColor = self.increaseButton.backgroundColor?.colorWithAlphaComponent(1.0);
        self.decreaseButton.backgroundColor = self.decreaseButton.backgroundColor?.colorWithAlphaComponent(1.0);
        changeTimer.invalidate();
        self.stepLength = 1;
        self.pushedDur = 0.0;
    }
    
    func changeValueWithTouchLocation(location: CGPoint) {
        if ( self.increaseButton.frame.contains(location) ) {
            self.increase();
            changeTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(DZStepper.increase), userInfo: nil, repeats: true);

        }
        else if ( self.decreaseButton.frame.contains(location) ) {
            self.decrease();
            changeTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(DZStepper.decrease), userInfo: nil, repeats: true);
        }
        else {
            self.changeTimer.invalidate();
            self.stepLength = 1;
            self.pushedDur = 0.0;
        }
    }
    
    override public func layoutSubviews() {
        print("DZStepper layoutSubviews");
        super.layoutSubviews();
        
        self.increaseButton.frame = CGRectMake(self.frame.width-self.frame.height, 0, self.frame.height, self.frame.height);
        self.decreaseButton.frame = CGRectMake(0, 0, self.frame.height, self.frame.height);
        
        if ( self.plusImage == nil || self.minusImage == nil ) {
            self.layer.cornerRadius = self.frame.height/2;
            self.clipsToBounds = true;
            
            var imageStr = NSBundle(forClass: DZStepper.self).pathForResource("plus", ofType: "png");
            increaseButton.image = UIImage(data: NSData(contentsOfURL: NSURL(fileURLWithPath: imageStr!))!);
            imageStr = NSBundle(forClass: DZStepper.self).pathForResource("minus", ofType: "png");
            decreaseButton.image = UIImage(data: NSData(contentsOfURL: NSURL(fileURLWithPath: imageStr!))!);
            
            self.increaseButton.backgroundColor = self.mainColor;
            increaseButton.layer.cornerRadius = increaseButton.frame.width/2;
            
            self.decreaseButton.backgroundColor = self.mainColor;
            decreaseButton.layer.cornerRadius = decreaseButton.frame.width/2;
        }
        else {
            increaseButton.image = self.plusImage;
            decreaseButton.image = self.minusImage;
        }
        
        self.numberLabel.frame = CGRectMake(self.frame.height, 0, self.frame.width-self.frame.height*2, self.frame.height);
        self.numberLabel.font = UIFont.boldSystemFontOfSize(self.frame.height*0.7);
        self.numberLabel.text = String(self.currentValue);
        self.numberLabel.textAlignment = .Center;
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
