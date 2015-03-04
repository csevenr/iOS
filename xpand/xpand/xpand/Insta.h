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
-(void)logoutFinished;
-(void)instaError:(NSString*)errorString;

@end

@interface Insta : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak) id<instaDelegate> delegate;

-(void)getJsonForHashtag:(NSString*)hashtag;
- (void)likePost:(Post*)post;
-(void)getUserInfo;
-(void)getUserMedia;
-(void)setUpAutoWithHashtag:(NSString*)hastag;
-(void)logout;

@end
