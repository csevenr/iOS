//
//  MenuController.swift
//  WhatsSUP1
//
//  Created by Tim Teece on 09/07/2014.
//  Copyright (c) 2014 Tim Teece. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class MenuController: UITableViewController, UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate,LocationDelegate{
    
    //@IBOutlet
    //var tableView: UITableView
    var items: [String] = ["Activity", "How to use", "Routes around here","What is SUP","Terminology","Technique","Boards","Fins", "Rules of surfing","Settings"]
    var pathId: NSManagedObjectID?
    var doShowAll=1
    var myLoc:CLLocation?
    
    var webPageToShow:NSString="http://www.eiientertains.com/"
    
    // static webpages
    let WhatIsSupURL:NSString="http://www.eiientertains.com/whatsup/whatissup.html"
    let TechniqueURL:NSString="http://www.eiientertains.com/whatsup/technique.html"
    let BoardsURL:NSString="http://www.eiientertains.com/whatsup/boards.html"
    let FinsURL:NSString="http://www.eiientertains.com/whatsup/fins.html"
    let RulesOfSurfingURL:NSString="http://www.eiientertains.com/whatsup/rulesofsurfing.html"
    let HowToUseURL:NSString="http://www.eiientertains.com/whatsup/howtouse.html"
    let TerminologyURL:NSString="http://www.eiientertains.com/whatsup/terminology.html"

    override
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0;
        count = items.count
        return count;
        
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        var celldata : String = items[indexPath.row]
        cell.textLabel!.text = celldata
        cell.backgroundColor = UIColor(red: 171/255, green: 217/255, blue: 233/255, alpha: 10.0)

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var object:String = items[Int(indexPath.item)]
        
        println("You selected cell #\(object)")
        
        switch (object){
        
        case "Activity":
                doShowAll=1
                performSegueWithIdentifier("ShowActivityHistory", sender: self)
        
        case "Routes around here":
            doShowAll=2
            performSegueWithIdentifier("showRoutesRoundHere", sender: self)
            
        case "Settings":
            performSegueWithIdentifier("ShowSettings", sender: self)
            
        case "How to use":
            webPageToShow=HowToUseURL
            performSegueWithIdentifier("showWebView", sender: self)
        case "What is SUP":
            webPageToShow=WhatIsSupURL
            performSegueWithIdentifier("showWebView", sender: self)
        case "Technique":
            webPageToShow=TechniqueURL
            performSegueWithIdentifier("showWebView", sender: self)
        case "Boards":
            webPageToShow=BoardsURL
            performSegueWithIdentifier("showWebView", sender: self)
        case "Fins":
            webPageToShow=FinsURL
            performSegueWithIdentifier("showWebView", sender: self)
        case "Rules of surfing":
            webPageToShow=RulesOfSurfingURL
            performSegueWithIdentifier("showWebView", sender: self)
        case "Terminology":
            webPageToShow=TerminologyURL
            performSegueWithIdentifier("showWebView", sender: self)
            
        default:
            NSLog ("switch not supported")
        }
        
    }
    
    
    override func viewDidLoad() {
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        let currentPath=del.locationManager.currentPath
        del.locationManager.delegate=self
        del.locationManager.forget()
        del.locationManager.newPath()
        del.locationManager.prepare()
        del.locationManager.startTracking() // start tracking
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor(red: 171/255, green: 217/255, blue: 233/255, alpha: 10.0)

        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        del.locationManager.stopTracking()
        del.locationManager.delegate=nil
        del.locationManager.forget()
        if(segue.identifier == "ShowActivityHistory" ){
            let histList  = segue.destinationViewController as HistoryList
            if doShowAll==1 {
                histList.showall=true
            }else{
                histList.showall=false
                histList.myLoc=myLoc
            }
            doShowAll = 0
        }else if(segue.identifier == "showRoutesRoundHere"){
            let rrh  = segue.destinationViewController as SUPRoutesRoundHere
            rrh.myLoc=myLoc
        }else if(segue.identifier == "showWebView"){
            let rrh  = segue.destinationViewController as SUPWebView
            rrh.urlToShowString=webPageToShow
        }
        
    }
    
    
    func didUpdateLocations(newLocation:CLLocation){
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        let currentPath=del.locationManager.currentPath
        
        // average the two location accuraccy figures and see if it's less than 50
        
        // horzacc.text=formatToNDP(newLocation.horizontalAccuracy, toDP:2)
        //  vertacc.text=formatToNDP(newLocation.verticalAccuracy, toDP:2)
        
        myLoc=newLocation;
        if(newLocation.horizontalAccuracy > 0 && newLocation.verticalAccuracy > 0){
            var average = newLocation.verticalAccuracy + newLocation.horizontalAccuracy
            
            if newLocation.verticalAccuracy < 0 || newLocation.horizontalAccuracy < 0 {
                average=100
            }
            
            if average > 100 {
                average = 100
            }
            
            average = average / 100
            
            //var average  = 1.0 - ( ((newLocation.verticalAccuracy + newLocation.horizontalAccuracy ) / 2.0) / 100.0)
            // avacc.text=formatToNDP(average, toDP:2)
            //   if average < 0.3 {
            //       self.accuracyBar.backgroundColor = UIColor.greenColor()
            //  }else{
            //      self.accuracyBar.backgroundColor = UIColor.redColor()
            //  }
            //  var tmp:Float = Float(average)
            //  accuracyBar.setProgress(tmp, animated:true)
            
        }
    }
    func didUpdateHeading(newHeading:CLHeading){}; // don;t care about heading updates

}

