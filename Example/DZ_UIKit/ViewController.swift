//
//  ViewController.swift
//  DZ_UIKit
//
//  Created by darkzero on 05/09/2016.
//  Copyright (c) 2016 darkzero. All rights reserved.
//

import UIKit
import DZ_UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var listTableView: UITableView!;
    
//    lazy var controllerList: NSArray? = {
//        let path = NSBundle.mainBundle().pathForResource("Controllers", ofType:"plist")
//        let list = NSArray(contentsOfFile: path);
//        return list;
//    }();
    var controllerList: NSArray?;

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        listTableView.dataSource = self;
        listTableView.delegate = self;
        
        let path = NSBundle.mainBundle().pathForResource("Controllers", ofType:"plist")
        self.controllerList = NSArray(contentsOfFile: path!);

        listTableView.reloadData();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.controllerList!.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("controllerListTableCell");
        
        cell?.textLabel?.text = self.controllerList![indexPath.row]["Name"] as! String;
        
        return cell!;
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0: // DZActionSheet
            let actionSheet = DZActionSheet.actionSheetWithTitle("DZ_UIKit DZActionSheet");
            actionSheet.addButtonWithTitle("Action", characterColor: UIColor.redColor(), Handler: {
                //;
            });
            actionSheet.addButtonWithTitle("Block", characterColor: UIColor.greenColor(), Handler: {
                //;
            });
            actionSheet.addButtonWithTitle("Continue", characterColor: UIColor.cyanColor(), Handler: {
                //;
            });
            actionSheet.addButtonWithTitle("Delete", characterColor: UIColor.orangeColor(), Handler: {
                //;
            });
            actionSheet.addButtonWithTitle("Edit", characterColor: UIColor.brownColor(), Handler: {
                //;
            });
            actionSheet.addButtonWithTitle("FaceToFace", characterColor: UIColor.redColor(), Handler: {
                //;
            });
            actionSheet.addButtonWithTitle("Game", characterColor: UIColor.greenColor(), Handler: {
                //;
            });
            actionSheet.addButtonWithTitle("Hit&Run", characterColor: UIColor.cyanColor(), Handler: {
                //;
            });
            actionSheet.addButtonWithTitle("Increase", characterColor: UIColor.orangeColor(), Handler: {
                //;
            });
            actionSheet.addButtonWithTitle("JoinUs", characterColor: UIColor.whiteColor(), Handler: {
                //;
            });
            actionSheet.show();
            break;
        case 1:
            let alert = DZAlertView.alertViewWithTitle("DZ_UIKit", Message: "DZAlertView");
            alert.setCancelButtonWithTitle("Cancel", CancelBlock: { 
                //
            });
            alert.addButtonWithTitle("Button 01", Handler: { 
                //
            });
            alert.addButtonWithTitle("Button 02", Handler: {
                //
            });
            alert.show();
            break;
        default:
            break;
        }
    }
}

