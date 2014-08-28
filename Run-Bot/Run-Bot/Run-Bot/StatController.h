//
//  StatController.h
//  Run-Bot
//
//  Created by Oliver Rodden on 06/06/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatController : NSObject

+(StatController*)sharedInstance;
+(void)test;
+(void)checkStat:(NSString*)stat withValue:(NSString*)value;

@end
