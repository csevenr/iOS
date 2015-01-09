//
//  MasterViewController.m
//  GramManager
//
//  Created by Oli Rodden on 10/10/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "MasterViewController.h"
#import "UserProfile+Helper.h"
#import "LoginViewController.h"
#import "XpandPlusView.h"

@interface MasterViewController () {
    BOOL needsLogin; //Must attempt login straight away for some screens to have userprofile, but if need a login must be done after the view is loaded so i have the segue
}

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    needsLogin = NO;
    [self login];
    
    // Do any additional setup after loading the view.    
    for (UIView *view in self.viewsToStyle) {
        view.layer.borderWidth=1.0;
//        view.layer.borderColor = [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1.0].CGColor;
        view.layer.borderColor = [UIColor whiteColor].CGColor;
        view.layer.cornerRadius = 5.0;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:userProfile.likeTime];
    if (secondsBetween >= 3600.000001) {
        userProfile.likesInHour = [NSNumber numberWithInt:0];
    }
    if (needsLogin){
        [self performSegueWithIdentifier:@"login" sender:[NSNumber numberWithBool:YES]];
        needsLogin = NO;
    }
}

-(void)login{
    if ([UserProfile getActiveUserProfile]!=nil) {
        userProfile = [UserProfile getActiveUserProfile];
    }else{
        needsLogin = YES;
    }
}

-(void)showXpandPlusView{
    NSArray * allTheViewsInMyNIB = [[NSBundle mainBundle] loadNibNamed:@"XpandPlusView" owner:self options:nil]; // loading nib (might contain more than one view)
    XpandPlusView* xView = allTheViewsInMyNIB[0]; // getting desired view
    xView.delegate = self;
    xView.frame = CGRectMake(16.0, self.view.frame.size.height, self.view.frame.size.width - 32.0 ,self.view.frame.size.height - 32.0); //setting the frame
    [self.view addSubview:xView];

    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         xView.frame = CGRectMake(16.0, 16.0, self.view.frame.size.width - 32.0 ,self.view.frame.size.height - 32.0);
                     }
                     completion:^(BOOL finished){
                     }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.destinationViewController isKindOfClass:[LoginViewController class]]) {
        self.loginVc = segue.destinationViewController;
    }
}

-(IBAction)popSelf{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)replaceConstraintOnView:(UIView *)view withConstant:(float)constant andAttribute:(NSLayoutAttribute)attribute onSelf:(BOOL)onSelf{
    UIView *viewForConstraints;
    if (onSelf) viewForConstraints = view;
    else viewForConstraints = self.view;
    
//    NSLog(@"%@", viewForConstraints.constraints);
    
    /*=========================================
    
    THIS SHIT NEEDS UNDERSTANDING AND REWRITING
     
    =========================================*/
    
    [viewForConstraints.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if (constraint.firstItem == view) {
//            NSLog(@"%@", constraint.firstItem);
            if ((constraint.firstAttribute == attribute)) {
//                NSLog(@"## %d", constraint.firstAttribute);
                constraint.constant = constant;
//                NSLog(@"yay");
            }
        }
    }];
}

- (void)animateConstraintsWithDuration:(CGFloat)duration delay:(CGFloat)delay andCompletionHandler:(void (^)(void))completionHandler{
    [UIView animateWithDuration:0.3
                          delay:delay
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                         if (completionHandler) {
                             completionHandler();
                         }
                     }];

}

#pragma mark iAd

- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
//    [self replaceConstraintOnView:banner withConstant:-banner.frame.size.height andAttribute:NSLayoutAttributeTop onSelf:NO];
//    [self animateConstraints];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
//    [self replaceConstraintOnView:banner withConstant:0 andAttribute:NSLayoutAttributeTop onSelf:NO];
//    [self animateConstraints];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
    return YES;
}
- (void)bannerViewActionDidFinish:(ADBannerView *)banner{}


@end
