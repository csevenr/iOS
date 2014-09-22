//
//  SavedSUPPath.h
//  WhatsSUP1
//
//  Created by Tim Teece on 03/07/2014.
//  Copyright (c) 2014 Tim Teece. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TSavedPathLocation.h"
#import  "ScaleSaver.h"

@interface SavedSUPPath : NSManagedObject

@property (nonatomic, retain) NSNumber * averageSpeed;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, assign) BOOL inCloud;
@property (nonatomic, assign) BOOL inFaceBook;
@property (nonatomic, assign) BOOL inTwitter;
@property (nonatomic, assign) BOOL fullypostedtocloud;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * endLat;
@property (nonatomic, retain) NSNumber * endLon;
@property (nonatomic, retain) NSNumber * eventCount;
@property (nonatomic, retain) NSNumber * maxLat;
@property (nonatomic, retain) NSNumber * maxLon;
@property (nonatomic, retain) NSNumber * minLat;
@property (nonatomic, retain) NSNumber * minLon;
@property (nonatomic, retain) NSNumber * rate;
@property (nonatomic, retain) NSNumber * startLat;
@property (nonatomic, retain) NSNumber * startLon;
@property (nonatomic, retain) NSNumber * topAltitude;
@property (nonatomic, retain) NSNumber * topSpeed;
@property (nonatomic, retain) NSString * user;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * waveHeight;
@property (nonatomic, retain) NSNumber * weather;
@property (nonatomic, retain) NSNumber * windSpeed;
@property (nonatomic, retain) NSString * cloudKitId;
@property (nonatomic, retain) NSData * compressedPath;
@property (nonatomic, retain) NSMutableArray * uncompressedPath;
@property (nonatomic, retain) NSNumber * uncompressedLength;

@end

@interface SavedSUPPath (CoreDataGeneratedAccessors)
-(NSArray*)getOrderedPath;
-(void)initNew;
//- (void)insertObject:(SavedPathLocations *)value inPathAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPathAtIndex:(NSUInteger)idx;
- (void)insertPath:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePathAtIndexes:(NSIndexSet *)indexes;
//- (void)replaceObjectInPathAtIndex:(NSUInteger)idx withObject:(SavedPathLocations *)value;
- (void)replacePathAtIndexes:(NSIndexSet *)indexes withPath:(NSArray *)values;
-(void)addPathObject:(TSavedPathLocation *)value;
//- (void)removePathObject:(SavedPathLocations *)value;
- (void)addPath:(NSOrderedSet *)values;
- (void)removePath:(NSOrderedSet *)values;
- (NSNumber*)getAverageSpeed;
- (NSNumber*)getMinSpeed;
- (NSNumber*)getMaxSpeed;
-(void)complete;
- (int)getDuration;
- (NSString *)getDurationFormatted;
- (NSString *)getDurationToNowFormatted;
- (NSNumber*)getAverageSpeedOverDistance:(NSNumber*) distance forInterval:(NSNumber*)interval;
- (NSArray*) saveToCloudKit;
- (void) didSave;
-(ScaleSaver*)saveCLLocationAtScale:(double)scale ;
-(NSArray*)generateScaleDetails;
@end
