//
//  DZStepper.swift
//  Pods
//
//  Created by 胡 昱化 on 16/5/24.
//
//

import UIKit

@IBDesignable
class DZStepper: UIControl {
    
    @IBInspectable var maxValue: Int = 10;
    @IBInspectable var minValue: Int = 0;
    
    private var numberLabel: UILabel = UILabel();
    private var increaseButton: UIButton = UIButton(type: UIButtonType.Custom);
    private var decreaseButton: UIButton = UIButton(type: UIButtonType.Custom);

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
