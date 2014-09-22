//
//  CoreDataHelpers.swift
//  WhatsSUP1
//
//  Created by Tim Teece on 02/07/2014.
//  Copyright (c) 2014 Tim Teece. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataEntities {
    case SavedSUPPath,SavedPathLocations
    func description() -> String {
        switch self {
        case .SavedSUPPath:
            return "SavedSUPPath"
        case .SavedPathLocations:
            return "SavedPathLocations"
        }
    }
}

//
//// FETCH REQUESTS
//

func myGeneralFetchRequest (entity : CoreDataEntities,
    property : SavedSUPPathPropertyList,
    context : NSManagedObjectContext) -> AnyObject[]?{
        
        let entityName = entity.description()
        let propertyName = property.description()
        
        let request :NSFetchRequest = NSFetchRequest(entityName: entityName)
        request.returnsObjectsAsFaults = false
        let sortDescriptor : NSSortDescriptor = NSSortDescriptor(key: propertyName, ascending: true)
        request.sortDescriptors = [sortDescriptor]
        var error: NSError? = nil
        var matches: NSArray = context.executeFetchRequest(request, error: &error)
        
        if matches.count > 0 {
            return matches
        }
        else {
            return nil
        }
}

func myNameFetchRequest (entity : CoreDataEntities,
    property : SavedSUPPathPropertyList,
    value : String,
    context : NSManagedObjectContext) -> AnyObject[]? {
        
        let entityName = entity.description()
        let propertyName = property.description()
        
        let request :NSFetchRequest = NSFetchRequest(entityName: entityName)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "\(propertyName) = %@", value)
        let sortDescriptor :NSSortDescriptor = NSSortDescriptor(key: propertyName, ascending: true)
        request.sortDescriptors = [sortDescriptor]
        var error: NSError? = nil
        var matches: NSArray = context.executeFetchRequest(request, error: &error)
        
        if matches.count > 0 {
            return matches
        }
        else {
            return nil
        }
}

//
//// PRINT FETCH REQUEST
//

func printFetchedArrayList (myarray:AnyObject[]) {
    if myarray.count > 0 {
        println("Has \(myarray.count) object")
        for myobject : AnyObject in myarray {
            var typename=object_getClassName(myobject)
/*            switch typename{
            case CoreDataEntities.SavedSUPPath.description:
                var anObject = myobject as SavedSUPPath
                    //var thename = anObject.name
                    //println(thename)
            
            case CoreDataEntities.SavedPathLocations.description:
                var anObject = myobject as SavedPathLocations
                
            }*/
        }
    }
    else {
        println("empty fetch")
    }
}
