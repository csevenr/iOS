//
//  CKToCDMap.h
//  WhatsSUP1
//
//  Created by Tim Teece on 03/09/2014.
//  Copyright (c) 2014 Tim Teece. All rights reserved.
//

#ifndef WhatsSUP1_CKToCDMap_h
#define WhatsSUP1_CKToCDMap_h
#import <CoreData/CoreData.h>
#import <cloudkit/CloudKit.h>

@interface CKToCDMap : NSObject

@property (nonatomic,retain) NSManagedObject * cdRef;
@property (nonatomic,retain) CKRecord * ckRef;

@end

#endif
