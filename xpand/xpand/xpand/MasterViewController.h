//
//  MasterViewController.h
//  GramManager
//
//  Created by Oli Rodden on 10/10/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "XpandPlusView.h"

#define FONT [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0]

@class LoginViewController, UserProfile;

@interface MasterViewController : UIViewController <XpandPlusDelegate, ADBannerViewDelegate>{
    UserProfile *userProfile;
}

@property (nonatomic) LoginViewController *loginVc;
@property (strong, nonatomic) IBOutletCollection(UIView) NSMutableArray *viewsToStyle;

-(void)showXpandPlusView;
-(IBAction)popSelf;
- (void)replaceConstraintOnView:(UIView *)view withConstant:(float)constant andAttribute:(NSLayoutAttribute)attribute onSelf:(BOOL)onSelf;
- (void)animateConstraintsWithDuration:(CGFloat)duration delay:(CGFloat)delay andCompletionHandler:(void (^)(void))completionHandler;

@end
