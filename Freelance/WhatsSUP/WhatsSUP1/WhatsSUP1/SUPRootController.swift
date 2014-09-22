//
//  SUPRootController.swift
//  WhatsSUP1
//
//  Created by Tim Teece on 20/06/2014.
//  Copyright (c) 2014 Tim Teece. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class SUPRootController:UIViewController, CLLocationManagerDelegate , UINavigationControllerDelegate{
    
    let mettomiles = 0.000621371192
    let mettonmiles = 0.000539956803 // international/US not UK! uk is
    let mstomph = 2.23693629
    let mstoknotts = 1.94384449
    let mstokmh = 3.6
    let mettokm = 0.001
    
    func getUnitsString()->String{
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        var useMiles=0;
        
        if var appset=del.getAppSettings(){
            if appset.usemiles.integerValue==1{
                useMiles=1
            }else if appset.usemiles.integerValue==2{
                useMiles=2
            }
        }
        if useMiles==1{
            return "m"
        }else if useMiles==2{
            return "nm"
        }else{
            return "km"
        }
    }
    func getMinorUnitsString()->String{
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        var useMiles=0;
        
        if var appset=del.getAppSettings(){
            if appset.usemiles.integerValue==1{
                useMiles=1
            }else if appset.usemiles.integerValue==2{
                useMiles=2
            }
        }
        if useMiles==1{
            return "ft"
        }else if useMiles==2{
            return "ft"
        }else{
            return "m"
        }
    }

    func getUnitsSpeedString()->String{
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        var useMiles=0;
        
        if var appset=del.getAppSettings(){
            if appset.usemiles.integerValue==1{
                useMiles=1
            }else if appset.usemiles.integerValue==2{
                useMiles=2
            }
        }
        if useMiles==1{
            return "mph"
        }else if useMiles==2{
            return "kn"
        }else{
            return "kph"
        }
    }
   
    func formatToNDP(theNumber : Double, toDP:Int?)->String{
        var dp=2 // default
        if let test=toDP{
            dp=test
        }
        let nf = NSNumberFormatter()
        nf.numberStyle = NSNumberFormatterStyle.DecimalStyle
        nf.maximumFractionDigits = dp
        return nf.stringFromNumber(theNumber)
    }
    
    func formatDistanceToNDP(theNumber : Double, toDP:Int?)->String{
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        var useMiles=0;
        var dp=2 // default
        if let test=toDP{
            dp=test
        }
        
        if var appset=del.getAppSettings(){
            if appset.usemiles.integerValue==1{
                useMiles=1
            }else if appset.usemiles.integerValue==2{
                useMiles=2
            }
        }
        var newVal=theNumber
        
        if useMiles==1{
            newVal = theNumber * mettomiles
        }else if useMiles==2{
            newVal = theNumber * mettonmiles
        }else{
            // use km
            newVal = theNumber * mettokm
            
        }
        return formatToNDP(newVal, toDP: dp)
    }
    
    func formatSpeedToNDP(theNumber : Double, toDP:Int?)->String{
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        var useMiles=0;
        var dp=2 // default
        if let test=toDP{
            dp=test
        }
        
        if var appset=del.getAppSettings(){
            if appset.usemiles.integerValue==1{
                useMiles=1
            }else if appset.usemiles.integerValue==2{
                useMiles=2
            }
        }
        var newVal=theNumber
        
        if useMiles==1{
            newVal = theNumber * mstomph
        }else if useMiles==2{
            newVal = theNumber * mstoknotts
        }else{
            // use km
            newVal = theNumber * mstokmh
            
        }
        return formatToNDP(newVal, toDP: dp)
    }

    func getFastestSlowestSegments(currentPath : SavedSUPPath) -> (slowSeg: Int, fastSeg: Int){
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        var segmentSize = 1.0 / mettokm // the size of each segment
        
        if var appset = del.getAppSettings(){
            if appset.usemiles.integerValue==1{
                segmentSize = 1.0 / mettomiles
            }else if appset.usemiles.integerValue==2{
                segmentSize = 1.0 / mettonmiles
            }
        }
        var currentSegment = 0.0 // the start segment
        var fastestSpeed = -0.1
        var slowestSpeed = 99999.9999
        var fastestSeg = -1;
        var slowestSeg = -1;
        
        var maxDistance=currentPath.distance.doubleValue
        
        var currentSegStart = currentSegment * segmentSize
        while (maxDistance > currentSegStart ){
        
            var thissegAvSpeed=currentPath.getAverageSpeedOverDistance(segmentSize, forInterval: currentSegment)
            
            if(thissegAvSpeed.doubleValue < slowestSpeed){
                slowestSeg = Int(currentSegment)
                slowestSpeed=thissegAvSpeed.doubleValue
            }
            if(thissegAvSpeed.doubleValue > fastestSpeed){
                fastestSeg = Int(currentSegment)
                fastestSpeed=thissegAvSpeed.doubleValue
            }
            // end of loop calcuations
            currentSegment = currentSegment + 1.0
            currentSegStart = currentSegment * segmentSize
        }
        
        return (slowestSeg, fastestSeg)
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        if let navController = self.navigationController {
            navigationController!.navigationBar.backgroundColor = UIColor.blueColor()
            navigationController!.navigationBar.titleTextAttributes=[NSFontAttributeName: UIFont(name: "AvenirNext-BoldItalic", size: 15)]
        }
    }
}