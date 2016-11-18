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
            let progress1 = DZAnnularProgress(frame: CGRect(x: 10, y: 10, width: 100, height: 100), annularWidth: 8, type: .progress);
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
            
            let progress2 = DZAnnularProgress(frame: CGRect(x: 10, y: 160, width: 100, height: 100), annularWidth: 8, type: .percent);
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
            let nineImgView = DZNineImageBoxView.nineImageBoxView(withImages: imageArray, frame: CGRect(x: 10,y: 10,width: 200,height: 200));
            nineImgView.delegate = self;
            self.mainView.addSubview(nineImgView);
            break;
        case "DZCheckBoxGroup":
            let checkboxGroup = DZCheckBoxGroup.checkBoxgroup(withFrame: CGRect(x: 10, y: 100, width: 240, height: 48));
            checkboxGroup.backgroundColor = UIColor.red;
            //checkboxGroup.multipleCheckEnabled = true;
            checkboxGroup.multipleCheckEnabled = false;
            checkboxGroup.addCheckBox(
                DZCheckBox.checkBox(withFrame: CGRect(x: 0, y: 0, width: 48, height: 48),
                    type: DZCheckBoxType.square));
            checkboxGroup.addCheckBox(
                DZCheckBox.checkBox(withFrame: CGRect(x: 0, y: 0, width: 48, height: 48),
                    type: DZCheckBoxType.square,
                    borderColor: UIColor.orange));
            checkboxGroup.addCheckBox(
                DZCheckBox.checkBox(withFrame: CGRect(x: 0, y: 0, width: 48, height: 48),
                    type: DZCheckBoxType.rounded));
            checkboxGroup.addCheckBox(
                DZCheckBox.checkBox(withFrame: CGRect(x: 0, y: 0, width: 48, height: 48),
                    type: DZCheckBoxType.rounded,
                    borderColor: UIColor.orange));
            checkboxGroup.addCheckBox(
                DZCheckBox.checkBox(withFrame: CGRect(x: 0, y: 0, width: 48, height: 48),
                    type: DZCheckBoxType.circular));
            checkboxGroup.addCheckBox(
                DZCheckBox.checkBox(withFrame: CGRect(x: 0, y: 0, width: 48, height: 48),
                    type: DZCheckBoxType.circular,
                    borderColor: UIColor.orange,
                    checkedColor: RGB_HEX("9988333", 1.0)));
            self.view.addSubview(checkboxGroup);
            
            let checkBoxList = DZCheckBoxGroup.checkBoxgroup(withFrame: CGRect(x: 10, y: 180, width: 240, height: 240));
            checkBoxList.style = .list;
            checkBoxList.addCheckBox(
                DZCheckBox.checkBox(withFrame: CGRect(x: 0, y: 0, width: 32, height: 32),
                    type: DZCheckBoxType.rounded, title: "Save Account", checkedColor: UIColor.orange));
            checkBoxList.addCheckBox(
                DZCheckBox.checkBox(withFrame: CGRect(x: 0, y: 0, width: 32, height: 32),
                    type: DZCheckBoxType.rounded, title: "Auto Login", borderColor: UIColor.orange));
            checkBoxList.checkedIndexes = [0];
            checkBoxList.multipleCheckEnabled = true;
            self.view.addSubview(checkBoxList);
            break;
        case "DZButtonMenu" :
            let buttonMenuRB = DZButtonMenu(location: .rightBottom, direction: .up, closeImage: nil, openImage: nil, titleArray: ["Attack", "Defence", "Magic", "Run Away"], imageArray: nil);
            let buttonMenuLB = DZButtonMenu(location: .leftBottom, direction: .right, closeImage: nil, openImage: nil, titleArray: ["Attack", "Defence", "Magic", "Run Away"], imageArray: nil);
            let buttonMenuRT = DZButtonMenu(location: .rightTop, direction: .left, closeImage: nil, openImage: nil, titleArray: ["Attack", "Defence", "Magic", "Run Away"], imageArray: nil);
            let buttonMenuLT = DZButtonMenu(location: .leftTop, direction: .down, closeImage: nil, openImage: nil, titleArray: ["Attack", "Defence", "Magic", "Run Away"], imageArray: nil);
            self.view.addSubview(buttonMenuRB);
            self.view.addSubview(buttonMenuLB);
            self.view.addSubview(buttonMenuRT);
            self.view.addSubview(buttonMenuLT);
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
