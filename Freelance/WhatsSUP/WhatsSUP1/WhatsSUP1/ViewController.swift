//
//  ViewController.swift
//  WhatsSUP1
//
//  Created by Tim Teece on 13/06/2014.
//  Copyright (c) 2014 Tim Teece. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController: SUPRootController, CLLocationManagerDelegate , UINavigationControllerDelegate{

    
    
   /* init(nibName: String, bundle: NSBundle?){
        locationManager	= CLLocationManager()
        amTracking=false
        super.init(nibName:nibName, bundle:bundle)
        
        locationManager.delegate=self
        locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter=5 // meters before an update event is required
    }*/
    override func viewDidLoad() {
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override init(coder aDecoder: NSCoder)
    {
        
        super.init(coder: aDecoder)

    }
}

