//
//  UserProfile+Helper.m
//  GramManager
//
//  Created by Oliver Rodden on 01/10/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "UserProfile+Helper.h"
#import "ModelHelper.h"

@implementation UserProfile (Helper)

+ (UserProfile *)create
{
    // Create a company
    UserProfile *newEntity = (UserProfile *)[ModelHelper createNewObjectForEntityName:@"UserProfile"];
    
    [ModelHelper saveManagedObjectContext];
    
    return newEntity;
}

+ (NSArray *)getUserProfiles
{
    NSError *error;
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"UserProfile"];
    
    // Run the query
    NSArray *results = [MOC executeFetchRequest: request error:&error];
    
    return results;
}

+ (UserProfile *)getActiveUserProfile
{
    NSError *error;
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"UserProfile"];
    
    // Run the query
    NSArray *results = [MOC executeFetchRequest: request error:&error];
    for (UserProfile *userProfile in results) {
        if ([userProfile.isActive boolValue]) {
            return userProfile;
        }
    }
    return nil;
}

+ (UserProfile *)getUserProfileWithUserName:(NSString*)userName
{
    NSError *error;
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"UserProfile"];
    
    // Run the query
    NSArray *results = [MOC executeFetchRequest: request error:&error];
    for (UserProfile *userProfile in results) {
        if ([userProfile.userName isEqualToString:userName]) {
            return userProfile;
        }
    }
    return nil;
}

+ (UserProfile *)getUserProfile
{
    NSError *error;
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"UserProfile"];
    
    // Run the query
    NSArray *results = [MOC executeFetchRequest: request error:&error];
    for (UserProfile *userProfile in results) {
        if ([userProfile.isActive boolValue]) {
            return userProfile;
        }else{
            return nil;
        }
    }
    return [results firstObject];
}

+(NSString*)getToken:(NSInteger)tokenNo{
    NSString *token;
    if (tokenNo==1) {
        token = [self getActiveUserProfile].token1;
    }else if (tokenNo==2){
        token = [self getActiveUserProfile].token2;
    }else if (tokenNo==3){
        token = [self getActiveUserProfile].token3;
    }else if (tokenNo==4){
        token = [self getActiveUserProfile].token4;
    }else{
        token = [self getActiveUserProfile].token1;
    }
    return token;
}

+(void)deactivateCurrentUserProfile{
    [self getActiveUserProfile].isActive=NO;
}

@end
