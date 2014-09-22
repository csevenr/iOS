//
//  AppSettings.h
//  WhatsSUP1
//
//  Created by Tim Teece on 10/07/2014.
//  Copyright (c) 2014 Tim Teece. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AppSettings : NSManagedObject

@property (nonatomic, retain) NSNumber * usemiles;
@property (nonatomic, retain) NSNumber * usemagneticnorth;
@property (nonatomic, retain) NSNumber * posttofacebook;
@property (nonatomic, retain) NSNumber * posttotwitter;
@property (nonatomic, retain) NSNumber * startdelay;
@property (nonatomic, assign) BOOL  autoPostToCloud;
@property (nonatomic, assign) BOOL  useCloudStorage;

@end
