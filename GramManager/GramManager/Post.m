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
        
        self.postId = [JSONDictionary objectForKey:@"id"];
        self.lowResURL = [[[JSONDictionary objectForKey:@"images"] objectForKey:@"low_resolution"] objectForKey:@"url"];
        self.standardResURL = [[[JSONDictionary objectForKey:@"images"] objectForKey:@"standard_resolution"] objectForKey:@"url"];
        self.thumbnailURL = [[[JSONDictionary objectForKey:@"images"] objectForKey:@"thumbnail"] objectForKey:@"url"];
        self.userId = [[JSONDictionary objectForKey:@"user"] objectForKey:@"id"];
        
//        Insta *ig = [Insta new];
//        ig.delegate=self;
//        [ig getFollowersOfUser:self.userId];
    }
    return self;
}

-(void)userJSON:(NSDictionary *)JSONDictionary{
    NSLog(@"€€ %@",JSONDictionary);
}

@end
