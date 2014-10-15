//
//  MasterViewController.h
//  GramManager
//
//  Created by Oli Rodden on 10/10/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@class LoginViewController, UserProfile;

@interface MasterViewController : UIViewController <ADBannerViewDelegate>{
    UserProfile *userProfile;
}

@property (nonatomic) LoginViewController *loginVc;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *viewsToStyle;

-(IBAction)popSelf;

@end
