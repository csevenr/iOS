//
//  Insta.h
//  GramManager
//
//  Created by Oliver Rodden on 26/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol instaDelegate <NSObject>

-(void)JSONReceived:(NSDictionary*)JSONDictionary;

@end

@interface Insta : NSObject //<NSURLConnectionDelegate>

@property (nonatomic, weak) id<instaDelegate> delegate;

+(NSString*)requestTokenIn:(UIWebView*)webview;
-(void)getJsonForHashtag:(NSString*)hashtag;

@end
