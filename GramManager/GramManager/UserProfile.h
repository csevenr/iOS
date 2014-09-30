//
//  UserProfile.h
//  GramManager
//
//  Created by Oliver Rodden on 30/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Post;

@interface UserProfile : NSManagedObject

@property (nonatomic, retain) NSNumber * totalLikesThroughApp;
@property (nonatomic, retain) NSSet *likedPosts;
@end

@interface UserProfile (CoreDataGeneratedAccessors)

- (void)addLikedPostsObject:(Post *)value;
- (void)removeLikedPostsObject:(Post *)value;
- (void)addLikedPosts:(NSSet *)values;
- (void)removeLikedPosts:(NSSet *)values;

@end
