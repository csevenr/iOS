//
//  AppDelegate.h
//  PictureAMinute
//
//  Created by Oliver Rodden on 16/12/2013.
//  Copyright (c) 2013 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) NSMutableDictionary *scratchPad;

-(void)saveNSMutableDictionary:(NSMutableDictionary*)data forKey:(NSString*)key;

@end
