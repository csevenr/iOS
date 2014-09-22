//
//  PersonalBests.m
//  WhatsSUP1
//
//  Created by Tim Teece on 05/09/2014.
//  Copyright (c) 2014 Tim Teece. All rights reserved.
//

#import "PersonalBests.h"
#import "SavedSUPPath.h"


@implementation PersonalBests

@dynamic totaldistance;
@dynamic longest;
@dynamic farthest;
@dynamic best1k;
@dynamic best5k;
@dynamic best10k;
@dynamic best1m;
@dynamic best5m;
@dynamic best10m;


-(void)addPathToRecords:(SavedSUPPath*)path{
    double newTotal=[self totaldistance].doubleValue + path.distance.doubleValue;
    [self setTotaldistance: [NSNumber numberWithDouble:newTotal]];
}
-(void)removePathFromRecords:(SavedSUPPath*)path{
    double newTotal=[self totaldistance].doubleValue - path.distance.doubleValue;
    [self setTotaldistance: [NSNumber numberWithDouble:newTotal]];
}

@end
