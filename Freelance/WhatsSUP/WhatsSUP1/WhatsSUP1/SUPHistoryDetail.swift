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
//import ApplicationServices


class SUPHistoryDetail: SUPRootMapController{
    
    @IBOutlet var saveImageButton : UIButton!
    @IBOutlet var PostFacebookButton : UIButton!
    
    @IBAction func saveImage (sender:UIButton){
        renderMapImage()
    }
    @IBAction func uiPostToFaceBook (sender:UIButton){
        postToTwitter()
        //postToFacebook()
    }
    
    
    override func viewDidLoad() {
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        super.viewDidLoad()

        var error: NSError? = nil

        var currentPath:SavedSUPPath! = del.managedObjectContext!.existingObjectWithID(pathId!, error: &error) as SavedSUPPath!
       // var segInfo = getFastestSlowestSegments(currentPath)
        

        if let tmp=currentPath {
            showCoreDataPath(tmp)
            if var ccid:String = tmp.cloudKitId{
                if ccid.utf16Count > 0 && tmp.fullypostedtocloud {
                    saveToCloud.enabled=false
                }else{
                    saveToCloud.enabled=true
                }
                
            }else{
                saveToCloud.enabled=true
            }

        }
            /*
            avSpeedLabel.text=formatSpeedToNDP(tmp.getAverageSpeed(),toDP:2)
           // topAltLabel.text=formatDistanceToNDP(tmp.topAltitude.doubleValue, toDP: 2)
            distanceLabel.text=formatDistanceToNDP(tmp.distance.doubleValue,toDP:2)
            durationLabel.text=tmp.getDurationFormatted()
            
        }
        
        var minRegionLat=0.00725
        var minRegionLon=0.00725
        
        var hexLocs:[CLLocationCoordinate2D ] =  [CLLocationCoordinate2D ]()

        if var cp = currentPath{
      
            mapScaleView.topSpeedString = formatSpeedToNDP(cp.topSpeed.doubleValue,toDP:2)
            
            //mapScaleView.setMaxSpeed(cp.topSpeed.doubleValue)
            for  x in 1...numSpeedBands{
               // println(cp.topSpeed.doubleValue)
                var maxBandSpeed=Double(x) * (cp.topSpeed.doubleValue/Double(numSpeedBands))
               // println(maxBandSpeed)
                speedBands.append(maxBandSpeed)
            }

            // this tracks the current speed band we are in
            var currentSpeedBand = -1

            if var coordArray = cp.getOrderedPath(){
                var count=0
                var lastLoc:CLLocationCoordinate2D? = nil

                for tmp in coordArray {
                    println("Path element \(count)")
                    var coord:TSavedPathLocation = tmp as TSavedPathLocation
                    var lat: Double = coord.lat.doubleValue
                    var lon: Double = coord.lon.doubleValue
                    var loc2d = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    
                    var thisSpeedBand=0
                    // work out which speedBand we are in
                    for x in 0...(numSpeedBands-1){
                        //println(coord.speed.doubleValue)
                        //println(speedBands[x])
                        if coord.speed.doubleValue < speedBands[x] {
                            thisSpeedBand = x
                            break
                        }
                    }
                    
                    
                    if thisSpeedBand != currentSpeedBand {
                        if count > 0 {
                            if shortHexLocs.count>0 {
                                // we have something to draw
                                var pathOverlay1=MKPolyline(coordinates: &shortHexLocs, count: shortHexLocs.count)
                                pathOverlay1.title="\(currentSpeedBand)"
                                //println("New Title = \(pathOverlay1.title)")
                                mapView.addOverlay(pathOverlay1)
                            }
                            shortHexLocs =  [CLLocationCoordinate2D ]()
                            shortHexLocs.append(lastLoc!)
                        }else{
                            var annot = MKSupPointAnnotation()
                            annot.coordinate = loc2d
                            annot.title="Start"
                            self.mapView.addAnnotation(annot)
                        }
                        currentSpeedBand = thisSpeedBand
                    }
                    
                    shortHexLocs.append(loc2d)
                    lastLoc = loc2d
                    hexLocs.append(loc2d)
                    
                    // are we out of this current segment
                    /*if(coord.totDistance>currentSegEnd){
                        currentSegment = currentSegment + 1.0
                        currentSegStart = segmentSize * currentSegment
                        currentSegEnd = segmentSize * (currentSegment + 1.0)
                    }*/
                    
                    count++
                    
                }
                
                if count > 0 {
                    if shortHexLocs.count>0 {
                        // we have something to draw
                        var pathOverlay=MKPolyline(coordinates: &shortHexLocs, count: shortHexLocs.count)
                        pathOverlay.title="\(currentSpeedBand)"
                        mapView.addOverlay(pathOverlay)
                    }
                }

                
                if var ll=lastLoc{
                    var annot = MKSupPointAnnotation()
                    annot.coordinate = ll
                    annot.title="End"
                    self.mapView.addAnnotation(annot)
                }
            }
        }
        // don't add this one to the map its' only used for the bounding rectangle.
        var pathOverlay=MKPolyline(coordinates: &hexLocs, count: hexLocs.count)
        //mapView.addOverlay(pathOverlay)
        mapView.setVisibleMapRect(pathOverlay.boundingMapRect, animated: true)
//            [LXMapScaleView mapScaleForMapView:mapView];
        
        // adjust visual settings if necessary
        mapScaleView.position = kLXMapScalePositionTopLeft;
        mapScaleView.style = kLXMapScaleStyleBar;
*/
    }
    
    
    @IBAction func saveToCloud (sender:UIButton){
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        var error: NSError? = nil
        var currentPath:SavedSUPPath! = del.managedObjectContext!.existingObjectWithID(pathId!, error: &error) as SavedSUPPath!

        var records:NSArray!=currentPath.saveToCloudKit()
        if var recs=records{
            del.queueRecordsToSaveToTheCloud(recs)

            var scRecs:NSArray!=currentPath.generateScaleDetails()
            if var srecs=scRecs{
                del.queueRecordsToSaveToTheCloud(srecs)
            }
        }
        saveToCloud.enabled=false
        
    }

}

