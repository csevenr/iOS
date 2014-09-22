//
//  TSavedPathLocation.h
//  WhatsSUP1
//
//  Created by Tim Teece on 04/09/2014.
//  Copyright (c) 2014 Tim Teece. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "SavedPathLocations.h"
#import <cloudkit/CloudKit.h>

@interface TSavedPathLocation : NSObject <NSCoding>


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
@property (nonatomic, retain) NSNumber * version; // data structure version... important in the future...

- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;
//- (id)initWithLocation:(SavedPathLocations *)aLoc;

@end
