//
//  DZCheckBox.swift
//  DZ_UIKit
//
//  Created by Dora.Yuan on 2014/10/08.
//  Copyright (c) 2014 Dora.Yuan All rights reserved.
//

import Foundation
import UIKit

//let VALUE_KEY_CHECKED   = "_checked";

let DEFAULT_CHECKED_COLOR   = UIColor.colorWithDec(Red: 184, Green: 208, Blue: 98, Alpha: 1.0);     // RGB(184, 208, 98);
let DEFAULT_UNCHECKED_COLOR = UIColor.colorWithDec(Red: 230, Green: 230, Blue: 230, Alpha: 1.0);    // RGB(230, 230, 230);

public enum DZCheckBoxType {
    case none
    case circular
    case square
    case rounded
}

@IBDesignable
open class DZCheckBox : UIControl {
    
// MARK: - properties
    
    @IBInspectable public var borderWidth:CGFloat = 1.0;
    
    private var uncheckedLayer: CALayer!;
    private var checkedLayer: CALayer!;
    private var borderLayer: CALayer!;
    
    private var imageView: UIImageView!;
    private var titleLabel: UILabel!;
    
    // for DZCheckBoxType.circular
    private var expansionRect:CGRect!;
    private var contractRect:CGRect!;
    
    // for DZCheckBox.rounded
    private var cornerRadius:CGFloat = 8.0;
    
    @IBInspectable open var type:DZCheckBoxType = .none;
    
    @IBInspectable open var checkBoxSize:CGSize = CGSize(width: 48, height: 48) {
        didSet {
            self.frame.size.height = checkBoxSize.height;
        }
    };
    
    var withTitle: Bool = false;
    @IBInspectable public var title: String = "" {
        didSet {
            if self.withTitle {
                self.titleLabel?.text = title;
                titleLabel.isHidden = false;
                titleLabel.text = self.title;
                let attributes = [NSFontAttributeName : UIFont.systemFont(ofSize: frame.size.height-4)];
                let rect = NSString(string: self.title).boundingRect(with: CGSize(width: 0, height: self.bounds.size.height),
                                                                     options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                                     attributes: attributes,
                                                                     context: nil);
                titleLabel.frame.size = rect.size;
                self.frame.size = CGSize(width: self.frame.size.width + 4 + rect.size.width, height: self.frame.height);
            }
        }
    }
    
    @IBInspectable public var checked: Bool = false {
        didSet {
            self.playAnimation(checked);
        }
    }
    
    @IBInspectable public var borderColor: UIColor?;
    
    @IBInspectable public var uncheckedColor: UIColor = DEFAULT_UNCHECKED_COLOR {
        didSet {
            uncheckedLayer.backgroundColor = uncheckedColor.cgColor;
        }
    };
    
    @IBInspectable public var checkedColor: UIColor = DEFAULT_CHECKED_COLOR {
        didSet {
            checkedLayer.backgroundColor = checkedColor.cgColor;
        }
    };
    
    @IBInspectable public var image: UIImage? {
        didSet {
            self.imageView.image = image;
        }
    };
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder);
        self.createControllers();
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame);
        self.createControllers();
    }
    
    
    public init(frame frame:CGRect,
                type:DZCheckBoxType,
                title: String? = nil,
                image: UIImage? = nil,
                borderColor:UIColor? = nil,
                uncheckedColor:UIColor? = nil,
                checkedColor:UIColor? = nil) {
        super.init(frame:frame);
        if ( self != nil ) {
            if ( borderColor != nil ) {
                self.borderColor    = borderColor;
                //self.borderWidth    = max(frame.width/16, 2);
            }
            
            if ( uncheckedColor != nil ) {
                self.uncheckedColor     = uncheckedColor!;
            }
            
            if ( checkedColor != nil ) {
                self.checkedColor       = checkedColor!;
            }
            
            if title != nil {
                self.withTitle = true;
                self.title = title!;
                //self.setTitle();
            }
            
            if image != nil {
                self.image = image;
            }
            else {
                //let imageStr = Bundle(for: DZCheckBox.self).path(forResource: "checked", ofType: "png");
                //self.image = UIImage(data: try! Data(contentsOf: URL(fileURLWithPath: imageStr!)));
            }
            self.type = type;
            
            self.createControllers();
        }
    }
    
    private func setTitle() {
        self.titleLabel?.text = title;
        titleLabel.isHidden = false;
        titleLabel.text = self.title;
        let attributes = [NSFontAttributeName : UIFont.systemFont(ofSize: frame.size.height-4)];
        let rect = NSString(string: self.title).boundingRect(with: CGSize(width: 0, height: self.bounds.size.height),
                                                             options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                             attributes: attributes,
                                                             context: nil);
        titleLabel.frame.size = rect.size;
        self.frame.size = CGSize(width: self.frame.size.width + 4 + rect.size.width, height: self.frame.height);
    }
    
    fileprivate func createControllers() {
        // Initialization code
        self.backgroundColor = UIColor.clear;
        
        self.checkBoxSize = frame.size;
        
        self.expansionRect  = CGRect(x: self.borderWidth, y: self.borderWidth, width: checkBoxSize.width - self.borderWidth * 2, height: checkBoxSize.height - self.borderWidth * 2);
        self.contractRect   = CGRect(x: checkBoxSize.width/2, y: checkBoxSize.height/2, width: 0, height: 0);
        
        uncheckedLayer = CALayer();
        uncheckedLayer.frame = self.bounds;
        uncheckedLayer.backgroundColor = self.uncheckedColor.cgColor;
        uncheckedLayer.opacity = 1.0;
        self.layer.addSublayer(uncheckedLayer);
        
        checkedLayer = CALayer();
        checkedLayer.frame = contractRect;
        checkedLayer.backgroundColor = self.checkedColor.cgColor;
        checkedLayer.opacity = 0.0;
        self.layer.addSublayer(checkedLayer);
        
        if ( self.borderColor != nil ) {
            self.borderLayer = CALayer();
            self.borderLayer.frame = UIEdgeInsetsInsetRect(self.expansionRect,
                                                           UIEdgeInsetsMake(2, 2, 2, 2));
            self.borderLayer.borderColor = UIColor.white.cgColor;//self.borderColor!.cgColor;
            self.borderLayer.borderWidth = self.borderWidth;
            self.borderLayer.opacity = 1.0;
            self.layer.addSublayer(borderLayer);
        }
        
        // set title
        self.titleLabel = UILabel();
        self.titleLabel.frame = CGRect(x: frame.size.width+4, y: 0,
                                       width: 0, height: frame.size.height);
        self.titleLabel.isHidden = true;
        self.addSubview(self.titleLabel);
        if ( self.withTitle ) {
            self.setTitle();
        }
        
        // set default image
        imageView = UIImageView(frame: self.bounds);
        let imageStr = Bundle(for: DZCheckBox.self).path(forResource: "checked", ofType: "png");
        self.image = UIImage(data: try! Data(contentsOf: URL(fileURLWithPath: imageStr!)));
        self.addSubview(imageView);
        
        self.addTarget(self, action: #selector(DZCheckBox.onCheckBoxTouched(_:)), for: UIControlEvents.touchUpInside);
    }
    
// MARK: - touch handler
    
    internal func onCheckBoxTouched(_ sender:AnyObject)
    {
        let oldValue:Bool = self.checked;
        self.checked = !oldValue;
    }
    
    fileprivate func playAnimation(_ checked:Bool)
    {
        if ( checked ) {
            UIView.animate(withDuration: 0.1, delay: 0.1, options: .allowUserInteraction, animations: {
                self.checkedLayer.opacity   = 1.0;
                self.checkedLayer.frame     = self.expansionRect;
                self.titleLabel.textColor   = self.checkedColor;
                switch self.type {
                case .rounded :
                    self.checkedLayer.cornerRadius      = self.cornerRadius;
                    break;
                case .square :
                    self.checkedLayer.cornerRadius      = 0;
                    break;
                case .circular, .none :
                    self.checkedLayer.cornerRadius      = self.expansionRect.size.width / 2;
                    break;
                }
            }, completion: { (result) in
                self.sendActions(for: UIControlEvents.valueChanged);
            });
        }
        else {
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .allowUserInteraction, animations: {
                self.checkedLayer.opacity   = 0.0;
                self.checkedLayer.frame     = self.contractRect;
                self.titleLabel.textColor   = self.uncheckedColor;
            }, completion: { (result) in
                self.sendActions(for: UIControlEvents.valueChanged);
            });
        }
    }
    
// MARK: - draw
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect);
        
        self.expansionRect      = CGRect(x: 0, y: 0,
                                         width: checkBoxSize.width,
                                         height: checkBoxSize.height);
        imageView.frame         = CGRect(x: 2, y: 2,
                                         width: self.expansionRect.size.width-4,
                                         height: self.expansionRect.size.height-4);
        
        self.uncheckedLayer.frame   = self.expansionRect;
        self.checkedLayer.frame     = self.expansionRect;
        
        if self.checked {
            self.checkedLayer.opacity   = 1.0;
            self.checkedLayer.frame     = self.expansionRect;
            self.titleLabel.textColor   = self.checkedColor;
        }
        else {
            self.checkedLayer.opacity   = 0.0;
            self.checkedLayer.frame     = self.contractRect;
            self.titleLabel.textColor   = self.uncheckedColor;
        }
        
        uncheckedLayer.backgroundColor  = self.uncheckedColor.cgColor;
        checkedLayer.backgroundColor    = self.checkedColor.cgColor;
        
        // Drawing code
        switch self.type {
        case .rounded :
            self.uncheckedLayer.cornerRadius    = self.cornerRadius;
            self.checkedLayer.cornerRadius      = self.cornerRadius;
            self.borderLayer?.cornerRadius      = self.cornerRadius - 2;
            break;
        case .square :
            break;
        case .circular, .none :
            self.uncheckedLayer.cornerRadius    = self.expansionRect.size.width / 2;
            self.borderLayer?.cornerRadius      = (self.expansionRect.size.width - 4) / 2;
            if self.checked {
                self.checkedLayer.cornerRadius  = self.expansionRect.size.width / 2;
            } else {
                self.checkedLayer.cornerRadius  = self.cornerRadius;
            }
            break;
        }
    }
}
