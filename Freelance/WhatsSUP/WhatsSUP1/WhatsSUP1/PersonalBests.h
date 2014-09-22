//
//  PersonalBests.h
//  WhatsSUP1
//
//  Created by Tim Teece on 05/09/2014.
//  Copyright (c) 2014 Tim Teece. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SavedSUPPath;

@interface PersonalBests : NSManagedObject

@property (nonatomic, retain) NSNumber * totaldistance;
@property (nonatomic, retain) SavedSUPPath *longest;
@property (nonatomic, retain) SavedSUPPath *farthest;
@property (nonatomic, retain) SavedSUPPath *best1k;
@property (nonatomic, retain) SavedSUPPath *best5k;
@property (nonatomic, retain) SavedSUPPath *best10k;
@property (nonatomic, retain) SavedSUPPath *best1m;
@property (nonatomic, retain) SavedSUPPath *best5m;
@property (nonatomic, retain) SavedSUPPath *best10m;

-(void)addPathToRecords:(SavedSUPPath*)path;
-(void)removePathFromRecords:(SavedSUPPath*)path;

@end
