//
//  SavedSUPPath.swift
//  WhatsSUP1
//
//  Created by Tim Teece on 01/07/2014.
//  Copyright (c) 2014 Tim Teece. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CoreLocation

enum SavedSUPPathPropertyList {
    case averageSpeed,date,distance,endLat,endLon,eventCount,maxLat,minLat,maxLon,minLon,rate,startLat,startLon,topAltitude,topSpeed,user,waveHeight,weather,windspeed
    func description() -> String {
        switch self {
        case .averageSpeed:
            return "averageSpeed"
        case .date:
            return "date"
        case .distance:
            return "distance"
        case .endLat:
            return "endLat"
        case .endLon:
            return "endLon"
        case .eventCount:
            return "eventCount"
        case .maxLat:
            return "maxLat"
        case .minLat:
            return "minLat"
        case .maxLon:
            return "maxLon"
        case .minLon:
            return "minLon"
        case .rate:
            return "rate"
        case .startLat:
            return "startLat"
        case .startLon:
            return "startLon"
        case .topAltitude:
            return "topAltitude"
        case .topSpeed:
            return "topSpeed"
        case .user:
            return "user"
        case .waveHeight:
            return "waveHeight"
        case .weather:
            return "weather"
        case .windspeed:
            return "windspeed"
        }
    }
}

@objc(SavedSUPPath)
class SavedSUPPath: NSManagedObject {
    
    @NSManaged var averageSpeed: Double
    @NSManaged var date: NSDate
    @NSManaged var distance: Double
    @NSManaged var endLat: Double
    @NSManaged var endLon: Double
    @NSManaged var eventCount: Int64
    @NSManaged var maxLat: Double
    @NSManaged var minLat: Double
    @NSManaged var maxLon: Double
    @NSManaged var minLon: Double
    @NSManaged var rate: Int16
    @NSManaged var startLat: Double
    @NSManaged var startLon: Double
    @NSManaged var topAltitude: Double
    @NSManaged var topSpeed: Double
    @NSManaged var user: String
    @NSManaged var waveHeight: Double
    @NSManaged var weather: Int16
    @NSManaged var windSpeed: Double
    @NSManaged var path:NSMutableOrderedSet?
    
    
    //
    //// CREATE CLASS OBJECT
    //
    
    class func createMyObject ( context: NSManagedObjectContext) -> SavedSUPPath? {
        let entityName = "SavedSUPPath"
        let entityDescription = NSEntityDescription.entityForName(entityName, inManagedObjectContext: context)
        var myObject : SavedSUPPath = SavedSUPPath(entity: entityDescription, insertIntoManagedObjectContext: context)
        myObject.eventCount = 0
        myObject.path = NSMutableOrderedSet()
        //myObject.name = value
        var error: NSError? = nil
        context.save(&error)
        println("ID of SavedSUPPath : \(myObject.objectID)")

        return myObject
        
    }
    
    func addPoint(loc: CLLocation){
        let del = UIApplication.sharedApplication().delegate as AppDelegate

        var ssp:SavedPathLocations = SavedPathLocations.createMyObject(loc, count: eventCount, context: del.managedObjectContext)!
        path?.addObject(ssp)
        var acount=eventCount
        acount++
        eventCount=acount
//        eventCount++;
        
    }
    

    /*
    class func createMyObject (propertyName:SavedSUPPathPropertyList, value:String, context: NSManagedObjectContext) -> SavedSUPPath? {
        if !value.isEmpty {
            let propertyType = propertyName.description()
            
            let entityName = "SavedSUPPath"
            let request : NSFetchRequest = NSFetchRequest(entityName: entityName)
            request.returnsObjectsAsFaults = false
            request.predicate = NSPredicate(format: "\(propertyType) = %@", value)
            var error: NSError? = nil
            var matches: NSArray = context.executeFetchRequest(request, error: &error)
            
            if (matches.count > 1) {
                // handle error
                return matches[0] as? SavedSUPPath
            } else if matches.count ==  0 {
                let entityDescription = NSEntityDescription.entityForName(entityName, inManagedObjectContext: context)
                var myObject : MyObject = SavedSUPPath(entity: entityDescription, insertIntoManagedObjectContext: context)
                myObject.name = value
                return myObject
            }
            else {
                println(matches[0])
                return matches[0] as? MyObject
            }
        }
        return nil
    }*/
    
    
    

    
}