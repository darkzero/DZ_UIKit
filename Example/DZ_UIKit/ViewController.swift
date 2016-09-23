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
            // DZActionSheet
            let actionSheet = DZActionSheet.actionSheetWithTitle("DZ_UIKit DZActionSheet");
            actionSheet.addButtonWithTitle("Action", CharacterColor: UIColor.red, Handler: {
                //;
            });
            actionSheet.addButtonWithTitle("Block", CharacterColor: UIColor.green, Handler: {
                //;
            });
            actionSheet.addButtonWithTitle("Continue", CharacterColor: UIColor.cyan, Handler: {
                //;
            });
            actionSheet.addButtonWithTitle("Delete", CharacterColor: UIColor.orange, Handler: {
                //;
            });
            actionSheet.addButtonWithTitle("Edit", CharacterColor: UIColor.brown, Handler: {
                //;
            });
            actionSheet.addButtonWithTitle("FaceToFace", CharacterColor: UIColor.red, Handler: {
                //;
            });
            actionSheet.addButtonWithTitle("Game", CharacterColor: UIColor.green, Handler: {
                //;
            });
            actionSheet.addButtonWithTitle("Hit&Run", CharacterColor: UIColor.cyan, Handler: {
                //;
            });
            actionSheet.addButtonWithTitle("Increasement", CharacterColor: UIColor.orange, Handler: {
                //;
            });
            actionSheet.addButtonWithTitle("JoinUs", CharacterColor: UIColor.white, Handler: {
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
            alert.setCancelButtonWithTitle("Cancel", bgColor:UIColor.red, handler: {
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
            self.performSegue(withIdentifier: "ShowDetail", sender: "DZAnnularProgress");
            break;
        case 4:
            // DZNineImageBoxView
            self.performSegue(withIdentifier: "ShowDetail", sender: "DZNineImageBoxView");
            break;
        case 5:
            // DZCheckBoxGroup
            self.performSegue(withIdentifier: "ShowDetail", sender: "DZCheckBoxGroup");
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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

