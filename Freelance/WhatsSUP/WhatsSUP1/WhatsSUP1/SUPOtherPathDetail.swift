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


class SUPOtherPathDetail: SUPRootMapController{

    var recordId:CKRecordID?=nil
    var coordReg:MKCoordinateRegion?=nil
    var oldOverLay:MKPolyline?=nil
    var expectedRecords:UInt=1000
    var hexLocs:[CLLocationCoordinate2D ] =  [CLLocationCoordinate2D ]()

    
    override func viewDidLoad() {
        let del = UIApplication.sharedApplication().delegate as AppDelegate

        super.viewDidLoad()
        
        var error: NSError? = nil
        
        ai.hidesWhenStopped=true
        ai.startAnimating()
        if var cr = coordReg{
            self.mapView.region = cr
        }
        
        // get all the information from the cloud...
        var pubDB=CKContainer.defaultContainer().publicCloudDatabase;
        
        pubDB.fetchRecordWithID(recordId, completionHandler: { (record:CKRecord?, error:NSError!) in
            if let fetchError = error {
                var av=UIAlertView(title: "Error", message: "Could not acess cloud data: \(error!.description)", delegate: nil, cancelButtonTitle: "Close")
            } else {
                // set the strings up
                if var rec=record{
                    dispatch_async(dispatch_get_main_queue(), {
                        self.updateInfoFromRecord(rec)
                    })
                }
            }

        })
    }

    func updateInfoFromRecord(record:CKRecord){
        var shortHexLocs:[CLLocationCoordinate2D ] =  [CLLocationCoordinate2D ]()

        // get the pathElements which is an array of encoded objects
        // loop over them and add them as a path on the map
        if var avSpeed=record.objectForKey("averageSpeed") as NSNumber?{
            if var tmp=self.avSpeedLabel{
                tmp.text=formatSpeedToNDP(avSpeed.doubleValue ,toDP:2)
            }
        }

        if var topSpeed=record.objectForKey("topSpeed") as NSNumber?{
            mapScaleView.topSpeedString = formatDistanceToNDP(topSpeed.doubleValue,toDP:2)
        }
        
        
        var topSpeed=Double(0.0)

        if var tmp=record.objectForKey("topSpeed") as Double?{
            topSpeed=tmp
        }
       
        if var pathelementsAsset:CKAsset=record.objectForKey("pathElementsCompressed") as CKAsset?{
           var uncompressedData:NSData! = nil
            
            if var pathcompressedsize:NSNumber = record.objectForKey("pathElementsCompressedLength") as? NSNumber{
                // decompress the data
                uncompressedData = CompressionUtils.deCompress(pathelementsAsset, expectedDataLength: pathcompressedsize.unsignedLongValue)
                
            }
            
            // unarchive the data
            if var tAnyObj1:AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(uncompressedData){
                // check it's an array like we think it is
                if var pathelements:NSArray = tAnyObj1 as? NSArray{
                    
                    for  x in 1...numSpeedBands{
                       // println(topSpeed)
                        var maxBandSpeed=Double(x) * (topSpeed/Double(numSpeedBands))
                       //  println(maxBandSpeed)
                        speedBands.append(maxBandSpeed)
                    }
                    
                    var currentSpeedBand = -1
                    var count=0
                    var lastLoc:CLLocationCoordinate2D? = nil

                    for pathelement in pathelements{
                        if var tSavedPath:TSavedPathLocation = pathelement as? TSavedPathLocation{
                            var loc2d = CLLocationCoordinate2D(latitude: tSavedPath.lat, longitude: tSavedPath.lon )
                            
                            var thisSpeedBand=0
                            // work out which speedBand we are in
                            for x in 0...(numSpeedBands-1){
                       //         println("element speeed \(tSavedPath.speed)")
                       //         println(speedBands[x])
                                if tSavedPath.speed < speedBands[x] {
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
                                    startLoc2D=loc2d
                                    self.mapView.addAnnotation(annot)
                                }
                                currentSpeedBand = thisSpeedBand
                            }
                            
                            colourLineMaps.append(currentSpeedBand) // ensure we have a list of the color bands
                            pathLoc2ds.append(loc2d) // and this is the path
                            
                            shortHexLocs.append(loc2d)
                            lastLoc = loc2d
                            hexLocs.append(loc2d)
                
                            count++
                        }
                    
                    }
                    if count > 0 {
                        if var ll=lastLoc{
                            var annot = MKSupPointAnnotation()
                            annot.coordinate = ll
                            annot.title="End"
                            endLoc2D = ll

                            self.mapView.addAnnotation(annot)
                        }
                        if shortHexLocs.count>0 {
                            // we have something to draw
                            var pathOverlay=MKPolyline(coordinates: &shortHexLocs, count: shortHexLocs.count)
                            pathOverlay.title="\(currentSpeedBand)"
                            dispatch_async(dispatch_get_main_queue(), {
                                self.mapView.addOverlay(pathOverlay)
                            })
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                       
                        self.addFinalOverlay()
                        self.ai.stopAnimating()
                        
                    })
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), {
                        self.ai.stopAnimating()
                        
                    })
                }
            }
        }
    }
    
    func addPointToPath(loc:CLLocation){
        var lat: Double = loc.coordinate.latitude
        var lon: Double = loc.coordinate.longitude
        
        var loc2d = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        hexLocs.append(loc2d)
        
        
    }
    func addFinalOverlay(){
        var pathOverlay=MKPolyline(coordinates: &hexLocs, count: hexLocs.count)
       // mapView.addOverlay(pathOverlay)
        mapView.setVisibleMapRect(pathOverlay.boundingMapRect, animated: true)
        ai.stopAnimating()
        hexLocs.removeAll(keepCapacity: false) // clear the hexlocs array
    }
    
    func addAnnotation(annot:MKPointAnnotation){
        self.mapView.addAnnotation(annot)
    }

    
    
      
}

