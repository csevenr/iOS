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

class SUPTrackController: SUPRootController , UIAlertViewDelegate,LocationDelegate{
    
    @IBOutlet var mapView: UILabel!
    @IBOutlet var detailLatLabel: UILabel!
    @IBOutlet var detailLongLabel: UILabel!
    @IBOutlet var detailStatusLabel: UILabel!
    @IBOutlet var detailHAccuracyLabel: UILabel!
    @IBOutlet var detailVAccuracyLabel: UILabel!
    @IBOutlet var detailSpeedLabel: UILabel!
    @IBOutlet var avSpeedLabel: UILabel!
    @IBOutlet var detailCourseLabel: UILabel!
    @IBOutlet var detailRawCourseLabel: UILabel!
    @IBOutlet var detailEventLabel: UILabel!
    @IBOutlet var detailCountLabel: UILabel!
    @IBOutlet var detailTopSpeedLabel: UILabel!
    @IBOutlet var detailDistanceLabel: UILabel!
    @IBOutlet var detailDurationLabel: UILabel!
    @IBOutlet var detailAltitudeLabel: UILabel!
    @IBOutlet var detailMaxAltitudeLabel: UILabel!
    @IBOutlet var detailHeadingLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var countDownLabel: UILabel!
    @IBOutlet var compass :UIImageView!
    @IBOutlet var arrow :UIImageView!
    @IBOutlet var tSpeedLab: UILabel!
    @IBOutlet var tMaxSpLab: UILabel!
    @IBOutlet var tAvSpLab: UILabel!
    @IBOutlet var tDistLab: UILabel!
    @IBOutlet var tDurationLab: UILabel!
    @IBOutlet var tAltitudeLab: UILabel!
    @IBOutlet var tMaxAltLab: UILabel!
    @IBOutlet var pauseButton: UIButton!
    @IBOutlet var trashButton: UIButton!
    //@IBOutlet var headingText :UITextField
    //@IBOutlet var courseText :UITextField
    

    
    var amTracking = false
    var countdown=5
    var timer : NSTimer?
    var timerClock : NSTimer?

    var currentHeading = -1.0
    var currentCourse = -1.0
    
    var pauseCont : UIAlertView? = nil
    
    override func viewDidLoad() {
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        del.locationManager.delegate=self
        del.locationManager.prepare()
        del.locationManager.startTracking()
        
        if var appset=del.getAppSettings(){
            if var cd = appset.startdelay{
                countdown=cd.integerValue
            }
        }
        super.viewDidLoad()
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("CountDown"), userInfo: nil, repeats: true)
        
        var board = UIImage(named: "compass.png")
        compass.image = board
        var arrowimg = UIImage(named: "nspelements.png")
        arrow.image = arrowimg
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func toggleTracking(){
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        timerClock?.invalidate()

        del.locationManager.pauseTrackingPath()
        pauseCont = UIAlertView(title: "End Track", message: "End Route?", delegate: self, cancelButtonTitle: "Continue", otherButtonTitles: "Yes")
        pauseCont?.show()
    }
    
    @IBAction func doCancel(){
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        
        var error: NSError? = nil
        del.managedObjectContext!.save(&error)
        
        var alert:UIAlertView = UIAlertView(title: "Confirmation", message: "Did you want to delete this route?", delegate: self, cancelButtonTitle: "No", otherButtonTitles: "Yes")
        alert.show()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        timerClock?.invalidate()

        // make sure you stop tracking
        del.locationManager.pauseTrackingPath()
        del.locationManager.delegate=nil
    }
    
    func alertView( alertView: UIAlertView!,
        clickedButtonAtIndex buttonIndex: Int){
            if var av = self.pauseCont{
                let del = UIApplication.sharedApplication().delegate as AppDelegate

                if(buttonIndex==0){
                    timerClock = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("updateClock"), userInfo: nil, repeats: true)
                    del.locationManager.continueTrackingPath()
                }else{
                    performSegueWithIdentifier("Rate", sender: self)
                    del.locationManager.stopTrackingPath()
                }
            }else{
                // tthe user pressed the trash can
                let del = UIApplication.sharedApplication().delegate as AppDelegate
                if buttonIndex == 0 {
                    del.locationManager.continueTrackingPath()

                    NSLog ("the user pressed No")
                }else{
                    NSLog ("the user pressed Yes")
                    del.locationManager.cancelTrackingPath()
                    performSegueWithIdentifier("BackToMainMenu", sender: self)
                }
            }
    }
    
    
    func updateClock(){
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        let currentPath=del.locationManager.currentPath?
        
        if let cpth = currentPath{
            detailDurationLabel.text=cpth.getDurationToNowFormatted()
        }
    }
    func CountDown() {
        let del = UIApplication.sharedApplication().delegate as AppDelegate

        if(countdown==0){
            timer?.invalidate()
            countDownLabel.removeFromSuperview()
            del.locationManager.startTrackingPath()
            timerClock = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("updateClock"), userInfo: nil, repeats: true)
            tSpeedLab.alpha=1.0
            tMaxSpLab.alpha=1.0
            tAvSpLab.alpha=1.0
            tDistLab.alpha=1.0
            tMaxAltLab.alpha=1.0
            tDurationLab.alpha=1.0
            tAltitudeLab.alpha=1.0
            detailSpeedLabel.alpha=1.0
            detailTopSpeedLabel.alpha=1.0
            detailAltitudeLabel.alpha=1.0
            detailMaxAltitudeLabel.alpha=1.0
            detailDistanceLabel.alpha=1.0
            avSpeedLabel.alpha=1.0
            detailDurationLabel.alpha=1.0

        }else{
            countDownLabel.text="\(countdown)"
            countdown--
        }
    }
    

    // standard callbacls for the navigation delegate methods
    func didUpdateHeading(newHeading:CLHeading){
        //detailHeadingLabel.text=formatToNDP(newHeading.magneticHeading,toDP:2)
       // var cmvp : CMutableVoidPointer = nil
       // currentHeading=self.headingText.text.bridgeToObjectiveC().doubleValue

        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.2)
        UIView.setAnimationDelegate(self)
        var temp=(0.0 - newHeading.trueHeading)
        var temp2=temp * M_PI
        var temp3=temp2/180.0
        var temp4=CGFloat(temp3)
        self.compass.transform =  CGAffineTransformMakeRotation(temp4)
//        CGAffineTransformMakeRotation(temp3.floatingPointClass)
        //self.compass.transform =  CGAffineTransformMakeRotation( ((0.0-newHeading.trueHeading) * M_PI) / 180.0)
        //self.compass.transform =  CGAffineTransformMakeRotation( Float( ((0-currentHeading) * M_PI) / 180.0))
        UIView.commitAnimations()
        
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        if var appset=del.getAppSettings(){
            switch(appset.usemagneticnorth.integerValue){
            case 0:
                currentHeading = newHeading.trueHeading
            default:
                currentHeading = newHeading.magneticHeading
            }
        }
        
        
        //currentHeading=self.headingText.text.bridgeToObjectiveC().doubleValue
        updateCourse()
        
    }
    
    func didUpdateLocations(newLocation:CLLocation){
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        let currentPath=del.locationManager.currentPath?
        
        if let cpth = currentPath{
            //detailCountLabel.text=String(cpth.eventCount.doubleValue)
            //detailVAccuracyLabel.text=String(newLocation.verticalAccuracy)
            //detailHAccuracyLabel.text=String(newLocation.horizontalAccuracy)
            detailSpeedLabel.text=formatSpeedToNDP(newLocation.speed, toDP:2)
            detailTopSpeedLabel.text=formatSpeedToNDP(cpth.topSpeed.doubleValue, toDP:2)
            
            detailAltitudeLabel.text=formatDistanceToNDP(Double(newLocation.altitude), toDP:2)
            detailMaxAltitudeLabel.text=formatDistanceToNDP(cpth.topAltitude.doubleValue, toDP:2)
            //detailLatLabel.text=String(newLocation.coordinate.latitude)
            //detailLongLabel.text=String(newLocation.coordinate.longitude)
            detailDistanceLabel.text=formatDistanceToNDP(cpth.distance.doubleValue, toDP:2)
            var val=cpth.getAverageSpeed()
            avSpeedLabel.text=formatSpeedToNDP(val.doubleValue, toDP:2)
            
            var course:NSNumber = newLocation.course
            var courseDbl:Double = Double(course)
            currentCourse=courseDbl
            //currentCourse=self.courseText.text.bridgeToObjectiveC().doubleValue

            detailDurationLabel.text=cpth.getDurationFormatted()
            updateCourse()
        }
    }
    
    func updateCourse(){
        var courseDbl = currentCourse
        if courseDbl > 0 && currentHeading > 0 {
       // currentCourse=self.courseText.text.bridgeToObjectiveC().doubleValue
        //currentHeading=self.headingText.text.bridgeToObjectiveC().doubleValue
            var courseDbl=currentCourse

            arrow.alpha = 1.0
            //detailRawCourseLabel.text=formatToNDP(currentCourse,toDP:2)
            
            var tmp = (360 - courseDbl) + currentHeading
            var arse = true
            if(tmp > 360){
                arse=false
                tmp = tmp - 360
            }
           // NSLog ("\(courseDbl) \(currentCourse) \(currentHeading) \(tmp) \(arse)")

            
            //detailCourseLabel.text=formatToNDP(courseDbl,toDP:2)
            //var cmvp : CMutableVoidPointer = nil
            var rotDouble=( ((0-tmp) * M_PI) / 180.0)
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.5)
            UIView.setAnimationDelegate(self)
            var t2:CGFloat = CGFloat(rotDouble)
            self.arrow.transform =  CGAffineTransformMakeRotation(t2)
            UIView.commitAnimations()
        }else{
            arrow.alpha = 0.2
        }
    }

}


