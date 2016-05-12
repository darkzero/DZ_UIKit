//
//  DetailViewController.swift
//  DZ_UIKit
//
//  Created by 胡 昱化 on 16/5/12.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import DZ_UIKit

class DetailViewController: UIViewController {
    
    var viewTitle: String = "None";

    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch viewTitle {
        case "DZAnnularProgress":
            let progress1 = DZAnnularProgress(Frame: CGRectMake(10, 10, 100, 100), AnnularWidth: 4, Type: AnnularProgressType.Progress);
            progress1.tag = 101;
            progress1.annularBackColor = UIColor.lightGrayColor();
            progress1.annularFrontColor = UIColor.orangeColor();
            let progress1Ctrl = UISlider.init(frame: CGRectMake(10, 150, 200, 10));
            progress1Ctrl.tag = 102;
            progress1Ctrl.addTarget(self, action: #selector(DetailViewController.onProgressCtrlValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged);
            let progress2 = DZAnnularProgress(Frame: CGRectMake(10, 210, 100, 100), AnnularWidth: 4, Type: AnnularProgressType.Percent);
            self.view.addSubview(progress1);
            self.view.addSubview(progress1Ctrl);
            self.view.addSubview(progress2);
            break;
        default:
            break;
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func onProgressCtrlValueChanged(sender: AnyObject) {
        if ( sender.tag == 102 ) {
            let progress = self.view.viewWithTag(101) as! DZAnnularProgress;
            progress.currectValue = sender.currectValue;
        }
    }

}
