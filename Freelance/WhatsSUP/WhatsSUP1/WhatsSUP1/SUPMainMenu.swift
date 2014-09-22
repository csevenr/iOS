//
//  SUPMainMenu.swift
//  WhatsSUP1
//
//  Created by Tim Teece on 30/06/2014.
//  Copyright (c) 2014 Tim Teece. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

@objc(SUPMainMenu)
class SUPMainMenu: SUPRootController, UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate,LocationDelegate,BouncingMenuDelegate{
    
    @IBOutlet var menu: BouncingMenu!
    @IBOutlet var backgound :UIImageView!
    @IBOutlet var totalRunsLab :UILabel!
    @IBOutlet var totalDistanceLab :UILabel!
    @IBOutlet var lastRunDateLab :UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //bouncing menu added in storyboard, set some properties here
        menu.image=UIImage(named: "menuBg.png")
//        menu.backgroundColor=UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0);
        menu.frame=CGRectMake(menu.frame.origin.x, self.view.frame.size.height-100.0, menu.frame.size.width, self.view.frame.height-60)
        menu.delegate=self
        self.view.addSubview(menu)

        self.tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y+30.0, tableView.frame.size.width, menu.frame.size.height-80)

        //custom font stuff, cant get it working right now
        
//        let customFont = UIFont(name: "Thonburi-Bold", size: 27.0)
//        totalRunsLab.font=customFont
//        totalDistanceLab.font=customFont
//        lastRunDateLab.font=customFont
//        
//        for family: AnyObject in UIFont.familyNames() {
//            println("\(family)")
//            for font: AnyObject in UIFont.fontNamesForFamilyName(family as NSString) {
//                println(" \(font)")
//            }
//        }
        
      //  var pst=PostToSocialMedia()
        
        /*FBLoginView *loginView = [[FBLoginView alloc] init];
        loginView.center = self.view.center;
        [self.view addSubview:loginView];
       */
        //refreshData()
                /*
        UIGraphicsBeginImageContext(self.view.bounds.size);
        
        var c=UIGraphicsGetCurrentContext()
        CGContextTranslateCTM(c, 0, 0);
        self.view.layer.renderInContext(c)

        var viewImage = UIGraphicsGetImageFromCurrentImageContext();
        
        //viewImage = viewImage.applyBlurWithRadius(5.0, tintColor: UIColor.blueColor(), saturationDeltaFactor: 1.0, maskImage: image)
        backgound.image = viewImage.applyBlurWithRadius(0.2, tintColor: UIColor.blueColor(), saturationDeltaFactor: 0.5, maskImage: image)
        
        UIGraphicsEndImageContext();

        */
//        UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
        
        
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        let currentPath=del.locationManager.currentPath
        del.locationManager.delegate=self
        del.locationManager.forget()
        del.locationManager.newPath()
        del.locationManager.prepare()
        del.locationManager.startTracking() // start tracking
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.clearColor()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        refreshData()
    }
    
    func refreshData(){
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        if del.dataReady{
            let currentPath=del.locationManager.currentPath
            
            var fReq: NSFetchRequest = NSFetchRequest(entityName: "SavedSUPPath")
            var sorter: NSSortDescriptor = NSSortDescriptor(key: "date" , ascending: false)
            fReq.sortDescriptors = [sorter]
            
            var lastDate:NSDate?
            var totalDistance = 0.0
            var totalRuns = 0
            var error: NSError? = nil
            var result = del.managedObjectContext!.executeFetchRequest(fReq, error:&error)
            if var res=result{
                for resultItem : AnyObject in res {
                    
                    totalRuns++;
                    var supPath = resultItem as SavedSUPPath
                    
                    totalDistance+=supPath.distance.doubleValue
                    
                    if var tmpdate = lastDate{
                    }else{
                        lastDate = supPath.date
                    }
                }
            }
            totalRunsLab.text="\(totalRuns)"
            totalDistanceLab.text=formatToNDP(totalDistance/1000.0, toDP: 3)
            if let temp = lastDate{
                //NSDateFormatter *format = [[NSDateFormatter alloc] init];
                //[format setDateFormat:@"MMM dd, yyyy HH:mm"];
                //NSDate *now = [[NSDate alloc] init]
                //NSString *dateString = [format stringFromDate:now];

                var df=NSDateFormatter()
                df.dateFormat="dd MMM yyyy HH:mm:SS"
                lastRunDateLab.text=df.stringFromDate(temp)
            }else{
                lastRunDateLab.text=""
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func unwindToFront(unwindSegue:UIStoryboardSegue){
        refreshData()
    }
    
    // MARK: TableView Shizz

    @IBOutlet var tableView: UITableView!
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
    
//    override
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0;
        count = items.count
        return count;
        
    }
//    override
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        var celldata : String = items[indexPath.row]
        cell.textLabel!.text = celldata
        cell.backgroundColor = UIColor.clearColor()
//        cell.selectedBackgroundView.backgroundColor = UIColor.clearColor()
        
        let myView = UIView(frame: cell.frame)
        myView.backgroundColor = UIColor.clearColor()
        cell.selectedBackgroundView = myView;
        cell.textLabel?.font = UIFont(name: "AvenirNext-BoldItalic", size: 15)
        
        return cell
    }
    
//    override
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
//        tableView.alpha=0.0
        
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

    func alphaValueChanged(alphaValue: CGFloat) {
        self.tableView!.alpha=1.0-alphaValue
    }
}

