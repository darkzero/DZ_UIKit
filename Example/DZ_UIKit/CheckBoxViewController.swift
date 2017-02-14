//
//  CheckBoxViewController.swift
//  DZ_UIKit
//
//  Created by 胡 昱化 on 17/1/30.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import DZ_UIKit

class CheckBoxViewController: UIViewController {
    
    @IBOutlet var checkBox1: DZCheckBox!;
    @IBOutlet var checkBox2: DZCheckBox!;
    @IBOutlet var checkBox3: DZCheckBox!;
    @IBOutlet var checkBox4: DZCheckBox!;
    @IBOutlet var checkBox5: DZCheckBox!;
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        let checkboxGroupA = DZCheckBoxGroup();
        checkboxGroupA.addCheckBox(checkBox1);
        checkboxGroupA.addCheckBox(checkBox2);
        checkboxGroupA.addCheckBox(checkBox3);
        checkboxGroupA.addCheckBox(checkBox4);
        checkboxGroupA.addCheckBox(checkBox5);
        checkboxGroupA.multipleCheckEnabled = false;
        
        let checkboxGroup = DZCheckBoxGroup(frame: CGRect(x: 10, y: 200, width: 240, height: 48));
        checkboxGroup.backgroundColor = UIColor.red;
        checkboxGroup.multipleCheckEnabled = false;
        checkboxGroup.addCheckBox(
            DZCheckBox(frame: CGRect(x: 0, y: 0, width: 48, height: 48),
                       type: DZCheckBoxType.square));
        checkboxGroup.addCheckBox(
            DZCheckBox(frame: CGRect(x: 0, y: 0, width: 48, height: 48),
                       type: DZCheckBoxType.square,
                       borderColor: UIColor.white));
        checkboxGroup.addCheckBox(
            DZCheckBox(frame: CGRect(x: 0, y: 0, width: 48, height: 48),
                       type: DZCheckBoxType.rounded));
        checkboxGroup.addCheckBox(
            DZCheckBox(frame: CGRect(x: 0, y: 0, width: 48, height: 48),
                       type: DZCheckBoxType.rounded,
                       borderColor: UIColor.orange));
        checkboxGroup.addCheckBox(
            DZCheckBox(frame: CGRect(x: 0, y: 0, width: 48, height: 48),
                       type: DZCheckBoxType.circular));
        checkboxGroup.addCheckBox(
            DZCheckBox(frame: CGRect(x: 0, y: 0, width: 48, height: 48),
                       type: DZCheckBoxType.circular,
                       borderColor: UIColor.orange,
                       checkedColor: RGB_HEX("9988333", 1.0)));
        self.view.addSubview(checkboxGroup);
//        
//        let checkBoxList = DZCheckBoxGroup(frame: CGRect(x: 10, y: 280, width: 240, height: 240));
//        checkBoxList.style = .list;
//        checkBoxList.addCheckBox(
//            DZCheckBox(frame: CGRect(x: 0, y: 0, width: 32, height: 32),
//                       type: DZCheckBoxType.rounded, title: "Save Account", checkedColor: UIColor.orange));
//        checkBoxList.addCheckBox(
//            DZCheckBox(frame: CGRect(x: 0, y: 0, width: 32, height: 32),
//                       type: DZCheckBoxType.rounded, title: "Auto Login", borderColor: UIColor.orange));
//        checkBoxList.checkedIndexes = [0];
//        checkBoxList.multipleCheckEnabled = true;
//        self.view.addSubview(checkBoxList);
    }
}
