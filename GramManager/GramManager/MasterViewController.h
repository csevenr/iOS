//
//  MasterViewController.h
//  GramManager
//
//  Created by Oli Rodden on 10/10/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController, UserProfile;

@interface MasterViewController : UIViewController {
    UserProfile *userProfile;
}

@property (nonatomic) LoginViewController *loginVc;

//-(void)auth;
-(IBAction)popSelf;

@end
