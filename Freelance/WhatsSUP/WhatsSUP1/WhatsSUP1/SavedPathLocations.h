//
//  SavedPathLocations.h
//  WhatsSUP1
//
//  Created by Tim Teece on 03/07/2014.
//  Copyright (c) 2014 Tim Teece. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <cloudkit/CloudKit.h>
#import "CKtoCDMap.h"

@class SavedSUPPath;

@interface SavedPathLocations : NSManagedObject

@property (nonatomic, retain) NSNumber * altitude;
@property (nonatomic, retain) NSNumber * degrees;
@property (nonatomic, retain) NSNumber * direction;
@property (nonatomic, retain) NSNumber * hAcc;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lon;
@property (nonatomic, retain) NSNumber * speed;
@property (nonatomic, retain) NSNumber * stepNo;
@property (nonatomic, retain) NSNumber * totDistance;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSNumber * vAcc;
@property (nonatomic, retain) SavedSUPPath *inPath;
@property (nonatomic, retain) NSString * cloudKitId;

- (CKToCDMap*) saveToCloudKit:(CKDatabase *)db addToPath:(CKRecordID*)pathId;

@end
