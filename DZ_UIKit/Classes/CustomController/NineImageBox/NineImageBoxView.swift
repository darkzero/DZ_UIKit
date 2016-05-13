//
//  NineImageBoxView.swift
//  Pods
//
//  Created by 胡 昱化 on 16/5/13.
//
//

import UIKit

class NineImageBoxView: UIView {
    
    // MARK: - - class define
    let TAG_BASE: Int           = 1000;
    let MAX_IMAGE_COUNT: Int    = 9;
    let IMAGE_SPACING: CGFloat  = 4.0;
    
    // MARK: - properites
    var imageUrlList = Array<String>();
    
    private var imageViewList = Array<UIImageView>();
    
    // MARK: -
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
//    private init(frame: CGRect) {
//        super.init(frame: frame);
//    }
    
    public class func nineImageBoxViewWithImages(images: Array<String>, frame: CGRect) -> NineImageBoxView {
        let obj = NineImageBoxView(frame: frame);
        obj.imageUrlList = images;
        return obj;
    }

    // MARK: - layoutSubviews
    
    override func layoutSubviews() {
        super.layoutSubviews();
        // calc image count, if > 9, then 9
        let imageCount = (self.imageUrlList.count > MAX_IMAGE_COUNT) ? MAX_IMAGE_COUNT : self.imageUrlList.count;
        
        // calc frame for one imageView
        let countInOneLine  = ceil(sqrt(CGFloat(imageCount)));              // 1 = 1, 2,3,4 = 2, 5,6,7,8,9 = 3
        let lineCount       = ceil(CGFloat(imageCount) / countInOneLine);   // 1,2 = 1, 3,4,5,6 = 2, 7,8,9 = 3
        let sideLength      = floor((self.frame.size.width-IMAGE_SPACING)/countInOneLine);
        let sizeOfOneImage  = CGSizeMake(sideLength, sideLength);
        
        for i in 0 ... (imageCount-1) {
            let viewTag = TAG_BASE + i;
            let rect = CGRectMake(sideLength*(CGFloat(i)%countInOneLine), sideLength*(CGFloat(i)/countInOneLine), sideLength, sideLength);
            let imageView = UIImageView(frame: rect);
//            imageView.image = UIImage(data: 
            SGImageCache
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
