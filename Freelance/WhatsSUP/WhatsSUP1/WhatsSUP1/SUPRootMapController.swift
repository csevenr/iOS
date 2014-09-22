//
//  SUPRootMapController.swift
//  WhatsSUP1
//
//  Created by Tim Teece on 13/09/2014.
//  Copyright (c) 2014 Tim Teece. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit
import Accounts
import Social

class SUPRootMapController: SUPRootController, MKMapViewDelegate{
    var colours:[UIColor ] =  [UIColor]()
    var mapScaleView:LXMapScaleView!;
    var speedBands:[Double] = [Double]()
    var numSpeedBands=10
    var mapImage:NSData?=nil
    // this is the cache of information should you want to post this to facebook its really there just to create the image.
    var startLoc2D:CLLocationCoordinate2D?=nil
    var endLoc2D:CLLocationCoordinate2D?=nil
    var colourLineMaps:[NSNumber]=[NSNumber]() // this is an aray of the colours for the path as you go through.
    var pathLoc2ds:[CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    
    // if these are true then do the appropriate post when you get there.
    var doPostToTwitter = false
    var doPostToFacebook = false
    
    
    @IBOutlet var mapView : MKMapView!
    @IBOutlet var ai :UIActivityIndicatorView!
    @IBOutlet var accuracyBar :UIProgressView!
    @IBOutlet var avSpeedLabel :UILabel!
    @IBOutlet var topAltLabel :UILabel!
    @IBOutlet var distanceLabel :UILabel!
    @IBOutlet var durationLabel :UILabel!
    @IBOutlet var saveToCloud :UIButton!
    @IBOutlet var rating :UISegmentedControl!
    @IBOutlet var topSpeedLabel :UILabel!

    
    // used for CoreData Paths
    var pathId : NSManagedObjectID?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        mapScaleView = LXMapScaleView.mapScaleForMapView(mapView)
        mapScaleView.showSpeedScale=true
        mapScaleView.topSpeedUnits = getUnitsSpeedString()
        mapScaleView.distanceUnits = getUnitsString()
        mapScaleView.minorDistanceUnits = getMinorUnitsString()
        mapView.mapType = MKMapType.Standard
        mapView.delegate=self
        mapView.showsUserLocation=true
        
        
        // initialise the colours for the segments
        colours.append(UIColor(red: 142.0/255.0, green: 1.0/255.0, blue: 82.0/255.0, alpha: 0.8))
        colours.append(UIColor(red: 197.0/255.0, green: 27.0/255.0, blue: 125.0/255.0, alpha: 0.8))
        colours.append(UIColor(red: 222.0/255.0, green: 119.0/255.0, blue: 174.0/255.0, alpha: 0.8))
        colours.append(UIColor(red: 241.0/255.0, green: 182.0/255.0, blue: 218.0/255.0, alpha: 0.8))
        colours.append(UIColor(red: 253.0/255.0, green: 224.0/255.0, blue: 239.0/255.0, alpha: 0.8))
        colours.append(UIColor(red: 230.0/255.0, green: 245.0/255.0, blue: 208.0/255.0, alpha: 1.0))
        colours.append(UIColor(red: 184.0/255.0, green: 225.0/255.0, blue: 134.0/255.0, alpha: 1.0))
        colours.append(UIColor(red: 127.0/255.0, green: 188.0/255.0, blue: 65.0/255.0, alpha: 1.0))
        colours.append(UIColor(red: 77.0/255.0, green: 146.0/255.0, blue: 33.0/255.0, alpha: 1.0))
        colours.append(UIColor(red: 39.0/255.0, green: 100.0/255.0, blue: 25.0/255.0, alpha: 1.0))
    }
    
    func mapView(mapView: MKMapView!,
        rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer!{
            var polyLineView=MKPolylineRenderer(overlay: overlay)
            
            if var lOverLay = overlay {
                if let num=lOverLay.title!.toInt(){
                    polyLineView.strokeColor = colours[num]
                }else{
                    polyLineView.strokeColor = UIColor.blackColor()
                }
            }else{
                polyLineView.strokeColor = UIColor.blackColor()
            }
            
            polyLineView.lineWidth = 2
            polyLineView.lineCap = kCGLineCapRound
            return polyLineView;
    }
    
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
    
    func showCoreDataPath(currentPath: SavedSUPPath){
        var hexLocs:[CLLocationCoordinate2D ] =  [CLLocationCoordinate2D ]()
        var shortHexLocs:[CLLocationCoordinate2D ] =  [CLLocationCoordinate2D ]()

        if var tmp=topSpeedLabel{
            tmp.text=formatSpeedToNDP(currentPath.topSpeed.doubleValue, toDP:2)
        }
        if var tmp=topAltLabel{
            tmp.text=formatDistanceToNDP(currentPath.topAltitude.doubleValue, toDP:2)
        }
        if var tmp=distanceLabel{
            tmp.text=formatDistanceToNDP(currentPath.distance.doubleValue, toDP:2)
        }
        if var tmp=durationLabel{
            tmp.text=currentPath.getDurationFormatted()
        }
        if var tmp=avSpeedLabel{
            tmp.text=formatSpeedToNDP(currentPath.getAverageSpeed().doubleValue, toDP:2)
        }
        if var tmp=mapScaleView{
            tmp.topSpeedUnits = getUnitsSpeedString()
        }
        if var tmp=mapScaleView{
            tmp.topSpeedString = formatSpeedToNDP(currentPath.topSpeed.doubleValue,toDP:2)
        }
    
        // need to load up the mapkit and put the path on it.
        
        var minRegionLat=0.00725
        var minRegionLon=0.00725
        
        for  x in 1...numSpeedBands{
            // println(cp.topSpeed.doubleValue)
            var maxBandSpeed=Double(x) * (currentPath.topSpeed.doubleValue/Double(numSpeedBands))
            // println(maxBandSpeed)
            speedBands.append(maxBandSpeed)
        }
        
        // this tracks the current speed band we are in
        var currentSpeedBand = -1
        
        if var coordArray = currentPath.getOrderedPath() {
            var count=0
            var lastLoc:CLLocationCoordinate2D? = nil
            
            
            for tmp in coordArray {
                var coord:TSavedPathLocation = tmp as TSavedPathLocation
                
                var lat: Double = coord.lat.doubleValue
                var lon: Double = coord.lon.doubleValue
                
                var loc2d = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                
                var thisSpeedBand=0
                // work out which speedBand we are in
                for x in 0...(numSpeedBands-1){
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
                        startLoc2D=loc2d
                        self.mapView.addAnnotation(annot)
                    }
                    currentSpeedBand = thisSpeedBand
                }
                
                colourLineMaps.append(currentSpeedBand) // ensure we have a list of the color bands
                pathLoc2ds.append(loc2d) // and this is the path

                
                shortHexLocs.append(loc2d)
                lastLoc = loc2d
                endLoc2D = loc2d
                hexLocs.append(loc2d)
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
        mapView.delegate=self
        var pathOverlay=MKPolyline(coordinates: &hexLocs, count: hexLocs.count)
        //mapView.addOverlay(pathOverlay)
        mapView.setVisibleMapRect(pathOverlay.boundingMapRect, animated: true)
        
        hexLocs.removeAll(keepCapacity: false) // destroy the reference to the hexLocs array as we no longer need them
        shortHexLocs.removeAll(keepCapacity: false)

    }
    
    func postToTwitter(){
        // set the post to twitter flag and then cal render map to do the posting
        doPostToTwitter = true
        renderMapImage()
    }
    
    func callbackPostToTwitter(){
        var accountStore:ACAccountStore = ACAccountStore()
        var accountTypeTwitter:ACAccountType?=nil

        if !self.doPostToTwitter {
            return
        }
        accountTypeTwitter=accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(accountTypeTwitter!, options: nil) { (granted:Bool, error:NSError!) -> Void in
            if var err=error {
                println("Error connecting to twitter \(error.description)")
            }else{
                if(granted == true){
                    if var arrayOfAccounts:NSArray=accountStore.accountsWithAccountType(accountTypeTwitter){
                        if arrayOfAccounts.count > 0{
                            // pick the last one to use
                            if var account:ACAccount=arrayOfAccounts.lastObject as? ACAccount{
                                var message:NSMutableDictionary = NSMutableDictionary()
                                message.setValue("A post from ios 8", forKey: "status")
                                
                                var requestURL:NSURL = NSURL.URLWithString("https://api.twitter.com/1.1/statuses/update_with_media.json")
                                var postRequest:SLRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.POST, URL: requestURL, parameters: message)
                                
                                postRequest.account = account;
                                postRequest.addMultipartData(self.mapImage, withName: "media[]", type: "image/png", filename: "image.png")


                                postRequest.performRequestWithHandler({ (data:NSData!, response:NSHTTPURLResponse!, error:NSError!) -> Void in
                                    if var err=error{
                                        println("Error posting to twitter \(error.description)")
                                    }else{
                                        if var resp=response {
                                            println("Twitter HTTP response \(resp.statusCode)")
                                        }
                                    }
                                })
                            }
                        }
                    }
                }else{
                    println("Could not log into twitter")
                }
            }
        }
    }
    
    func postToFacebook(){
        // set the post to face flag and then cal render map to do the posting
        doPostToFacebook = true
        renderMapImage()
    }

    func callbackPostToFacebook(){
        var accountStore:ACAccountStore = ACAccountStore()
        var accountTypeFacebook:ACAccountType?=nil
        
        if !self.doPostToFacebook {
            return
        }
        
        accountTypeFacebook=accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierFacebook)

        var optionsRead:NSMutableDictionary = NSMutableDictionary()
        optionsRead.setValue("1502241743355198", forKey: ACFacebookAppIdKey)
        var optionArrayRead = ["email","basic_info"]
        optionsRead.setValue(optionArrayRead, forKey:ACFacebookPermissionsKey)
        optionsRead.setValue(ACFacebookAudienceEveryone, forKey:ACFacebookAudienceKey)
        
        
        accountStore.requestAccessToAccountsWithType(accountTypeFacebook!, options: optionsRead) { (granted:Bool, error:NSError!) -> Void in
            if var err=error {
                println("Error connecting to facebook \(error.description)")
            }else{
                if(granted == true){
                    
                    var options:NSMutableDictionary = NSMutableDictionary()
                    options.setValue("1502241743355198", forKey: ACFacebookAppIdKey)
                    var optionArray = ["publish_actions"]
                    options.setValue(optionArray, forKey:ACFacebookPermissionsKey)
                    options.setValue(ACFacebookAudienceEveryone, forKey:ACFacebookAudienceKey)
                    
                    
                    accountStore.requestAccessToAccountsWithType(accountTypeFacebook!, options: options) { (granted:Bool, error:NSError!) -> Void in
                        if var err=error {
                            println("Error connecting to facebook \(error.description)")
                        }else{
                            if(granted == true){
                                // we have access to facebook
                                if var arrayOfAccounts:NSArray=accountStore.accountsWithAccountType(accountTypeFacebook){
                                    if arrayOfAccounts.count > 0{
                                        // pick the last one to use
                                        if var account:ACAccount=arrayOfAccounts.lastObject as? ACAccount{
                                            
                                            var message:NSMutableDictionary = NSMutableDictionary()
                                            message.setValue("A post from ios8 test", forKey: "message")
                                            message.setValue(account.credential.oauthToken, forKey: "access_token")
                                            
                                            var requestURL:NSURL = NSURL.URLWithString("https://graph.facebook.com/me/photos")
                                            var postRequest:SLRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.POST, URL: requestURL, parameters: message)
                                            
                                           // var screenshots = UIImage(contentsOfFile:NSBundle.mainBundle().pathForResource("nspelements", ofType: "png")!)
//                                            UIImage *screenshot= [UIImage imageAtPath:
//                                                [[NSBundle mainBundle] pathForResource:@"nspelements" ofType:@"png"]];
                                         //   NSData *myData = UIImagePNGRepresentation(screenshot);
                                           // var myData=UIImagePNGRepresentation(screenshots)
                                            postRequest.addMultipartData(self.mapImage, withName: "source", type: "multipart/form-data", filename: "boardimage")
                                            //postRequest.account = account;
                                            /*[facebookRequest addMultipartData: myImageData
                                            withName:@"source"
                                            type:@"multipart/form-data"
                                            filename:@"TestImage"];
                                            */
                                            postRequest.performRequestWithHandler({ (data:NSData!, response:NSHTTPURLResponse!, error:NSError!) -> Void in
                                                if var err=error{
                                                    println("Error posting to facebook \(error.description)")
                                                }else{
                                                    if var resp=response {
                                                        println("Facebook HTTP response \(resp.statusCode) \(response.description)")
                                                    }
                                                }
                                            })
                                        }
                                    }
                                }
                            }else{
                                println("Could not log into facebook pubish")
                            }
                        }
                    }
                }else{
                    println("Could not log into facebook read")
                }
            }
        }
    }
    
    // this save the map image to a file and returns the file name it's stored as
    func renderMapImage() -> NSData?{
        if var mifn = mapImage{
            return mifn
        }else{
            // create the image
            var options:MKMapSnapshotOptions = MKMapSnapshotOptions()
            options.region = self.mapView!.region
            options.scale = 2
            options.size = self.mapView.frame.size

            var snapshotter:MKMapSnapshotter=MKMapSnapshotter(options: options)
            var queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)
            
            snapshotter.startWithQueue(queue, completionHandler: { (snapshot:MKMapSnapshot!, error:NSError!) -> Void in
                if var err=error{
                    println("error returned : \(err.description)")
                }else{
                    var image:UIImage = snapshot.image
                    var finalImageRect:CGRect = CGRectMake(0, 0, image.size.width, image.size.height)
                    var startpin:MKPinAnnotationView=MKPinAnnotationView()
                    startpin.pinColor=MKPinAnnotationColor.Green
                    var startpinImage:UIImage=startpin.image
                    var endpin:MKPinAnnotationView=MKPinAnnotationView()
                    endpin.pinColor=MKPinAnnotationColor.Purple
                    var endpinImage:UIImage=endpin.image
                    
                    
                    UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale)
                    image.drawAtPoint(CGPointMake(0, 0)) // the snapshotted image
                    
                    // draw the pins
                    if let sp=self.startLoc2D{
                        var point = snapshot.pointForCoordinate(sp)
                        if CGRectContainsPoint(finalImageRect, point){
                            var pinCenterOffSet = startpin.centerOffset
                            point.x -= startpin.bounds.size.width / 2.0
                            point.y -= startpin.bounds.size.height / 2.0
                            point.x += pinCenterOffSet.x
                            point.y += pinCenterOffSet.y
                            startpinImage.drawAtPoint(point)
                        }
                    }
                    if let sp=self.endLoc2D{
                        var point = snapshot.pointForCoordinate(sp)
                        if CGRectContainsPoint(finalImageRect, point){
                            var pinCenterOffSet = endpin.centerOffset
                            point.x -= endpin.bounds.size.width / 2.0
                            point.y -= endpin.bounds.size.height / 2.0
                            point.x += pinCenterOffSet.x
                            point.y += pinCenterOffSet.y
                            endpinImage.drawAtPoint(point)
                        }
                    }
                    
/*
                    for annotation:MKAnnotation in self.mapView.annotations as [MKAnnotation] {
                        var point = snapshot.pointForCoordinate(annotation.coordinate)
                        if CGRectContainsPoint(finalImageRect, point){
                            var pinCenterOffSet = pin.centerOffset
                            point.x -= pin.bounds.size.width / 2.0
                            point.y -= pin.bounds.size.height / 2.0
                            point.x += pinCenterOffSet.x
                            point.y += pinCenterOffSet.y
                            pinImage.drawAtPoint(point)
                        }
                    }
                    */
                    // add the path
                    // assuming we have the points in the array still
                    var i = 0
                    var context:CGContextRef = UIGraphicsGetCurrentContext()
                    var currentColIndex = -1
                    var curcolour:UIColor=UIColor.whiteColor() // just a default

                    for pt in self.pathLoc2ds{
                        var point:CGPoint = snapshot.pointForCoordinate(pt)

                        if self.colourLineMaps[i].integerValue==currentColIndex{
                            CGContextAddLineToPoint(context,point.x, point.y);
                        }else{
                            
                            if(i==0){
                                currentColIndex=self.colourLineMaps[i].integerValue
                                CGContextSetStrokeColorWithColor(context, self.colours[currentColIndex].CGColor)
                                CGContextSetLineWidth(context,2.0);
                                CGContextBeginPath(context);
                                CGContextSetLineCap(context, kCGLineCapRound)

                                CGContextMoveToPoint(context,point.x, point.y);
                            }else{
                                // draw the existing line
                                CGContextAddLineToPoint(context,point.x, point.y);
                                CGContextStrokePath(context);
                                currentColIndex=self.colourLineMaps[i].integerValue
                                CGContextSetStrokeColorWithColor(context, self.colours[currentColIndex].CGColor)
                                CGContextSetLineWidth(context,2.0);
                                CGContextSetLineCap(context, kCGLineCapRound)
                                CGContextBeginPath(context);
                                CGContextMoveToPoint(context,point.x, point.y);
                            }
                        }
                        i++
                    }
                    // draw the final piece of the line
                    CGContextStrokePath(context);
                    
                    var finalImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    
                    //self.mapImageFileName=CompressionUtils.tmpFile()
                    self.mapImage=UIImagePNGRepresentation(finalImage)
                    //data.writeToFile(self.mapImageFileName!,atomically:true);
                    
                    self.callbackPostToFacebook()
                    self.callbackPostToTwitter()
                }
            })
            
        }
        return self.mapImage
    }
    /*
    
    MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
    options.region = self.mapView.region;
    options.scale = [UIScreen mainScreen].scale;
    options.size = self.mapView.frame.size;
    
    MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    [snapshotter startWithQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) completionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
    
    // get the image associated with the snapshot
    
    UIImage *image = snapshot.image;
    
    // Get the size of the final image
    
    CGRect finalImageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Get a standard annotation view pin. Clearly, Apple assumes that we'll only want to draw standard annotation pins!
    
    MKAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:@""];
    UIImage *pinImage = pin.image;
    
    // ok, let's start to create our final image
    
    UIGraphicsBeginImageContextWithOptions(image.size, YES, image.scale);
    
    // first, draw the image from the snapshotter
    
    [image drawAtPoint:CGPointMake(0, 0)];
    
    // now, let's iterate through the annotations and draw them, too
    
    for (id<MKAnnotation>annotation in self.mapView.annotations)
    {
    CGPoint point = [snapshot pointForCoordinate:annotation.coordinate];
    if (CGRectContainsPoint(finalImageRect, point)) // this is too conservative, but you get the idea
    {
    CGPoint pinCenterOffset = pin.centerOffset;
    point.x -= pin.bounds.size.width / 2.0;
    point.y -= pin.bounds.size.height / 2.0;
    point.x += pinCenterOffset.x;
    point.y += pinCenterOffset.y;
    
    [pinImage drawAtPoint:point];
    }
    }
    
    // grab the final image
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // and save it
    
    NSData *data = UIImagePNGRepresentation(finalImage);
    [data writeToFile:[self snapshotFilename] atomically:YES];
    }];*/
    

}
