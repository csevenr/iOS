//
//  SUPRouteSetUp.swift
//  WhatsSUP1
//
//  Created by Tim Teece on 23/06/2014.
//  Copyright (c) 2014 Tim Teece. All rights reserved.
//

import Foundation

import UIKit
import CoreLocation

class SUPRouteSetUp: SUPRootController,LocationDelegate{
    
    @IBOutlet var accuracyBar :UIProgressView!
    @IBOutlet var horzacc :UILabel!
    @IBOutlet var vertacc :UILabel!
    @IBOutlet var avacc :UILabel!
 
    @IBOutlet var weather1 :UIButton!
    @IBOutlet var weather2 :UIButton!
    @IBOutlet var weather3 :UIButton!
    @IBOutlet var weather4 :UIButton!
    @IBOutlet var wind1 :UIButton!
    @IBOutlet var wind2 :UIButton!
    @IBOutlet var wind3 :UIButton!
    @IBOutlet var wind4 :UIButton!
    @IBOutlet var wave1 :UIButton!
    @IBOutlet var wave2 :UIButton!
    @IBOutlet var wave3 :UIButton!
    @IBOutlet var wave4 :UIButton!
    @IBOutlet var compass :UIImageView!
    
    @IBOutlet var weatherCol: [UIButton]!
    @IBOutlet var windCol: [UIButton]!
    @IBOutlet var waveCol: [UIButton]!
  
    override func viewDidLoad() {
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        del.locationManager.delegate=self
        del.locationManager.forget()
        del.locationManager.newPath()
        del.locationManager.prepare()
        del.locationManager.startTracking() // start tracking
        super.viewDidLoad()
        accuracyBar.setProgress(0.0, animated:false)
        
        var image = UIImage(named: "compass.png")
        compass.image = image
        
        
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        del.locationManager.stopTracking()
        del.locationManager.delegate=nil
        del.locationManager.forget()
        
    }
    
    func didUpdateLocations(newLocation:CLLocation){
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        let currentPath=del.locationManager.currentPath
      
        // average the two location accuraccy figures and see if it's less than 50
        
        horzacc.text=formatToNDP(newLocation.horizontalAccuracy, toDP:2)
        vertacc.text=formatToNDP(newLocation.verticalAccuracy, toDP:2)
        
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
            avacc.text=formatToNDP(average, toDP:2)
            if average < 0.3 {
                    self.accuracyBar.backgroundColor = UIColor.greenColor()
            }else{
                self.accuracyBar.backgroundColor = UIColor.redColor()
            }
            var tmp:Float = Float(average)
            accuracyBar.setProgress(tmp, animated:true)
            
        }
    }
    
    // standard callbacls for the navigation delegate methods
    func didUpdateHeading(newHeading:CLHeading){
       // var cmvp : CMutableVoidPointer = nil
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.2)
        UIView.setAnimationDelegate(self)
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        if var appset=del.getAppSettings(){
            if var umn = appset.usemagneticnorth {
                switch(appset.usemagneticnorth.integerValue){
                case 0:
                    self.compass.transform =  CGAffineTransformMakeRotation( CGFloat( ((0-newHeading.trueHeading) * M_PI) / 180.0))
                default:
                    self.compass.transform =  CGAffineTransformMakeRotation( CGFloat( ((0-newHeading.magneticHeading) * M_PI) / 180.0))
                }
            }else{
                self.compass.transform =  CGAffineTransformMakeRotation( CGFloat( ((0-newHeading.trueHeading) * M_PI) / 180.0))
            }
        }
        UIView.commitAnimations()
    }
    
    @IBAction func wavesPressed (sender:UIButton){
        for btn in waveCol {
            btn.alpha=0.4
        }
        sender.alpha=1.0
        
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        let currentPath=del.locationManager.currentPath
        if(sender==wave1){
            currentPath!.waveHeight=0
        }else if(sender==wave2){
            currentPath!.waveHeight=10
        }else if(sender==wave3){
            currentPath!.waveHeight=20
        }else if(sender==wave4){
            currentPath!.waveHeight=30
        }
     

        
    }
    @IBAction func windPressed (sender:UIButton){
        for btn in windCol {
            btn.alpha=0.4
        }
        sender.alpha=1.0
        
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        let currentPath=del.locationManager.currentPath
        if(sender==wind1){
            currentPath!.windSpeed=0
        }else if(sender==wind2){
            currentPath!.windSpeed=10
        }else if(sender==wind3){
            currentPath!.windSpeed=20
        }else if(sender==wind4){
            currentPath!.windSpeed=30
        }
    }
    @IBAction func weatherPressed (sender:UIButton){
        for btn in weatherCol {
            btn.alpha=0.4
        }
        sender.alpha=1.0
        
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        let currentPath=del.locationManager.currentPath
     /*   if(sender==weather1){
            currentPath.weather=0
        }else if(sender==weather2){
            currentPath.weather=10
        }else if(sender==weather3){
            currentPath.weather=20
        }else if(sender==weather4){
            currentPath.weather=30
        }*/
    }
    @IBAction func unwindToSetup(unwindSegue:UIStoryboardSegue){
        
    }
}

