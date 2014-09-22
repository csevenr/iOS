//
//  SavedPathLocations.swift
//  WhatsSUP1
//
//  Created by Tim Teece on 01/07/2014.
//  Copyright (c) 2014 Tim Teece. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CoreLocation

enum SavedPathLocationsPropertyList {
    case altitude,degrees,direction,hAcc,lat,lon,speed,stepNo,timestamp,vAcc,inPath
    func description() -> String {
        switch self {
        case .altitude:
            return "altitude"
        case .degrees:
            return "degrees"
        case .direction:
            return "direction"
        case .hAcc:
            return "hAcc"
        case .lat:
            return "lat"
        case .lon:
            return "lon"
        case .speed:
            return "speed"
        case .stepNo:
            return "stepNo"
        case .timestamp:
            return "timestamp"
        case .vAcc:
            return "vAcc"
        case .inPath:
            return "inPath"
        }
    }
}

@objc(SavedPathLocations)
class SavedPathLocations: NSManagedObject {
    
    @NSManaged var altitude: Double
    @NSManaged var degrees: Double
    @NSManaged var direction: Double
    @NSManaged var hAcc: Double
    @NSManaged var lat: Double
    @NSManaged var lon: Double
    @NSManaged var speed: Double
    @NSManaged var stepNo: Int64
    @NSManaged var timestamp: NSDate
    @NSManaged var vAcc: Double
    @NSManaged var inPath: SavedSUPPath?
    
    
    //
    //// CREATE CLASS OBJECT
    //
    
    
    class func createMyObject (location:CLLocation, count: Int64, context: NSManagedObjectContext) -> SavedPathLocations? {
        //   let propertyType = propertyName.description()
        let entityName = "SavedPathLocations"
        let entityDescription = NSEntityDescription.entityForName(entityName, inManagedObjectContext: context)
        var myObject : SavedPathLocations = SavedPathLocations(entity: entityDescription, insertIntoManagedObjectContext: context)
        println(location.altitude)
        
        myObject.stepNo=count
        myObject.direction=location.course
        myObject.hAcc=location.horizontalAccuracy
        myObject.vAcc=location.verticalAccuracy
        if (myObject.vAcc > 0 && myObject.vAcc < 20){
            myObject.altitude=location.altitude
        }
        if (myObject.hAcc > 0 && myObject.hAcc < 20){
            myObject.lat=location.coordinate.longitude
            myObject.lon=location.coordinate.longitude
        }
        myObject.speed=location.speed
        myObject.timestamp=location.timestamp
        var error: NSError? = nil
        context.save(&error)
        println("ID of SavedPathLocations : \(myObject.objectID)")
        return myObject
    }
    
    
/*
    
    class func createMyObject (location:CLLocation, context: NSManagedObjectContext) -> SavedPathLocations? {
     //   let propertyType = propertyName.description()
        
        let entityName = "SavedPathLocations"
        let request : NSFetchRequest = NSFetchRequest(entityName: entityName)
        request.returnsObjectsAsFaults = false
      //  request.predicate = NSPredicate(format: "\(propertyType) = %@", value)
        var error: NSError? = nil
        var matches: NSArray = context.executeFetchRequest(request, error: &error)
        
        if (matches.count > 1) {
            // handle error
            return matches[0] as? SavedPathLocations
        } else if matches.count ==  0 {
            let entityDescription = NSEntityDescription.entityForName(entityName, inManagedObjectContext: context)
            var myObject : SavedPathLocations = SavedPathLocations(entity: entityDescription, insertIntoManagedObjectContext: context)
            myObject.name = value
            return myObject
        }
        else {
            println(matches[0])
            return matches[0] as? SavedPathLocations
        }
 
    }*/
}
