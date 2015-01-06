//
//  LikedPost+Helper.m
//  GramManager
//
//  Created by Oliver Rodden on 01/10/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "LikedPost+Helper.h"
#import "ModelHelper.h"

@implementation LikedPost (Helper)

+ (LikedPost *)createWithPost:(Post*)post
{
    // Create a company
    LikedPost *newEntity = (LikedPost *)[ModelHelper createNewObjectForEntityName:@"LikedPost"];
    newEntity.postId=post.postId;
    newEntity.lowResURL=post.lowResURL;
    newEntity.standardResURL=post.standardResURL;
    newEntity.thumbnailURL=post.thumbnailURL;
    newEntity.userId=post.userId;
    newEntity.userName=post.userName;

//    [ModelHelper saveManagedObjectContext];
    
    return newEntity;
}

//+ (LikedPost *)getAppState
//{
//    NSError *error;
//    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"LikedPost"];
//    
//    // Run the query
//    NSArray *results = [MOC executeFetchRequest: request error:&error];
//    
//    return [results firstObject];
//}

@end
