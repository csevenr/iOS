//
//  LikedPost+Helper.h
//  GramManager
//
//  Created by Oliver Rodden on 01/10/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "LikedPost.h"
#import "Post.h"

@interface LikedPost (Helper)

+ (LikedPost *)createWithPost:(Post*)post;

@end
