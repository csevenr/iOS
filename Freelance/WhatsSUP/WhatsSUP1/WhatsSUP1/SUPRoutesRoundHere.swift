//
//  SUPRoutsRoundHere.swift
//  WhatsSUP1
//
//  Created by Tim Teece on 11/08/2014.
//  Copyright (c) 2014 Tim Teece. All rights reserved.
//
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


class SUPRoutesRoundHere: SUPRootController, MKMapViewDelegate{
    
    @IBOutlet var mapView : MKMapView!
    var myLoc:CLLocation?

    var pathId : NSManagedObjectID?
    var strokeColour = UIColor.blueColor();
    var tappedid:CKRecordID?=nil
    var timer : NSTimer? = nil
    var ai:UIActivityIndicatorView?=nil
    var mapScaleView:SUPSSHelper!;
    var mapScaleLevel = -1;
    
    let maxMapPoints=1000

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapScaleView = SUPSSHelper.mapScaleForMapView(mapView)

        if var loc = myLoc{
            var loc2d = CLLocationCoordinate2D(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude )

            var loc2dlat=loc2d.latitude
            var loc2dlon=loc2d.longitude
            
            var region:MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(loc2d, Double(1000), Double(1000));
            mapView.delegate=self
            mapView.setRegion(region, animated: true)
        }
        
    }
    
   
    
    func updateData(){
        var count=0

      //  println("Scale Level = \(mapScaleLevel)")
        if timer != nil {
            // stop any queued queriy from executing
            timer!.invalidate()
            timer=nil
        }
        var loc2d = mapView.centerCoordinate
        var mRect:MKMapRect = mapView.visibleMapRect;
        var eastMapPoint:MKMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
        var westMapPoint:MKMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
        NSLog("%@","updating data")
        var currentDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
        
        var loc2dlat=loc2d.latitude
        var loc2dlon=loc2d.longitude
        
        var toRemoveCount = mapView.annotations.count
        var toRemove = NSMutableArray()
        
        for annotation in mapView.annotations{
            if var annot = annotation as? MKUserLocation{
            }else{
                toRemove.addObject(annotation)
            }
            
        }
        mapView.removeAnnotations(toRemove)
        
        self.ai=UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        self.ai!.hidesWhenStopped=true
        self.ai!.center=CGPointMake(self.view.frame.width/2,self.view.frame.height/2)
        self.view.addSubview(self.ai!)
        self.view.bringSubviewToFront(self.ai!)
        self.ai!.startAnimating()
        var queryLocAttrib="startloc"
        var queryRecord="SavedSUPPath"
        
        
        
        // update data - needs to manage different scale levels
        // max level is 1100 - 2874922 meter per pixel
        // scale level 9000 - 578319 meters per pixel
        // town groups start merging at level 6000
        // town groups start splitting at 4000
        // scale level 10 - looking at a whole town
        // scale level 8 - looking at shops etc.
        // scale level 5/6 - min scale level level 5-23.8 meters per pixel
        
        if (mapScaleLevel<=6){
            // query lowest level
            queryLocAttrib="startloc"
            queryRecord="SavedSUPPath"
        }else if(mapScaleLevel<=7){
            queryLocAttrib="startloc"
            queryRecord="SavedSUPPath"
        }else if(mapScaleLevel<=8){
            queryLocAttrib="location"
            queryRecord="ScaledArea256"
        }else if(mapScaleLevel<=9){
            queryLocAttrib="location"
            queryRecord="ScaledArea256"
        }else if(mapScaleLevel<=10){
            queryLocAttrib="location"
            queryRecord="ScaledArea1024"
        }else if(mapScaleLevel<=2000){
            queryLocAttrib="location"
            queryRecord="ScaledArea1024"
        }else if(mapScaleLevel<=3000){
            queryLocAttrib="location"
            queryRecord="ScaledArea4069"
        }else if(mapScaleLevel<=4000){
            queryLocAttrib="location"
            queryRecord="ScaledArea4069"
        }else if(mapScaleLevel<=5000){
            queryLocAttrib="location"
            queryRecord="ScaledArea16384"
        }else if(mapScaleLevel<=6000){
            queryLocAttrib="location"
            queryRecord="ScaledArea65536"
        }else if(mapScaleLevel<=7000){
            queryLocAttrib="location"
            queryRecord="ScaledArea262144"
        }else if(mapScaleLevel<=8000){
            queryLocAttrib="location"
            queryRecord="ScaledArea262144"
        }else if(mapScaleLevel<=9000){
            queryLocAttrib="location"
            queryRecord="ScaledArea262144"
        }else if(mapScaleLevel<=10000){
            queryLocAttrib="location"
            queryRecord="ScaledArea1048576"
        }else if(mapScaleLevel<=11000){
            queryLocAttrib="location"
            queryRecord="ScaledArea1048576"
        }else {
            queryLocAttrib="location"
            queryRecord="ScaledArea1048576"
            
        }
        
        println("Searching against  \(queryRecord)  attribute \(queryLocAttrib)")
        
        
        var pred=NSPredicate(format:"distanceToLocation:fromLocation:(\(queryLocAttrib), %@) < %f",CLLocation(latitude: loc2dlat, longitude: loc2dlon),currentDist)
        var query=CKQuery(recordType: queryRecord, predicate: pred)
        
        query.sortDescriptors = [CKLocationSortDescriptor(key: queryLocAttrib, relativeLocation: myLoc!)]
        var pubDB=CKContainer.defaultContainer().publicCloudDatabase;
        var request : CKQueryOperation = CKQueryOperation(query: query)
        
        request.queryCompletionBlock = {
            (cursor:CKQueryCursor!, error:NSError!) in
            if var err = error {
                var av=UIAlertView(title: "Error", message: "Cannot get information at this time \(err.description)", delegate: nil, cancelButtonTitle: "Close")
                av.show()
            } else if var curs=cursor {
                dispatch_async(dispatch_get_main_queue(), {
                    self.continueQuery(curs)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.stopSpinner()
                })
            }
        }
        
        request.recordFetchedBlock = {
            (r:CKRecord!) in
            if var startloc:CLLocation = r.objectForKey("startloc") as? CLLocation{
                var annot = MKSupPointAnnotation()
                var loc2d = CLLocationCoordinate2D(latitude: startloc.coordinate.latitude, longitude: startloc.coordinate.longitude )
                annot.id=r.recordID
                annot.coordinate = loc2d
                annot.title="route"
                annot.title="route subtitle"
                dispatch_async(dispatch_get_main_queue(), {
                    self.addAnnotation(annot)
                })
            }else if var startloc:CLLocation = r.objectForKey("location") as? CLLocation{
                var annot = MKSupPointAnnotation()
                var loc2d = CLLocationCoordinate2D(latitude: startloc.coordinate.latitude, longitude: startloc.coordinate.longitude )
                annot.id=r.recordID
                annot.coordinate = loc2d
                annot.title="Group"
                annot.isGroup=true
                annot.title="Grouping"
                dispatch_async(dispatch_get_main_queue(), {
                    self.addAnnotation(annot)
                })
                
            }
            count++;
            //println("Found record number \(count)")
        }
        pubDB.addOperation(request)
    }
    
    func continueQuery(cursor:CKQueryCursor){
        var request : CKQueryOperation = CKQueryOperation(cursor: cursor)
        request.queryCompletionBlock = {
            (cursor:CKQueryCursor!, error:NSError!) in
            if var err = error {
                var av=UIAlertView(title: "Error", message: "Cannot get information at this time \(err.description)", delegate: nil, cancelButtonTitle: "Close")
                av.show()
            } else if var curs=cursor {
                dispatch_async(dispatch_get_main_queue(), {
                    self.continueQuery(curs)
                    
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.stopSpinner()
                })
            }
        }
        
        request.recordFetchedBlock = {
            (r:CKRecord!) in
            if var startloc:CLLocation = r.objectForKey("startloc") as? CLLocation{
                var annot = MKSupPointAnnotation()
                var loc2d = CLLocationCoordinate2D(latitude: startloc.coordinate.latitude, longitude: startloc.coordinate.longitude )
                annot.id=r.recordID
                annot.coordinate = loc2d
                annot.title="route"
                annot.subtitle="route subtitle"
                dispatch_async(dispatch_get_main_queue(), {
                    self.addAnnotation(annot)
                })
            }else if var startloc:CLLocation = r.objectForKey("location") as? CLLocation{
                var annot = MKSupPointAnnotation()
                var loc2d = CLLocationCoordinate2D(latitude: startloc.coordinate.latitude, longitude: startloc.coordinate.longitude )
                annot.id=r.recordID
                annot.coordinate = loc2d
                annot.title="Group"
                annot.isGroup=true
                
                annot.subtitle="Grouping"
                dispatch_async(dispatch_get_main_queue(), {
                    self.addAnnotation(annot)
                })
                
            }

        }
        
        var pubDB=CKContainer.defaultContainer().publicCloudDatabase;
        pubDB.addOperation(request)
        
    }
    
    
    func stopSpinner(){
        if var aiv=ai{
            aiv.stopAnimating()
        }
    }

    func mapView(mapView: MKMapView!,
        rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer!{
            var polyLineView=MKPolylineRenderer(overlay: overlay)
            polyLineView.strokeColor = UIColor.blueColor();
            polyLineView.lineWidth = 2
            polyLineView.lineCap = kCGLineCapRound
            return polyLineView;
    }
    
    @IBAction func saveToCloud (sender:UIButton){
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        var error: NSError? = nil
        var currentPath:SavedSUPPath! = del.managedObjectContext!.existingObjectWithID(pathId!, error: &error) as SavedSUPPath!
        
        var records:NSArray!=currentPath.saveToCloudKit()
        if var recs=records{
            var scRecs:NSArray!=currentPath.generateScaleDetails()
            if var srecs=scRecs{
                del.queueRecordsToSaveToTheCloud(srecs)
            }

            del.queueRecordsToSaveToTheCloud(recs)
        }
        
    }
    func addAnnotation(annot:MKPointAnnotation){
        self.mapView.addAnnotation(annot)
    }
    func reloadMap()
    {
        self.mapView.setRegion(self.mapView.region,animated:false)
//        [map setRegion:map.region animated:TRUE];
    }
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        if var anno = view.annotation as? MKSupPointAnnotation{
            tappedid=anno.id
            self.performSegueWithIdentifier("ShowPathDetail", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if(segue.identifier == "ShowPathDetail"){
            let det = segue.destinationViewController as SUPOtherPathDetail
            det.recordId=self.tappedid!
            
            det.coordReg = self.mapView.region
        }
        NSLog("Prep for segue \(segue.destinationViewController.name)")
    }
    
    func mapView(mapView: MKMapView!, regionWillChangeAnimated animated: Bool) {
        var toRemove = NSMutableArray()
        for annotation in mapView.annotations{
            if var annot = annotation as? MKUserLocation{
            }else{
                toRemove.addObject(annotation)
            }
            
        }
        mapView.removeAnnotations(toRemove)
    }
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        if timer != nil {
            // stop any queued queriy from executing
            timer!.invalidate()
            timer=nil
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("updateData"), userInfo: nil, repeats: false)
        var m = mapScaleView.update()
        mapScaleLevel = NSNumber.numberWithInt(m).integerValue
        
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        var customPinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "SUPPathIdentifier")
        println("Adding anotation")
        if var an = annotation as? MKSupPointAnnotation {
            if(an.isGroup){
                customPinView.pinColor=MKPinAnnotationColor.Green
                customPinView.animatesDrop=true
                customPinView.canShowCallout=true
            }else{
                customPinView.pinColor=MKPinAnnotationColor.Purple
                customPinView.animatesDrop=true
                customPinView.canShowCallout=true
                var rightButton=UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton
                rightButton.addTarget(nil, action: nil, forControlEvents:UIControlEvents.TouchUpInside)
                customPinView.rightCalloutAccessoryView = rightButton as UIView
            }
        }else{
                customPinView.pinColor=MKPinAnnotationColor.Red
                customPinView.animatesDrop=true
                customPinView.canShowCallout=true
            
        }
        /*Selector("updateClock")
        UIImageView *myCustomImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MyCustomImage.png"]];
        customPinView.leftCalloutAccessoryView = myCustomImage;
        */
        return customPinView
    }
    /*- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
    {
    // Try to dequeue an existing pin view first (code not shown).
    
    // If no pin view already exists, create a new one.
    MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc]
    initWithAnnotation:annotation reuseIdentifier:BridgeAnnotationIdentifier];
    customPinView.pinColor = MKPinAnnotationColorPurple;
    customPinView.animatesDrop = YES;
    customPinView.canShowCallout = YES;
    
    // Because this is an iOS app, add the detail disclosure button to display details about the annotation in another view.
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
    customPinView.rightCalloutAccessoryView = rightButton;
    
    // Add a custom image to the left side of the callout.
    UIImageView *myCustomImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MyCustomImage.png"]];
    customPinView.leftCalloutAccessoryView = myCustomImage;
    
    return customPinView;
    }*/
    
}

