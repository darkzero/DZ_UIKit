//
//  NineImageBoxView.swift
//  Pods
//
//  Created by 胡 昱化 on 16/5/13.
//
//

import UIKit

public protocol DZNineImageBoxViewDelegate {
    // tap event
    func nineImageView(_ aButtonMenu: DZNineImageBoxView, tapImageAtIndex index: Int);
}

open class DZNineImageBoxView: UIView {
    
    // MARK: - - class define
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
    
    open class func nineImageBoxViewWithImages(_ images: Array<String>, frame: CGRect) -> DZNineImageBoxView {
        let obj = DZNineImageBoxView(frame: frame);
        obj.imageUrlList = images;
        obj.calcFrame();
        return obj;
    }
    
    func calcFrame() {
        let imageCount = (self.imageUrlList.count > MAX_IMAGE_COUNT) ? MAX_IMAGE_COUNT : self.imageUrlList.count;
        let countInOneLine  = ceil(sqrt(CGFloat(imageCount)));              // 1 = 1, 2,3,4 = 2, 5,6,7,8,9 = 3
        let lineCount       = ceil(CGFloat(imageCount) / countInOneLine);   // 1,2 = 1, 3,4,5,6 = 2, 7,8,9 = 3
        let sideLength      = floor((self.frame.size.width-IMAGE_SPACING*(countInOneLine-1.0))/countInOneLine);
        //let sizeOfOneImage  = CGSizeMake(sideLength, sideLength);
        
        let width   = countInOneLine * (sideLength+IMAGE_SPACING) - IMAGE_SPACING;
        let height  = lineCount * (sideLength+IMAGE_SPACING) - IMAGE_SPACING;
        
        self.frame.size = CGSize(width: width, height: height);
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
                let url = URL(string: self.imageUrlList[i])!;//"http://place-hold.it/200x200"
                let image = url.getImageWithCache();
                imageView.image = image;
                imageView.tag = viewTag;
                imageView.isUserInteractionEnabled = true;
                let tap = UITapGestureRecognizer(target: self, action: #selector(DZNineImageBoxView.onTapImageAtIndex(_:)));
                imageView.addGestureRecognizer(tap);
                self.addSubview(imageView);
            }
        }
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
    
    func onTapImageAtIndex(_ sender: UITapGestureRecognizer) {
        if (delegate != nil) {
            let tag = sender.view?.tag;
            delegate?.nineImageView(self, tapImageAtIndex: tag!-TAG_BASE);
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
