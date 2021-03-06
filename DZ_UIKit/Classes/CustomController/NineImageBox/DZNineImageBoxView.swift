//
//  DZNineImageBoxView.swift
//  DZ_UIKit
//
//  Created by 胡 昱化 on 16/5/13.
//
//

import UIKit

public protocol DZNineImageBoxViewDelegate {
    // tap event
    func nineImageBoxView(_ nineImageBoxView: DZNineImageBoxView, didTapImageAtIndex index: Int);
}

open class DZNineImageBoxView: UIView {
    
// MARK: - class define
    
    let TAG_BASE: Int           = 1000;
    let MAX_IMAGE_COUNT: Int    = 9;
    let IMAGE_SPACING: CGFloat  = 4.0;
    
// MARK: - properites
    
    open var imageUrlList = Array<String>();
    
    var imageViewList = Array<UIImageView>();
    
    open var delegate:DZNineImageBoxViewDelegate?;
    
// MARK: - init
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    open class func nineImageBoxView(withImages images: [String], frame: CGRect) -> DZNineImageBoxView {
        let obj = DZNineImageBoxView(frame: frame);
        obj.imageUrlList = images;
        obj.calcFrame();
        return obj;
    }
    
    private func calcFrame() {
        let imageCount = (self.imageUrlList.count > MAX_IMAGE_COUNT) ? MAX_IMAGE_COUNT : self.imageUrlList.count;
        let countInOneLine  = ceil(sqrt(CGFloat(imageCount)));              // 1 pic = 1, 2,3,4 pic = 2, 5,6,7,8,9 pic = 3
        let lineCount       = ceil(CGFloat(imageCount) / countInOneLine);   // 1,2 pic = 1, 3,4,5,6 pic = 2, 7,8,9 pic = 3
        let sideLength      = floor((self.frame.size.width-IMAGE_SPACING*(countInOneLine-1.0))/countInOneLine);
        //let sizeOfOneImage  = CGSizeMake(sideLength, sideLength);
        
        let width   = countInOneLine * (sideLength+IMAGE_SPACING) - IMAGE_SPACING;
        let height  = lineCount * (sideLength+IMAGE_SPACING) - IMAGE_SPACING;
        
        self.frame.size = CGSize(width: width, height: height);
    }
    
    // for autoLayout
    override open var intrinsicContentSize : CGSize {
        let imageCount = (self.imageUrlList.count > MAX_IMAGE_COUNT) ? MAX_IMAGE_COUNT : self.imageUrlList.count;
        let countInOneLine  = ceil(sqrt(CGFloat(imageCount)));              // 1 = 1, 2,3,4 = 2, 5,6,7,8,9 = 3
        if ( countInOneLine != 0 ) {
            let lineCount       = ceil(CGFloat(imageCount) / countInOneLine);   // 1,2 = 1, 3,4,5,6 = 2, 7,8,9 = 3
            let sideLength      = floor((self.frame.size.width-IMAGE_SPACING*(countInOneLine-1.0))/countInOneLine);
            //let sizeOfOneImage  = CGSizeMake(sideLength, sideLength);
            
            let width   = countInOneLine * (sideLength+IMAGE_SPACING) - IMAGE_SPACING;
            let height  = lineCount * (sideLength+IMAGE_SPACING) - IMAGE_SPACING;
            
            self.frame.size = CGSize(width: width, height: height);
            layoutIfNeeded()
            
            return CGSize(width: width, height: height);
        }
        return CGSize(width: 10, height: 10);
    }
    
    @objc func onTapImage(_ sender: UITapGestureRecognizer) {
        if (delegate != nil) {
            let tag = sender.view?.tag;
            delegate?.nineImageBoxView(self, didTapImageAtIndex: tag!-TAG_BASE);
        }
    }
    
// MARK: - layoutSubviews
    
    override open func layoutSubviews() {
        super.layoutSubviews();
        // calc image count, if > 9, then 9
        let imageCount = (self.imageUrlList.count > MAX_IMAGE_COUNT) ? MAX_IMAGE_COUNT : self.imageUrlList.count;
        
        // calc frame for one imageView
        let countInOneLine  = ceil(sqrt(CGFloat(imageCount)));              // 1 = 1, 2,3,4 = 2, 5,6,7,8,9 = 3
        //let lineCount       = ceil(CGFloat(imageCount) / countInOneLine);   // 1,2 = 1, 3,4,5,6 = 2, 7,8,9 = 3
        let sideLength      = floor((self.frame.size.width-IMAGE_SPACING*(countInOneLine-1.0))/countInOneLine);
        //let sizeOfOneImage  = CGSizeMake(sideLength, sideLength);
        
        if ( imageCount > 0 ) {
            for i in 0 ... (imageCount-1) {
                let viewTag = TAG_BASE + i;
                let rect = CGRect(x: (sideLength+IMAGE_SPACING)*(CGFloat(i).truncatingRemainder(dividingBy: countInOneLine)), y: (sideLength+IMAGE_SPACING)*floor(CGFloat(i)/countInOneLine), width: sideLength, height: sideLength);
                let imageView = UIImageView(frame: rect);
                imageView.contentMode = .scaleAspectFill;
                imageView.clipsToBounds = true;
                let url = URL(string: self.imageUrlList[i])!;
                //imageView.imageOfURL(url);
                imageView.tag = viewTag;
                imageView.isUserInteractionEnabled = true;
                let tap = UITapGestureRecognizer(target: self, action: #selector(DZNineImageBoxView.onTapImage(_:)));
                imageView.addGestureRecognizer(tap);
                self.addSubview(imageView);
            }
        }
    }
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
}
