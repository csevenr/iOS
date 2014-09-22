//
//  ScaleSaver.h
//  WhatsSUP1
//
//  Created by Tim Teece on 10/09/2014.
//  Copyright (c) 2014 Tim Teece. All rights reserved.
//

#ifndef WhatsSUP1_ScaleSaver_h
#define WhatsSUP1_ScaleSaver_h
#import <cloudkit/CloudKit.h>

@interface ScaleSaver : NSObject


@property (nonatomic,assign) double scale; // the scale of the grid
@property (nonatomic,assign) double gridX; // the xpos of the grid cell
@property (nonatomic,assign) double gridY; // the ypos of the grid cell
@property (nonatomic,retain) CLLocation * location; // the location of the actual location

@end

#endif
