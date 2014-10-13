//
//  UserProfile.h
//  GramManager
//
//  Created by Oli Rodden on 10/10/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LikedPost;

@interface UserProfile : NSManagedObject

@property (nonatomic, retain) NSNumber * followerCount;
@property (nonatomic, retain) NSNumber * isActive;
@property (nonatomic, retain) NSNumber * likesInHour;
@property (nonatomic, retain) NSDate * likeTime;
@property (nonatomic, retain) NSString * profilePictureURL;
@property (nonatomic, retain) NSNumber * recentCount;
@property (nonatomic, retain) NSNumber * recentLikes;
@property (nonatomic, retain) NSString * token1;
@property (nonatomic, retain) NSString * token2;
@property (nonatomic, retain) NSString * token3;
@property (nonatomic, retain) NSString * token4;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSNumber * tokenCount;
@property (nonatomic, retain) NSSet *likedPosts;
@end

@interface UserProfile (CoreDataGeneratedAccessors)

- (void)addLikedPostsObject:(LikedPost *)value;
- (void)removeLikedPostsObject:(LikedPost *)value;
- (void)addLikedPosts:(NSSet *)values;
- (void)removeLikedPosts:(NSSet *)values;

@end
