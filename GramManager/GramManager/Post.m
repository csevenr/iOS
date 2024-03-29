//
//  Post.m
//  GramManager
//
//  Created by Oli Rodden on 27/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "Post.h"

@implementation Post

-(id)initWithDictionary:(NSDictionary*)JSONDictionary{
    if (self=[super init]) {
        [self setPropertiesWithDictionary:JSONDictionary];
    }
    return self;
}

-(void)setPropertiesWithDictionary:(NSDictionary*)JSONDictionary{
    self.postId = [JSONDictionary objectForKey:@"id"];
    self.lowResURL = [[[JSONDictionary objectForKey:@"images"] objectForKey:@"low_resolution"] objectForKey:@"url"];
    self.standardResURL = [[[JSONDictionary objectForKey:@"images"] objectForKey:@"standard_resolution"] objectForKey:@"url"];
    self.thumbnailURL = [[[JSONDictionary objectForKey:@"images"] objectForKey:@"thumbnail"] objectForKey:@"url"];
    
    self.userId = [[JSONDictionary objectForKey:@"user"] objectForKey:@"id"];
    self.userName = [[JSONDictionary objectForKey:@"user"] objectForKey:@"username"];
}

@end
