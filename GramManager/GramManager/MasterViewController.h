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
@property (strong, nonatomic) IBOutletCollection(UIView) NSMutableArray *viewsToStyle;

-(IBAction)popSelf;
- (void)replaceConstraintOnView:(UIView *)view withConstant:(float)constant andAttribute:(NSLayoutAttribute)attribute onSelf:(BOOL)onSelf;
- (void)animateConstraintsWithDuration:(CGFloat)duration delay:(CGFloat)delay andCompletionHandler:(void (^)(void))completionHandler;

@end
