//
//  DetailViewController.swift
//  DZ_UIKit
//
//  Created by darkzero on 16/5/12.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import DZ_UIKit

class DetailViewController: UIViewController, DZNineImageBoxViewDelegate {
    
    @IBOutlet var mainView: UIView!;
    
    var viewTitle: String = "None";

    override func viewDidLoad() {
        //super.viewDidLoad()
        
        switch viewTitle {
        case "DZAnnularProgress":
            let progress1 = DZAnnularProgress(Frame: CGRectMake(10, 10, 100, 100), AnnularWidth: 8, Type: AnnularProgressType.Progress);
            progress1.tag = 101;
            progress1.annularBackColor = UIColor.lightGrayColor();
            progress1.annularFrontColor = UIColor.orangeColor();
            progress1.maxValue = 200;
            progress1.currectValue = 49;
            let progress1Ctrl1 = UISlider.init(frame: CGRectMake(130, 50, 150, 10));
            progress1Ctrl1.maximumValue = 200;
            progress1Ctrl1.minimumValue = 1;
            progress1Ctrl1.tag = 102;
            progress1Ctrl1.addTarget(self, action: #selector(DetailViewController.onProgressCtrlValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged);
            
            let progress2 = DZAnnularProgress(Frame: CGRectMake(10, 160, 100, 100), AnnularWidth: 8, Type: AnnularProgressType.Percent);
            progress2.tag = 103;
            progress2.annularBackColor = UIColor.lightGrayColor();
            progress2.annularFrontColor = UIColor.orangeColor();
            progress2.maxValue = 200;
            progress2.currectValue = 29;
            let progress1Ctrl2 = UISlider.init(frame: CGRectMake(130, 200, 150, 10));
            progress1Ctrl2.maximumValue = 200;
            progress1Ctrl2.minimumValue = 1;
            progress1Ctrl2.tag = 104;
            progress1Ctrl2.addTarget(self, action: #selector(DetailViewController.onProgressCtrlValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged);
            
            self.mainView.addSubview(progress1);
            self.mainView.addSubview(progress1Ctrl1);
            self.mainView.addSubview(progress2);
            self.mainView.addSubview(progress1Ctrl2);
            break;
        case "DZNineImageBoxView":
            let imageArray = ["http://place-hold.it/200x200", "http://www.featurepics.com/FI/Thumb300/20091231/Red-Fire-Hydrant-1421559.jpg",
                              "http://place-hold.it/200x200", "http://place-hold.it/200x200",
                              "http://place-hold.it/200x200", "http://place-hold.it/200x200",];
            let nineImgView = DZNineImageBoxView.nineImageBoxViewWithImages(imageArray, frame: CGRectMake(10,10,200,200));
            nineImgView.delegate = self;
            self.mainView.addSubview(nineImgView);
            break;
        case "DZCheckBoxGroup":
            let checkboxGroup = DZCheckBoxGroup.checkBoxgroupWithFrame(CGRectMake(10, 100, 240, 48));
            checkboxGroup.backgroundColor = UIColor.redColor();
            //checkboxGroup.multipleCheckEnabled = true;
            checkboxGroup.addCheckBox(
                DZCheckBox.checkBoxWithFrame(CGRectMake(0, 0, 48, 48),
                    Type: DZCheckBoxType.Square));
            checkboxGroup.addCheckBox(
                DZCheckBox.checkBoxWithFrame(CGRectMake(0, 0, 48, 48),
                    Type: DZCheckBoxType.Square,
                    BorderColorOrNil: UIColor.orangeColor()));
            checkboxGroup.addCheckBox(
                DZCheckBox.checkBoxWithFrame(CGRectMake(0, 0, 48, 48),
                    Type: DZCheckBoxType.Rounded));
            checkboxGroup.addCheckBox(
                DZCheckBox.checkBoxWithFrame(CGRectMake(0, 0, 48, 48),
                    Type: DZCheckBoxType.Rounded,
                    BorderColorOrNil: UIColor.orangeColor()));
            checkboxGroup.addCheckBox(
                DZCheckBox.checkBoxWithFrame(CGRectMake(0, 0, 48, 48),
                    Type: DZCheckBoxType.Circular));
            checkboxGroup.addCheckBox(
                DZCheckBox.checkBoxWithFrame(CGRectMake(0, 0, 48, 48),
                    Type: DZCheckBoxType.Circular,
                    BorderColorOrNil: UIColor.orangeColor(),
                    CheckedColorOrNil: RGB_HEX("9988333", 1.0)));
            self.view.addSubview(checkboxGroup);
            
            let checkBoxList = DZCheckBoxGroup.checkBoxgroupWithFrame(CGRectMake(10, 180, 240, 240));
            checkBoxList.style = .List;
            checkBoxList.addCheckBox(
                DZCheckBox.checkBoxWithFrame(CGRectMake(0, 0, 32, 32),
                    Type: DZCheckBoxType.Rounded, CheckedColorOrNil: UIColor.orangeColor(), Title: "Save Account"));
            checkBoxList.addCheckBox(
                DZCheckBox.checkBoxWithFrame(CGRectMake(0, 0, 32, 32),
                    Type: DZCheckBoxType.Rounded, BorderColorOrNil: UIColor.orangeColor(), Title: "Auto Login"));
            checkBoxList.checkedIndexes = [0];
            checkBoxList.multipleCheckEnabled = true;
            self.view.addSubview(checkBoxList);
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
            //if ( (sender as! UISlider).value != nil ) {
            progress.currectValue = CGFloat(round((sender as! UISlider).value));
            //}
        }
        if ( sender.tag == 104 ) {
            let progress = self.view.viewWithTag(103) as! DZAnnularProgress;
            progress.currectValue = CGFloat(round((sender as! UISlider).value));
        }
    }
    
    //MARK: - DZNineImageBoxViewDelegate
    func nineImageView(aButtonMenu: DZNineImageBoxView, tapImageAtIndex index: Int) {
        print("on tap image : ", index);
    }

}
