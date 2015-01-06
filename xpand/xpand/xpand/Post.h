//
//  Post.h
//  GramManager
//
//  Created by Oli Rodden on 27/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Insta.h"

@interface Post : NSObject

@property UIImage *thumbnailImg;

@property NSString *postId;
@property NSString *lowResURL;
@property NSString *standardResURL;
@property NSString *thumbnailURL;
@property NSString *userId;
@property NSString *userName;

-(id)initWithDictionary:(NSDictionary*)JSONDictionary;
-(void)setPropertiesWithDictionary:(NSDictionary*)JSONDictionary;

@end
