//
//  TSavedPathLocation.m
//  WhatsSUP1
//
//  Created by Tim Teece on 04/09/2014.
//  Copyright (c) 2014 Tim Teece. All rights reserved.
//

#import "TSavedPathLocation.h"



@implementation TSavedPathLocation

- (id)init{
    if((self = [super init])){
        // do nothing
        [self setVersion: [[NSNumber alloc ] initWithDouble:1.0]] ;

    }
    return self;
}

/*- (id)initWithLocation:(SavedPathLocations *)aLoc{
    if((self = [self init]))
    {
        [self setAltitude: [aLoc altitude]] ;
        [self setDegrees: [aLoc degrees]] ;
        [self setDirection: [aLoc direction]] ;
        [self setHAcc: [aLoc hAcc]] ;
        [self setLat: [aLoc lat]] ;
        [self setLon: [aLoc lon]] ;
        [self setSpeed: [aLoc speed]] ;
        [self setStepNo: [aLoc stepNo]] ;
        [self setTotDistance: [aLoc totDistance]] ;
        [self setTimestamp: [aLoc timestamp]] ;
        [self setVAcc: [aLoc vAcc]] ;
        [self setVersion: [[NSNumber alloc ] initWithDouble:1.0]] ;
    }
    return self;
}*/

- (id)initWithCoder:(NSCoder *)aDecoder{
    if((self = [self init]))
    {
        [self setAltitude: [aDecoder decodeObjectForKey: @"altitude"]] ;
        [self setDegrees: [aDecoder decodeObjectForKey: @"degrees"]] ;
        [self setDirection: [aDecoder decodeObjectForKey: @"direction"]] ;
        [self setHAcc: [aDecoder decodeObjectForKey: @"hAcc"]] ;
        [self setLat: [aDecoder decodeObjectForKey: @"lat"]] ;
        [self setLon: [aDecoder decodeObjectForKey: @"lon"]] ;
        [self setSpeed: [aDecoder decodeObjectForKey: @"speed"]] ;
        [self setStepNo: [aDecoder decodeObjectForKey: @"stepNo"]] ;
        [self setTotDistance: [aDecoder decodeObjectForKey: @"totDistance"]] ;
        [self setTimestamp: [aDecoder decodeObjectForKey: @"timestamp"]] ;
        [self setVAcc: [aDecoder decodeObjectForKey: @"vAcc"]] ;
        [self setVersion: [aDecoder decodeObjectForKey: @"version"]] ;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject: [self altitude] forKey: @"altitude"];
    [aCoder encodeObject: [self degrees] forKey: @"degrees"];
    [aCoder encodeObject: [self direction] forKey: @"direction"];
    [aCoder encodeObject: [self hAcc] forKey: @"hAcc"];
    [aCoder encodeObject: [self lat] forKey: @"lat"];
    [aCoder encodeObject: [self lon] forKey: @"lon"];
    [aCoder encodeObject: [self speed] forKey: @"speed"];
    [aCoder encodeObject: [self stepNo] forKey: @"stepNo"];
    [aCoder encodeObject: [self totDistance] forKey: @"totDistance"];
    [aCoder encodeObject: [self timestamp] forKey: @"timestamp"];
    [aCoder encodeObject: [self vAcc] forKey: @"vAcc"];
    [aCoder encodeObject: [self version] forKey: @"version"];
}

@end
