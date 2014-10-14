//
//  Insta.h
//  GramManager
//
//  Created by Oliver Rodden on 26/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Post;

@protocol instaDelegate <NSObject>

@optional
-(void)JSONReceived:(NSDictionary*)JSONDictionary;//+++ refactor
-(void)likedPost;

-(void)userInfoFinished;

@end

@interface Insta : NSObject //<NSURLConnectionDelegate>

@property (nonatomic, weak) id<instaDelegate> delegate;

-(void)getJsonForHashtag:(NSString*)hashtag;
- (void)likePost:(Post*)post;
-(void)getUserInfoWithToken:(NSString*)tok;
-(void)getUserMedia;
-(void)logout;

@end
