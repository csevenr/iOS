//
//  LoginViewController.h
//  GramManager
//
//  Created by Oliver Rodden on 03/10/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Insta.h"

@interface LoginViewController : UIViewController <instaDelegate, UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *authWebView;

-(void)auth;

@end
