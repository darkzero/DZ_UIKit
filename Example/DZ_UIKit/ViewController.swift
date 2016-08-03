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
        
        cell?.textLabel?.text = self.controllerList![indexPath.row]["Name"] as? String;
        
        if indexPath.row == 6 {
            let stepper = DZStepper(frame: CGRectMake(0,0,140,32));
            stepper.maxValue = 100;
            stepper.mainColor = UIColor.purpleColor().colorWithAlphaComponent(0.7);
            stepper.textColor = UIColor.purpleColor().colorWithAlphaComponent(0.7);
            stepper.addTarget(self, action: #selector(ViewController.onStepperChanged(_:)), forControlEvents: .ValueChanged);
            cell?.accessoryView = stepper;
        }
        
        if indexPath.row == 7 {
            // DZSwitch
            let aSwitch = DZSwitch(frame: CGRectMake(0,0, 55, 32));
            cell?.accessoryView = aSwitch;
        }
        
        return cell!;
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false);
        switch indexPath.row {
        case 0:
            // DZActionSheet
            let actionSheet = DZActionSheet.actionSheetWithTitle("DZ_UIKit DZActionSheet");
            actionSheet.addButtonWithTitle("Action", CharacterColor: UIColor.redColor(), Handler: {
                //;
            });
            actionSheet.addButtonWithTitle("Block", CharacterColor: UIColor.greenColor(), Handler: {
                //;
            });
            actionSheet.addButtonWithTitle("Continue", CharacterColor: UIColor.cyanColor(), Handler: {
                //;
            });
            actionSheet.addButtonWithTitle("Delete", CharacterColor: UIColor.orangeColor(), Handler: {
                //;
            });
            actionSheet.addButtonWithTitle("Edit", CharacterColor: UIColor.brownColor(), Handler: {
                //;
            });
            actionSheet.addButtonWithTitle("FaceToFace", CharacterColor: UIColor.redColor(), Handler: {
                //;
            });
            actionSheet.addButtonWithTitle("Game", CharacterColor: UIColor.greenColor(), Handler: {
                //;
            });
            actionSheet.addButtonWithTitle("Hit&Run", CharacterColor: UIColor.cyanColor(), Handler: {
                //;
            });
            actionSheet.addButtonWithTitle("Increasement", CharacterColor: UIColor.orangeColor(), Handler: {
                //;
            });
            actionSheet.addButtonWithTitle("JoinUs", CharacterColor: UIColor.whiteColor(), Handler: {
                //;
            });
            actionSheet.show();
            break;
        case 1:
            // DZAlertView 2 button
            let alert = DZAlertView.alertViewWithTitle("DZ_UIKit", Message: "DZAlertView");
            alert.setCancelButtonWithTitle("Cancel", handler: {
                //
                print("Cancel button is clicked");
            });
            alert.addButtonWithTitle("Button 01", handler: {
                //
                print("Button 01 is clicked");
            });
            alert.show();
            break;
        case 2:
            // DZAlertView 3 button
            let alert = DZAlertView.alertViewWithTitle("DZ_UIKit", Message: "DZAlertView DZAlertView DZAlertView DZAlertView DZAlertView DZAlertView");
            alert.setCancelButtonWithTitle("Cancel", bgColor:UIColor.redColor(), handler: {
                //
                print("Cancel button is clicked");
            });
            alert.addButtonWithTitle("Button 01", bgColor:RGB_HEX("0099FF", 1.0),  handler: {
                //
                print("Button 01 is clicked");
            });
            alert.addButtonWithTitle("Button 02", handler: {
                //
                print("Button 02 is clicked");
            });
            alert.show();
            break;
        case 3:
            // DZAnnularProgress
            self.performSegueWithIdentifier("ShowDetail", sender: "DZAnnularProgress");
            break;
        case 4:
            // DZNineImageBoxView
            self.performSegueWithIdentifier("ShowDetail", sender: "DZNineImageBoxView");
            break;
        case 5:
            // DZCheckBoxGroup
            self.performSegueWithIdentifier("ShowDetail", sender: "DZCheckBoxGroup");
            break;
        case 6:
            // DZStepper
            break;
        case 7:
            // DZSwitch
            break;
        default:
            break;
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let viewController = segue.destinationViewController as! DetailViewController;
        viewController.viewTitle = sender as! String;
        if segue.identifier == "ShowDetail" {
            switch sender as! String {
            case "DZAnnularProgress":
                //
                break;
            default:
                //
                break;
            }
        }
    }
    
    func onStepperChanged(sender: DZStepper) {
        //print("onStepperChanged ", sender.currentValue);
    }
}

