//
//  SUPTrackController.swift
//  WhatsSUP1
//
//  Created by Tim Teece on 20/06/2014.
//  Copyright (c) 2014 Tim Teece. All rights reserved.
//

//
//  ViewController.swift
//  WhatsSUP1
//
//  Created by Tim Teece on 13/06/2014.
//  Copyright (c) 2014 Tim Teece. All rights reserved.
//

import UIKit
import CoreLocation
class SUPLocationManager: NSObject, CLLocationManagerDelegate , UINavigationControllerDelegate{
    
    
    @IBOutlet var mapView: UILabel!
    @IBOutlet var detailLatLabel: UILabel!
    @IBOutlet var detailLongLabel: UILabel!
    @IBOutlet var detailStatusLabel: UILabel!
    @IBOutlet var detailHAccuracyLabel: UILabel!
    @IBOutlet var detailVAccuracyLabel: UILabel!
    @IBOutlet var detailSpeedLabel: UILabel!
    @IBOutlet var detailCourseLabel: UILabel!
    @IBOutlet var detailEventLabel: UILabel!
    @IBOutlet var detailTopSpeedLabel: UILabel!
    @IBOutlet var detailDistanceLabel: UILabel!
    @IBOutlet var detailAltitudeLabel: UILabel!
    @IBOutlet var detailMaxAltitudeLabel: UILabel!
    @IBOutlet var detailHeadingLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    
    var amTracking: Bool=false
    var amRecording: Bool = false
    var locationManager: CLLocationManager = CLLocationManager()

    var lastLocation:CLLocation?
    var locationInitialised = false
    var delegate:LocationDelegate? // where to send any notificaitons

    var currentPath:SavedSUPPath?;
    
    /* init(nibName: String, bundle: NSBundle?){
    locationManager	= CLLocationManager()
    amTracking=false
    super.init(nibName:nibName, bundle:bundle)
    
    locationManager.delegate=self
    locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters
    locationManager.distanceFilter=5 // meters before an update event is required
    }*/
    override init () {
        //+++ need to add the old paths from the system - whereever we store them - ideally the  cloud
        super.init()
 
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = CLActivityType.Fitness
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.pausesLocationUpdatesAutomatically = false
        
        let status = CLLocationManager.authorizationStatus()
        if(status == CLAuthorizationStatus.NotDetermined) {
            self.locationManager.requestAlwaysAuthorization();
        }
        locationManager.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
                
    }
    
    func prepare(){
        let status = CLLocationManager.authorizationStatus()
        if(status == CLAuthorizationStatus.NotDetermined) {
            self.locationManager.requestAlwaysAuthorization();
        }
        locationManager.delegate = self
        
    }

    func newPath(){
        let del = UIApplication.sharedApplication().delegate as AppDelegate

        currentPath = NSEntityDescription.insertNewObjectForEntityForName("SavedSUPPath", inManagedObjectContext: del.managedObjectContext!) as? SavedSUPPath
        if var tmp = currentPath{
            tmp.initNew()
            tmp.date = NSDate()
            tmp.eventCount = 0
            tmp.fullypostedtocloud=false
            tmp.cloudKitId=nil
        }
    }
    
    func forget(){
        
        let del = UIApplication.sharedApplication().delegate as AppDelegate

        // need to store the current path to the database
        // store the last path if its got data in it and create a new one
        if let cur = currentPath? {
            var error: NSError? = nil
            del.managedObjectContext!.deleteObject(cur)
            //newPath()
        }
        currentPath=nil
        /*currentPath = NSEntityDescription.insertNewObjectForEntityForName("SavedSUPPath", inManagedObjectContext: del.managedObjectContext) as? SavedSUPPath
        if var tmp = currentPath{
            tmp.date = NSDate()
            tmp.eventCount = 0
        }*/
        
        //currentPath=SavedSUPPath.createMyObject(del.managedObjectContext)!
        
    }
    
    func save(){
        
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        
        // need to store the current path to the database
        // store the last path if its got data in it and create a new one
        if let cur = currentPath? {
            if var cup=cur.uncompressedPath{
                if(cup.count==0){
                    var av=UIAlertView(title: "Warning", message:"Nothing to save", delegate: nil, cancelButtonTitle: "OK")
                    av.show()
                    del.managedObjectContext!.deleteObject(cur)
                }else{
                    var error: NSError? = nil
                    //del.managedObjectContext!.save(&error)
                    if cur.managedObjectContext.hasChanges {
                        cur.managedObjectContext.save(&error)
                    }
                    if(error == nil){
                        if del.managedObjectContext!.hasChanges {
                            del.managedObjectContext!.save(&error)
                        }
                        if(error == nil){
                            var av=UIAlertView(title: "Success", message:"Path Saved", delegate: nil, cancelButtonTitle: "OK")
                            av.show()
                        }else{
                            var av=UIAlertView(title: "Error", message: error?.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
                            av.show()
                        }
                        //cur.managedObjectContext.reset()
                    }else{
                        var av=UIAlertView(title: "Error", message: error?.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
                        av.show()
                    }
                }
            }else{
                var av=UIAlertView(title: "Warning", message:"Nothing to save", delegate: nil, cancelButtonTitle: "OK")
                av.show()
                del.managedObjectContext!.deleteObject(cur)
            }
        }
        //newPath()
        
    }
    
    
    
/*   func toggleTracking(){
        
        if(amTracking){
            stopTracking()
        }else{
            startTracking()
        }
    }*/
    

    // these do not store paths
    func startTracking(){
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        amTracking=true;
        
    }

    func stopTracking(){
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
        amTracking=false;
    }


    // new functions
    func startTrackingPath(){
        newPath()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        amTracking=true
        amRecording=true
        println("StartTrackingPath")
        
    }

    func continueTrackingPath(){
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        amTracking=true
        amRecording=true
        println("continueTrackingPath")
        
    }

    func pauseTrackingPath(){
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        amTracking=true
        amRecording=false
        println("pauseTrackingPath")
 
    }

    func stopTrackingPath(){
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
        amTracking=false
        amRecording=false
        if var cur=currentPath{
            cur.complete()
            let del = UIApplication.sharedApplication().delegate as AppDelegate
            if var p = del.getPBS(){
                p.addPathToRecords(cur)//+++ here tim if this fails the the app is not ready yet.... which means the user should not have got here. 
            }
        }
        self.save()
        println("stopTrackingPath")

    }

    func cancelTrackingPath(){
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
        amTracking=false
        amRecording=false
        if let curPth = currentPath?{
            let del = UIApplication.sharedApplication().delegate as AppDelegate
            del.pbs!.removePathFromRecords(curPth)//+++ here tim
        }
        self.forget()
        currentPath=nil
        println("cancelTrackingPath")

    }

    func finishTrackingPath(){
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
        self.save()
        amTracking=false
        amRecording=false
        currentPath=nil
        println("finishTrackingPath")

    }
    

    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.NotDetermined) {
            println("CLL Auth status unkown still!");
        }else{
            println("CLL Auth status known");
        }
    }
    
    
    func locationManager(manager:CLLocationManager,didUpdateHeading newHeading:CLHeading){
//        currentPath?.path?.count>0
//        currentPath.headings.append(newHeading)
        
        if let currentDel  = delegate?{
            currentDel.didUpdateHeading(newHeading)
        }else{
            // no delegate set
        }
    }
    
    
    func locationManager(manager:CLLocationManager,didUpdateLocations locations:NSArray){
       // var location:CLLocation = locations.lastObject as CLLocation

        if let curPth = currentPath?{
            let del = UIApplication.sharedApplication().delegate as AppDelegate

            for (index,curlocation) in enumerate(locations){
                let loc=curlocation as CLLocation
                
                if loc.verticalAccuracy >= 0 && loc.verticalAccuracy < 20 && loc.horizontalAccuracy >= 0 && loc.horizontalAccuracy < 20 {
                    
                    if amTracking{
                        
                        let newLoc:TSavedPathLocation = TSavedPathLocation()
                        
                        //let newLoc:SavedPathLocations = NSEntityDescription.insertNewObjectForEntityForName("SavedPathLocations", inManagedObjectContext: del.managedObjectContext!) as SavedPathLocations
                    
                        newLoc.stepNo=currentPath!.uncompressedPath.count
                        newLoc.direction=loc.course
                        newLoc.hAcc=loc.horizontalAccuracy
                        newLoc.vAcc=loc.verticalAccuracy
                        if (loc.horizontalAccuracy > 0 && loc.horizontalAccuracy < 20){
                            newLoc.altitude=loc.altitude
                        }
                        
                        var eventDate = loc.timestamp
                        var howRecent = eventDate.timeIntervalSinceNow
                        
                        curPth.eventCount = curPth.uncompressedPath.count
                        
                        if (currentPath?.topAltitude.doubleValue < loc.altitude) {
                            var val:NSNumber = loc.altitude
                            curPth.topAltitude = val
                        }
                    
                        newLoc.lat=loc.coordinate.latitude
                        newLoc.lon=loc.coordinate.longitude
                        newLoc.speed=loc.speed
                        newLoc.timestamp=loc.timestamp
                        
                        
                        if loc.speed >= 0{
                            var topspeed=curPth.topSpeed.doubleValue
                            if topspeed < loc.speed {
                                var val:NSNumber = loc.speed
                                curPth.topSpeed = val
                            }
                        }

                        
                        if let tempLoc=lastLocation?{
                            if let dist = currentPath?.distance!{
                                var dv = dist.doubleValue
                                dv = dv + loc.distanceFromLocation(tempLoc)
                                //curPth.distance!.setValue(dv, forKey: "distance")
                                curPth.distance = dv
                            }
                            lastLocation=loc.copy() as? CLLocation
                        }else{
                            lastLocation=loc.copy() as? CLLocation
                            locationInitialised=true;
                        }
                        if amRecording {
                            newLoc.totDistance=curPth.distance
                            if(curPth.uncompressedPath.count==0) {
                                curPth.startLat = newLoc.lat
                                curPth.startLon = newLoc.lon
                            }
                            curPth.addPathObject(newLoc)
                            curPth.endLat = newLoc.lat
                            curPth.endLon = newLoc.lon
                            curPth.endDate = newLoc.timestamp;
                            curPth.averageSpeed = curPth.getAverageSpeed()
                        }
                    }else{
                      // do nothing
                      
                    }
                }
            }
        }
        
        
        // call back to the delegate if set
        if let currentDel  = delegate?{
            currentDel.didUpdateLocations(locations.lastObject as CLLocation)
        }else{
            // no delegate set
        }

    }

}


