//
//  AppDelegate.m
//  Run-Bot
//
//  Created by Oliver Rodden on 18/02/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "AppDelegate.h"
#import "RunBotConstants.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //A dictionary use a temporary store
    NSMutableDictionary * localPad = [self getNSMutableDictionaryForString:RUNBOTSP];
    if(localPad==nil){
        //First time the game has been played so we need to create a new scratchPad
        _scratchPad = [NSMutableDictionary new];
        
        //Set up some standard defaults for this game, incase this is the first time the game has been played, delete app from device if more are added.
        
        [_scratchPad setObject:@"0" forKey:BESTDISTANCE];
        [_scratchPad setObject:@"0" forKey:TOTALDISTANCE];

        [_scratchPad setObject:@"0" forKey:BESTTREES];
        [_scratchPad setObject:@"0" forKey:TOTALTREES];

        [_scratchPad setObject:@"0" forKey:TOTALTIME];
        
#ifdef EXTREME
        [_scratchPad setObject:@"0" forKey:BESTCOINS];
        [_scratchPad setObject:@"0" forKey:TOTALCOINS];
        [_scratchPad setObject:@"0" forKey:CURRENTCOINS];
#endif
        
        // save the defaults to persistant storage for next time!
        [self saveNSMutableDictionary:_scratchPad forKey:RUNBOTSP];
    }else{
        //We read something in so use that
        _scratchPad = localPad;
    }
    return YES;
}

-(NSMutableDictionary*)getNSMutableDictionaryForString:(NSString*)key{
    //This comes back as a non-mutable dictionary
    NSDictionary *retrievedDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if(retrievedDictionary!=nil){
        return [retrievedDictionary mutableCopy];
    }else{
        return nil; //It was not set
    }
}

-(void)saveNSMutableDictionary:(NSMutableDictionary*)data forKey:(NSString*)key{
    [[NSUserDefaults standardUserDefaults] setObject:data  forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end