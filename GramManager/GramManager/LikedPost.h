//
//  LikedPost.h
//  GramManager
//
//  Created by Oliver Rodden on 01/10/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserProfile;

@interface LikedPost : NSManagedObject

@property (nonatomic, retain) NSString * postId;
@property (nonatomic, retain) NSString * lowResURL;
@property (nonatomic, retain) NSString * standardResURL;
@property (nonatomic, retain) NSString * thumbnailURL;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) UserProfile *profile;

@end
