//
//  UserProfile.h
//  GramManager
//
//  Created by Oliver Rodden on 08/10/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LikedPost;

@interface UserProfile : NSManagedObject

@property (nonatomic, retain) NSNumber * isActive;
@property (nonatomic, retain) NSDate * likeTime;
@property (nonatomic, retain) NSString * token1;
@property (nonatomic, retain) NSString * token2;
@property (nonatomic, retain) NSString * token3;
@property (nonatomic, retain) NSString * token4;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSNumber * likesInHour;
@property (nonatomic, retain) NSSet *likedPosts;
@end

@interface UserProfile (CoreDataGeneratedAccessors)

- (void)addLikedPostsObject:(LikedPost *)value;
- (void)removeLikedPostsObject:(LikedPost *)value;
- (void)addLikedPosts:(NSSet *)values;
- (void)removeLikedPosts:(NSSet *)values;

@end
