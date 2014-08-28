//
//  StatController.m
//  Run-Bot
//
//  Created by Oliver Rodden on 06/06/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "StatController.h"
#import "AppDelegate.h"
#import "RunBotConstants.h"

@implementation StatController
//singleton

+(StatController*)sharedInstance
{
    static dispatch_once_t pred;
    static StatController *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[StatController alloc] init];
    });
    return sharedInstance;
}

+(void)test{
    
}

+(void)checkStat:(NSString*)stat withValue:(NSString*)value{
    AppDelegate *appDel = [[UIApplication sharedApplication]delegate];
    NSLog(@"Stat: %@, value: %@",stat, value);
    if ([stat isEqualToString:BESTDISTANCE]||[stat isEqualToString:BESTTREES]) {
        if ([[appDel scratchPad]objectForKey:stat]<value) {
            [[appDel scratchPad]setObject:value forKey:stat];
        }
    }else if ([stat isEqualToString:TOTALDISTANCE]||[stat isEqualToString:TOTALTREES]||[stat isEqualToString:TOTALTIME]){
//        [[appDel scratchPad]setObject:[NSString stringWithFormat:@"%@",[[appDel scratchPad]objectForKey:stat]]];
        
    }
#ifdef EXTREME
    else if ([stat isEqualToString:BESTCOINS]||[stat isEqualToString:BESTMISSEDCOINS]){
        if ([[appDel scratchPad]objectForKey:stat]<value) {
            [[appDel scratchPad]setObject:value forKey:stat];
        }
    }else if ([stat isEqualToString:TOTALCOINS]||[stat isEqualToString:TOTALMISSEDCOINS]||[stat isEqualToString:CURRENTCOINS]){
        [[appDel scratchPad]setObject:[[appDel scratchPad]objectForKey:stat]+=value forKey:Stat];
    }

    
#endif
}

+(void)checkMultipleStats:(NSDictionary*)stats{
    for (NSString *stat in stats) {
        [self checkStat:stat withValue:[stats valueForKey:stat]];
    }
}

@end
