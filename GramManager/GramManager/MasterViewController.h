//
//  MasterViewController.h
//  GramManager
//
//  Created by Oliver Rodden on 30/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClientController.h"
#import "Insta.h"
#import "Menu.h"

@class LoginViewController;

@interface MasterViewController : UIViewController <instaDelegate, MenuDelegate/*, UIAlertViewDelegate, UIWebViewDelegate*/>{
    ClientController *cc;
    Insta *insta;
}

@property (nonatomic) LoginViewController *loginVc;
//@property (nonatomic) IBOutlet UIWebView *authWebView;
@property (nonatomic) IBOutlet UILabel *likeCountLbl;

//-(void)auth;

@end
