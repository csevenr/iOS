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

+ (UserProfile *)getUserProfile
{
    NSError *error;
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"UserProfile"];
    
    // Run the query
    NSArray *results = [MOC executeFetchRequest: request error:&error];
    
    return [results firstObject];
}

@end
