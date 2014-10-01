//
//  UserProfile.h
//  GramManager
//
//  Created by Oliver Rodden on 01/10/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LikedPost;

@interface UserProfile : NSManagedObject

@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSSet *likedPosts;
@end

@interface UserProfile (CoreDataGeneratedAccessors)

- (void)addLikedPostsObject:(LikedPost *)value;
- (void)removeLikedPostsObject:(LikedPost *)value;
- (void)addLikedPosts:(NSSet *)values;
- (void)removeLikedPosts:(NSSet *)values;

@end
