//
//  UserProfile+Helper.h
//  GramManager
//
//  Created by Oliver Rodden on 01/10/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "UserProfile.h"

@interface UserProfile (Helper)

+ (UserProfile *)create;
+ (NSArray *)getUserProfiles;
+ (UserProfile *)getActiveUserProfile;
+ (UserProfile *)getUserProfileWithUserName:(NSString*)userName;
+(NSString*)getToken:(NSInteger)tokenNo;
+(void)deactivateCurrentUserProfile;

@end
