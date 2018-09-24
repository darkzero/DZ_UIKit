//
//  DZCheckBox.swift
//  DZ_UIKit
//
//  Created by Dora.Yuan on 2014/10/08.
//  Copyright (c) 2014 Dora.Yuan All rights reserved.
//

import UIKit

//let VALUE_KEY_CHECKED   = "_checked";

let DEFAULT_CHECKED_COLOR   // RGB(184, 208, 98);
    = RGBA(184, 208, 98, 1.0);

let DEFAULT_UNCHECKED_COLOR // RGB(230, 230, 230);
    = RGBA(230, 230, 230, 1.0);

public enum DZCheckBoxType: Int {
    case circular = 1;
    case square
    case rounded
}

@IBDesignable
public class DZCheckBox : UIControl {
    
// MARK: - properties
    
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
    
    // Border
    @IBInspectable public var hasBorder: Bool       = false;
    @IBInspectable public var borderColor: UIColor  = UIColor.white;
    
    // Type
    public var type:DZCheckBoxType = .circular;
    
    // Size
    @IBInspectable public var checkBoxSize:CGSize = CGSize(width: 48, height: 48) {
        didSet {
            self.frame.size.height = checkBoxSize.height;
        }
    };
    
    // Title
    @IBInspectable public var title: String? {
        didSet {
            if ( title != nil ) {
                //self.titleLabel?.text = title;
                titleLabel.isHidden = false;
                titleLabel.text = self.title;
                let attributes = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: frame.size.height-4)];
                let rect = NSString(string: self.title!).boundingRect(with: CGSize(width: 0, height: self.bounds.size.height),
                                                                     options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                                     attributes: attributes,
                                                                     context: nil);
                titleLabel.frame.size = rect.size;
                self.frame.size = CGSize(width: self.frame.size.width + 4 + rect.size.width, height: self.frame.height);
            }
        }
    }
    
    // Checked
    @IBInspectable public var checked: Bool = false {
        didSet {
            self.playAnimation(checked);
        }
    }
    
    // Color
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
    
    // Image
    @IBInspectable public var image: UIImage? {
        didSet {
            self.imageView.image = image;
        }
    };
    
    // Group
    public var group: DZCheckBoxGroup? {
        didSet {
            //
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder);
        self.createControllers();
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame);
        self.createControllers();
    }
    
    
    public init(frame: CGRect,
                type: DZCheckBoxType,
                title: String? = nil,
                image: UIImage? = nil,
                borderColor: UIColor? = nil,
                uncheckedColor: UIColor? = nil,
                checkedColor: UIColor? = nil) {
        super.init(frame:frame);
        
        if ( borderColor != nil ) {
            self.hasBorder      = true;
            self.borderColor    = borderColor!;
        }
        
        if ( uncheckedColor != nil ) {
            self.uncheckedColor     = uncheckedColor!;
        }
        
        if ( checkedColor != nil ) {
            self.checkedColor       = checkedColor!;
        }
        
        self.title = title;
        
        self.image = image;
        
        self.type = type;
        
        self.createControllers();
    }
    
    fileprivate func createControllers() {
        // Initialization code
        self.backgroundColor = UIColor.clear;
        
        self.checkBoxSize = frame.size;
        
        self.expansionRect      = CGRect(x: 0, y: 0,
                                         width: checkBoxSize.width,
                                         height: checkBoxSize.height);
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
        
        // set title
        self.titleLabel = UILabel();
        self.titleLabel.frame = CGRect(x: self.expansionRect.width+4, y: 0,
                                       width: 0, height: frame.size.height);
        self.titleLabel.isHidden = true;
        self.addSubview(self.titleLabel);
        if ( self.title != nil ) {
            self.setTitle();
        }
        
        // set border layer
        self.borderLayer = CALayer();
        self.borderLayer.frame = UIEdgeInsetsInsetRect(self.expansionRect,
                                                       UIEdgeInsetsMake(2, 2, 2, 2));
        self.borderLayer.borderColor = UIColor.white.cgColor;//self.borderColor!.cgColor;
        self.borderLayer.borderWidth = 1;
        self.borderLayer.opacity = 1.0;
        self.borderLayer.isHidden = true;
        self.layer.addSublayer(borderLayer);
        
        // set default image
        imageView = UIImageView(frame: self.bounds);
        let imageStr = Bundle(for: DZCheckBox.self).path(forResource: "checked", ofType: "png");
        self.image = UIImage(data: try! Data(contentsOf: URL(fileURLWithPath: imageStr!)));
        imageView.frame         = CGRect(x: 0, y: 0,
                                         width: self.expansionRect.size.width,
                                         height: self.expansionRect.size.height);
        self.addSubview(imageView);
        
        self.addTarget(self, action: #selector(DZCheckBox.onCheckBoxTouched(_:)), for: UIControlEvents.touchUpInside);
    }
    
    private func setTitle() {
        titleLabel.isHidden = false;
        titleLabel.text = self.title;
        let font = UIFont.boldSystemFont(ofSize: frame.size.height/2)
        titleLabel.font = font
        let attributes = [NSAttributedStringKey.font : font];
        let rect = NSString(string: self.title!).boundingRect(with: CGSize(width: CGFloat.infinity,
                                                                           height: self.bounds.size.height),
                                                              options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                              attributes: attributes,
                                                              context: nil);
        DebugLog(rect)
        titleLabel.frame.size = rect.size
        self.frame.size = CGSize(width: self.frame.size.width + rect.size.width + 10, height: self.frame.height);
    }
    
// MARK: - touch handler
    
    @objc internal func onCheckBoxTouched(_ sender:AnyObject)
    {
        let oldValue:Bool = self.checked;
        self.checked = !oldValue;
        if ( self.group == nil ) {
            self.sendActions(for: UIControlEvents.valueChanged);
        }
        else {
            self.group?.onCheckBoxCheckedChanged(self);
        }
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
                case .circular :
                    self.checkedLayer.cornerRadius      = self.expansionRect.size.width / 2;
                    break;
                }
            }, completion: { (result) in
//                if ( self.group == nil ) {
//                    self.sendActions(for: UIControlEvents.valueChanged);
//                }
//                else {
//                    self.group?.onCheckBoxCheckedChanged(self);
//                }
            });
        }
        else {
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .allowUserInteraction, animations: {
                self.checkedLayer.opacity   = 0.0;
                self.checkedLayer.frame     = self.contractRect;
                self.titleLabel.textColor   = self.uncheckedColor;
            }, completion: { (result) in
            });
        }
    }
    
// MARK: - draw
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect);
        
        self.expansionRect      = CGRect(x: 0, y: 0,
                                         width: checkBoxSize.width,
                                         height: checkBoxSize.height);
        
        self.titleLabel.frame = CGRect(x: self.expansionRect.width+4, y: 0,
                                       width: 100, height: frame.size.height);
        
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
        
        self.borderLayer.frame = UIEdgeInsetsInsetRect(self.expansionRect,
                                                       UIEdgeInsetsMake(2, 2, 2, 2));
        self.borderLayer.borderColor = self.borderColor.cgColor;
        self.borderLayer.borderWidth = 1;
        if ( self.hasBorder ) {
            
            self.borderLayer.isHidden = false;
            imageView.frame = CGRect(x: 4, y: 4,
                                     width: self.expansionRect.size.width-8,
                                     height: self.expansionRect.size.height-8);
        }
        else {
            self.borderLayer.isHidden = true;
            imageView.frame = CGRect(x: 0, y: 0,
                                     width: self.expansionRect.size.width,
                                     height: self.expansionRect.size.height);
        }
        
        // Drawing code
        switch self.type {
        case .rounded :
            self.uncheckedLayer.cornerRadius    = self.cornerRadius;
            self.checkedLayer.cornerRadius      = self.cornerRadius;
            self.borderLayer?.cornerRadius      = self.cornerRadius - 2;
            break;
        case .square :
            break;
        case .circular :
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
