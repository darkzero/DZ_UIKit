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
            let progress1 = DZAnnularProgress(Frame: CGRect(x: 10, y: 10, width: 100, height: 100), AnnularWidth: 8, Type: AnnularProgressType.progress);
            progress1.tag = 101;
            progress1.annularBackColor = UIColor.lightGray;
            progress1.annularFrontColor = UIColor.orange;
            progress1.maxValue = 200;
            progress1.currectValue = 49;
            let progress1Ctrl1 = UISlider.init(frame: CGRect(x: 130, y: 50, width: 150, height: 10));
            progress1Ctrl1.maximumValue = 200;
            progress1Ctrl1.minimumValue = 1;
            progress1Ctrl1.tag = 102;
            progress1Ctrl1.addTarget(self, action: #selector(DetailViewController.onProgressCtrlValueChanged(_:)), for: UIControlEvents.valueChanged);
            
            let progress2 = DZAnnularProgress(Frame: CGRect(x: 10, y: 160, width: 100, height: 100), AnnularWidth: 8, Type: AnnularProgressType.percent);
            progress2.tag = 103;
            progress2.annularBackColor = UIColor.lightGray;
            progress2.annularFrontColor = UIColor.orange;
            progress2.maxValue = 200;
            progress2.currectValue = 29;
            let progress1Ctrl2 = UISlider.init(frame: CGRect(x: 130, y: 200, width: 150, height: 10));
            progress1Ctrl2.maximumValue = 200;
            progress1Ctrl2.minimumValue = 1;
            progress1Ctrl2.tag = 104;
            progress1Ctrl2.addTarget(self, action: #selector(DetailViewController.onProgressCtrlValueChanged(_:)), for: UIControlEvents.valueChanged);
            
            self.mainView.addSubview(progress1);
            self.mainView.addSubview(progress1Ctrl1);
            self.mainView.addSubview(progress2);
            self.mainView.addSubview(progress1Ctrl2);
            break;
        case "DZNineImageBoxView":
            let imageArray = ["http://place-hold.it/200x200", "http://www.featurepics.com/FI/Thumb300/20091231/Red-Fire-Hydrant-1421559.jpg",
                              "http://place-hold.it/200x200", "http://place-hold.it/200x200",
                              "http://place-hold.it/200x200", "http://place-hold.it/200x200",];
            let nineImgView = DZNineImageBoxView.nineImageBoxViewWithImages(imageArray, frame: CGRect(x: 10,y: 10,width: 200,height: 200));
            nineImgView.delegate = self;
            self.mainView.addSubview(nineImgView);
            break;
        case "DZCheckBoxGroup":
            let checkboxGroup = DZCheckBoxGroup.checkBoxgroupWithFrame(CGRect(x: 10, y: 100, width: 240, height: 48));
            checkboxGroup.backgroundColor = UIColor.red;
            //checkboxGroup.multipleCheckEnabled = true;
            checkboxGroup.addCheckBox(
                DZCheckBox.checkBoxWithFrame(CGRect(x: 0, y: 0, width: 48, height: 48),
                    Type: DZCheckBoxType.square));
            checkboxGroup.addCheckBox(
                DZCheckBox.checkBoxWithFrame(CGRect(x: 0, y: 0, width: 48, height: 48),
                    Type: DZCheckBoxType.square,
                    BorderColorOrNil: UIColor.orange));
            checkboxGroup.addCheckBox(
                DZCheckBox.checkBoxWithFrame(CGRect(x: 0, y: 0, width: 48, height: 48),
                    Type: DZCheckBoxType.rounded));
            checkboxGroup.addCheckBox(
                DZCheckBox.checkBoxWithFrame(CGRect(x: 0, y: 0, width: 48, height: 48),
                    Type: DZCheckBoxType.rounded,
                    BorderColorOrNil: UIColor.orange));
            checkboxGroup.addCheckBox(
                DZCheckBox.checkBoxWithFrame(CGRect(x: 0, y: 0, width: 48, height: 48),
                    Type: DZCheckBoxType.circular));
            checkboxGroup.addCheckBox(
                DZCheckBox.checkBoxWithFrame(CGRect(x: 0, y: 0, width: 48, height: 48),
                    Type: DZCheckBoxType.circular,
                    BorderColorOrNil: UIColor.orange,
                    CheckedColorOrNil: RGB_HEX("9988333", 1.0)));
            self.view.addSubview(checkboxGroup);
            
            let checkBoxList = DZCheckBoxGroup.checkBoxgroupWithFrame(CGRect(x: 10, y: 180, width: 240, height: 240));
            checkBoxList.style = .list;
            checkBoxList.addCheckBox(
                DZCheckBox.checkBoxWithFrame(CGRect(x: 0, y: 0, width: 32, height: 32),
                    Type: DZCheckBoxType.rounded, Title: "Save Account", CheckedColorOrNil: UIColor.orange));
            checkBoxList.addCheckBox(
                DZCheckBox.checkBoxWithFrame(CGRect(x: 0, y: 0, width: 32, height: 32),
                    Type: DZCheckBoxType.rounded, Title: "Auto Login", BorderColorOrNil: UIColor.orange));
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
    
    func onProgressCtrlValueChanged(_ sender: AnyObject) {
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
    func nineImageView(_ aButtonMenu: DZNineImageBoxView, tapImageAtIndex index: Int) {
        print("on tap image : ", index);
    }

}
