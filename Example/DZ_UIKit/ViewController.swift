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
    
    var controllerList: NSArray?;

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        listTableView.dataSource = self;
        listTableView.delegate = self;
        
        let path = Bundle.main.path(forResource: "Controllers", ofType:"plist")
        self.controllerList = NSArray(contentsOfFile: path!);

        listTableView.reloadData();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.controllerList!.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "controllerListTableCell");
        
        cell?.textLabel?.text = (self.controllerList![(indexPath as NSIndexPath).row] as! [String: Any])["Name"] as? String;
        
        if (indexPath as NSIndexPath).row == 6 {
            let stepper = DZStepper(frame: CGRect(x: 0,y: 0,width: 140,height: 32));
            stepper.maxValue = 100;
            stepper.mainColor = UIColor.purple.withAlphaComponent(0.7);
            stepper.textColor = UIColor.purple.withAlphaComponent(0.7);
            stepper.addTarget(self, action: #selector(ViewController.onStepperChanged(_:)), for: .valueChanged);
            cell?.accessoryView = stepper;
        }
        
        if (indexPath as NSIndexPath).row == 7 {
            // DZSwitch
            let aSwitch = DZSwitch(frame: CGRect(x: 0,y: 0, width: 55, height: 32));
            cell?.accessoryView = aSwitch;
        }
        
        return cell!;
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false);
        switch (indexPath as NSIndexPath).row {
        case 0:
            let actionSheetController = DZActionSheetController(title: "- ActionSheet Test -");
            actionSheetController.addButton(withTitle: "Action", characterColor: UIColor.red, handler: nil);
            actionSheetController.addButton(withTitle: "Block", characterColor: UIColor.green, handler: nil);
            actionSheetController.addButton(withTitle: "Continue", characterColor: UIColor.cyan, handler: nil);
            actionSheetController.addButton(withTitle: "Delete", characterColor: UIColor.orange, handler: nil);
            actionSheetController.addButton(withTitle: "Edit", characterColor: UIColor.brown, handler: nil);
            actionSheetController.addButton(withTitle: "FaceToFace", characterColor: UIColor.red, handler: nil);
            actionSheetController.addButton(withTitle: "Game", characterColor: UIColor.green, handler: nil);
            actionSheetController.addButton(withTitle: "Hit&Run", characterColor: UIColor.cyan, handler: nil);
            actionSheetController.addButton(withTitle: "Increasement", characterColor: UIColor.orange, handler: nil);
            actionSheetController.addButton(withTitle: "JoinUs", characterColor: UIColor.white, handler: nil);
            
            //actionSheetController.addButton(withTitle: "Increasement", characterColor: UIColor.orange, handler: nil);
            //actionSheetController.addButton(withTitle: "JoinUs", characterColor: UIColor.white, handler: nil);
            //actionSheetController.addButton(withTitle: "Increasement", characterColor: UIColor.orange, handler: nil);
            //actionSheetController.addButton(withTitle: "JoinUs", characterColor: UIColor.white, handler: nil);
            
            actionSheetController.show(inViewController: self, animated: true);
            break;
        case 1:
            // DZAlertView 2 button
            let alert = DZAlertViewController(title: "DZ_UIKit");
            alert.setCancelButton(title: "Cancel", handler: {
                //
                print("Cancel button is clicked");
            });
            alert.addButton(title: "Button 01", handler: {
                //
                print("Button 01 is clicked");
            });
            alert.show(inViewController: self);
            break;
        case 2:
            // DZAlertView 3 button
            let alert = DZAlertViewController(title: "DZ_UIKit", message: "DZAlertView DZAlertView DZAlertView DZAlertView DZAlertView DZAlertView");
            alert.setCancelButton(title: "Cancel", bgColor:UIColor.red, handler: {
                //
                print("Cancel button is clicked");
            });
            alert.addButton(title: "Button 01", bgColor:RGB_HEX("0099FF", 1.0),  handler: {
                //
                print("Button 01 is clicked");
            });
            alert.addButton(title: "Button 02");
            alert.show(inViewController: self);
            break;
        case 3:
            // DZAnnularProgress
            self.performSegue(withIdentifier: "ShowDetail", sender: "DZAnnularProgress");
            break;
        case 4:
            // DZNineImageBoxView
            self.performSegue(withIdentifier: "ShowDetail", sender: "DZNineImageBoxView");
            break;
        case 5:
            // DZCheckBoxGroup
            self.performSegue(withIdentifier: "ShowCheckBox", sender: "DZCheckBoxGroup");
            break;
        case 6:
            // DZStepper
            break;
        case 7:
            // DZSwitch
            break;
        case 8:
            // DZButtonMenu
            self.performSegue(withIdentifier: "ShowDetail", sender: "DZButtonMenu");
            break;
        default:
            break;
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if ( segue.identifier == "ShowCheckBox" ) {
            return;
        }
        let viewController = segue.destination as! DetailViewController;
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
    
    func onStepperChanged(_ sender: DZStepper) {
        //print("onStepperChanged ", sender.currentValue);
    }
}

