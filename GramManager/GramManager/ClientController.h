//
//  TokenController.h
//  GramManager
//
//  Created by Oliver Rodden on 30/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ClientController : NSObject <UIWebViewDelegate>

+ (ClientController *)sharedInstance;
-(void)setupTokensInWebView:(UIWebView*)webview;
-(NSString*)getCurrentTokenForLike:(BOOL)forLike;
-(NSString*)getCurrentClientId;

@end
