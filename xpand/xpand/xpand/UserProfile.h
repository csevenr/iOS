//
//  UserProfile.h
//  xpand
//
//  Created by Oliver Rodden on 04/03/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LikedPost;

@interface UserProfile : NSManagedObject

@property (nonatomic, retain) NSString * bio;
@property (nonatomic, retain) NSNumber * followers;
@property (nonatomic, retain) NSNumber * follows;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSNumber * isActive;
@property (nonatomic, retain) NSNumber * likesInHour;
@property (nonatomic, retain) NSDate * likeTime;
@property (nonatomic, retain) NSNumber * mediaCount;
@property (nonatomic, retain) NSData * profilePicture;
@property (nonatomic, retain) NSString * profilePictureURL;
@property (nonatomic, retain) NSNumber * recentCount;
@property (nonatomic, retain) NSData * recentHashtags;
@property (nonatomic, retain) NSNumber * recentLeastLikes;
@property (nonatomic, retain) NSNumber * recentLikes;
@property (nonatomic, retain) NSNumber * recentMostLikes;
@property (nonatomic, retain) NSNumber * subscriber;
@property (nonatomic, retain) NSString * token;
@property (nonatomic, retain) NSNumber * tokenCountUp;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSString * instaUserId;
@property (nonatomic, retain) NSSet *likedPosts;
@end

@interface UserProfile (CoreDataGeneratedAccessors)

- (void)addLikedPostsObject:(LikedPost *)value;
- (void)removeLikedPostsObject:(LikedPost *)value;
- (void)addLikedPosts:(NSSet *)values;
- (void)removeLikedPosts:(NSSet *)values;

@end
