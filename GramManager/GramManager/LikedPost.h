//
//  LikedPost.h
//  GramManager
//
//  Created by Oliver Rodden on 30/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserProfile;

@interface LikedPost : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) UserProfile *profile;

@end
