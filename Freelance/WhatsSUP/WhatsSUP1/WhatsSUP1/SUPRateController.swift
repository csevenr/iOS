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
import MapKit


class SUPRateController: SUPRootMapController{
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        
        if let currentPath=del.locationManager.currentPath{
            showCoreDataPath(currentPath)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
       let del = UIApplication.sharedApplication().delegate as AppDelegate
        del.locationManager.stopTracking()
        del.locationManager.delegate=nil
        
        var ai=UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        ai.hidesWhenStopped=true
        ai.center=CGPointMake(self.view.frame.width/2,self.view.frame.height/2)
        self.view.addSubview(ai)
        ai.startAnimating()
        println(segue.identifier)
        if segue.identifier == "TrashAndUnwind" {
            del.locationManager.cancelTrackingPath()
        }else{
            del.locationManager.finishTrackingPath()
            if var apset=del.getAppSettings() {
                if apset.autoPostToCloud == 1{
                    var error: NSError? = nil
                    if let currentPath=del.locationManager.currentPath{
                        var records:NSArray!=currentPath.saveToCloudKit()
                        if var recs=records{
                            del.queueRecordsToSaveToTheCloud(recs)
                            var scRecs:NSArray!=currentPath.generateScaleDetails()
                            if var srecs=scRecs{
                                del.queueRecordsToSaveToTheCloud(srecs)
                            }

                        }
                        
                    }
                }
            }
        }
        ai.stopAnimating()

    }
    
    

    
    @IBAction func pathRated(sender:UISegmentedControl){
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        let currentPath=del.locationManager.currentPath
        

        if let tmp=currentPath{
           switch(sender.selectedSegmentIndex){
            case 0:
                tmp.rate=0;
            case 1:
                tmp.rate=10;
            case 2:
                tmp.rate=20;
            case 3:
                tmp.rate=30;
            default:
                tmp.rate=40;
            }

        }
    
    }
    /*
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        var customPinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "SUPPathIdentifier")
        if annotation.title! == "Start" {
            customPinView.pinColor=MKPinAnnotationColor.Green
        }else if annotation.title! == "End" {
            customPinView.pinColor=MKPinAnnotationColor.Purple
        }else{
            // just use defaults
            
        }
        customPinView.animatesDrop=true
        customPinView.canShowCallout=true
        
        return customPinView
    }
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        mapScaleView.update()
    }
*/
}

