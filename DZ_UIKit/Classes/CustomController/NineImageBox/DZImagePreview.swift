//
//  DZImagePreview.swift
//  Pods
//
//  Created by darkzero on 16/11/28.
//
//

import Foundation

public class DZImagePreviewController: UIViewController {
    
    fileprivate let imagePreview: DZImagePreview?;
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(images: [String]) {
        
        self.imagePreview = DZImagePreview(frame: CGRect.zero);
        super.init(nibName: nil, bundle: nil);
    }
    
    public func show() {
    
    }
    
    public func dismiss() {
    
    }
    
}

private class DZImagePreview: UIView {
    
// MARK: - layoutSubviews
    fileprivate override func layoutSubviews() {
        //
    }
}
