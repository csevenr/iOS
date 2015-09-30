//
//  ModelHelper.h
//  Autodesk Value Discovery Tool
//
//  Created by dean on 11/11/2012.
//  Copyright (c) 2012 Dean Mortimer. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "AppDelegate.h"

#define MOC [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext]

@class Proposal;

@interface ModelHelper : NSObject 

+ (NSEntityDescription *) createNewObjectForEntityName:(NSString *)entityName;
+ (BOOL) saveManagedObjectContext;
+ (void) rollBack ;


@end