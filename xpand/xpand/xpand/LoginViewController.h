//
//  LoginViewController.h
//  GramManager
//
//  Created by Oliver Rodden on 03/10/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"
#import "Insta.h"

@protocol loginDelegate <NSObject>

-(void)loginFinished;

@end

@interface LoginViewController : MasterViewController <instaDelegate, UIWebViewDelegate>

@property (nonatomic, weak) id<loginDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIWebView *authWebView;
@property (nonatomic) BOOL login;

-(void)auth;

@end
