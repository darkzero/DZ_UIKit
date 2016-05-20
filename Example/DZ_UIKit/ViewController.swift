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
        
        return cell!;
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0: // DZActionSheet
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
            let alert = DZAlertView.alertViewWithTitle("DZ_UIKit", Message: "DZAlertView");
            alert.setCancelButtonWithTitle("Cancel", CancelBlock: { 
                //
            });
            alert.addButtonWithTitle("Button 01", Handler: { 
                //
            });
            alert.show();
            break;
        case 2:
            let alert = DZAlertView.alertViewWithTitle("DZ_UIKit", Message: "DZAlertView");
            alert.cancelButtonColor = UIColor.redColor();
            alert.normalButtonColor = RGB_HEX("0099FF", 1.0);
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
        case 5:
            // Switch
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
}

