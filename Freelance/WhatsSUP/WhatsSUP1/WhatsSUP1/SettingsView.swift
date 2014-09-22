//
//  MenuController.swift
//  WhatsSUP1
//
//  Created by Tim Teece on 09/07/2014.
//  Copyright (c) 2014 Tim Teece. All rights reserved.
//

import Foundation
import UIKit

class SettingsView: UITableViewController, UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate{
    
    //@IBOutlet
    //var tableView: UITableView
    var items: [String] = [ "Magnetic North","Units","Start Delay", "Auto Share Routes", "Use Cloud Storage","Reset Cloud"]
    var pathId: NSManagedObjectID?
    
    override
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0;
        count = items.count
        return count;
        
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        if var appset=del.getAppSettings(){
            if(indexPath.row==0){
                var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Compass") as UITableViewCell
                var celldata : String = items[indexPath.row]
                cell.textLabel!.text = celldata
                var seg:UISegmentedControl =  cell.viewWithTag(200) as UISegmentedControl
                switch appset.usemagneticnorth.integerValue{
                case 0:
                    seg.selectedSegmentIndex=1
                case 1:
                    seg.selectedSegmentIndex=0
                default:
                    seg.selectedSegmentIndex=0
                }
                return cell
            }else if (indexPath.row==1){
                var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Units") as UITableViewCell
                var celldata : String = items[indexPath.row]
                cell.textLabel!.text = celldata
                var seg:UISegmentedControl =  cell.viewWithTag(300) as UISegmentedControl
                switch appset.usemiles.integerValue{
                case 0:
                    seg.selectedSegmentIndex=1
                case 1:
                    seg.selectedSegmentIndex=0
                case 2:
                    seg.selectedSegmentIndex=2
                default:
                    seg.selectedSegmentIndex=0
                }

                return cell
            }else if indexPath.row==2{
                var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("CountDown") as UITableViewCell
                var celldata : String = items[indexPath.row]
                cell.textLabel!.text = celldata
                var seg:UISegmentedControl =  cell.viewWithTag(100) as UISegmentedControl
                switch appset.startdelay.integerValue{
                case 0:
                    seg.selectedSegmentIndex=0
                case 5:
                    seg.selectedSegmentIndex=1
                case 10:
                    seg.selectedSegmentIndex=2
                case 20:
                    seg.selectedSegmentIndex=3
                default:
                    seg.selectedSegmentIndex=0
                }
                return cell
            }else if indexPath.row==5{
                var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("DataReset") as UITableViewCell
                var celldata : String = items[indexPath.row]
                cell.textLabel!.text = celldata
                return cell
            }else{
                var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Toggle") as UITableViewCell
                var celldata : String = items[indexPath.row]
                cell.textLabel!.text = celldata
                var seg:UISegmentedControl =  cell.viewWithTag(400) as UISegmentedControl
                
                switch indexPath.row{
                case 3:
                    switch appset.autoPostToCloud{
                    case 0:
                        seg.selectedSegmentIndex=1
                    default:
                        seg.selectedSegmentIndex=0
                    }
                    seg.tag=401
                default:
                    switch appset.useCloudStorage{
                    case 0:
                        seg.selectedSegmentIndex=1
                    default:
                        seg.selectedSegmentIndex=0
                    }
                    seg.tag=402
                }
                
                return cell
                
            }
        }else{
            var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("CountDown") as UITableViewCell
            return cell

        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var object:String = items[Int(indexPath.item)]
        
       /* println("You selected cell #\(object)")
        
        switch (object){
        case "Activity":
            performSegueWithIdentifier("ShowActivityHistory", sender: self)
        case "Routes around here":
            performSegueWithIdentifier("ShowLocalRoutes", sender: self)
        case "What is SUP":
            performSegueWithIdentifier("ShowWhatIsSup", sender: self)
        case "Technique":
            performSegueWithIdentifier("ShowTechnique", sender: self)
        case "Boards":
            performSegueWithIdentifier("ShowBoards", sender: self)
        case "Fins":
            performSegueWithIdentifier("ShowFins", sender: self)
        case "Settings":
            performSegueWithIdentifier("ShowSettings", sender: self)
            
        default:
            NSLog ("switch not supported")
        }*/
        
    }
    
    
    override func viewDidLoad() {
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        let currentPath=del.locationManager.currentPath
        
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
    }
    
    @IBAction func deleteData(sender:UIButton){
        // delete all data - you must warn people...
        var uiAV = UIAlertView(title: "DELETE ALL DATA!!", message: "You are about to clean out all your data stored in the cloud, this cannot be undone. Are you sure?", delegate: self, cancelButtonTitle: "YES", otherButtonTitles: "NO")
        uiAV.show()
    }
    
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        // should we use local or cloud data storage
        if buttonIndex==0{
            let del = UIApplication.sharedApplication().delegate as AppDelegate
            // delete the database
            del.deleteCloudData()
        }
    }

    @IBAction func toggleEvent(sender:UISegmentedControl){
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        if var appset=del.getAppSettings(){
            
            switch (sender.tag){
            case 401:
                switch(sender.selectedSegmentIndex){
                case 0:
                    appset.autoPostToCloud=1;
                default:
                    appset.autoPostToCloud=0;
                }
            default: //402
                switch(sender.selectedSegmentIndex){
                case 0:
                    appset.useCloudStorage=1;
                default:
                    appset.useCloudStorage=0;
                }
            }
            var error: NSError? = nil
            del.managedObjectContext!.save(&error)
        }
    }

    
    @IBAction func setStartDelay(sender:UISegmentedControl){
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        if var appset=del.getAppSettings(){
            switch(sender.selectedSegmentIndex){
            case 0:
                appset.startdelay=0;
            case 1:
                appset.startdelay=5;
            case 2:
                appset.startdelay=10;
            case 3:
                appset.startdelay=20;
            default:
                appset.startdelay=5;
            }
            var error: NSError? = nil
            del.managedObjectContext!.save(&error)
        }
    }

    
    @IBAction func setMagNorth(sender:UISegmentedControl){
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        if var appset=del.getAppSettings(){
            switch(sender.selectedSegmentIndex){
            case 0:
                appset.usemagneticnorth=1;
            case 1:
                appset.usemagneticnorth=0;
            default:
                appset.usemagneticnorth=0;
            }
            var error: NSError? = nil
            del.managedObjectContext!.save(&error)
        }
        
    }
    @IBAction func setUnits(sender:UISegmentedControl){
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        if var appset=del.getAppSettings(){
            switch(sender.selectedSegmentIndex){
            case 0:
                appset.usemiles=1;
            case 1:
                appset.usemiles=0;
            case 2:
                appset.usemiles=2;
            default:
                appset.usemiles=0;
            }
            var error: NSError? = nil
            del.managedObjectContext!.save(&error)
        }
    }

    
}

