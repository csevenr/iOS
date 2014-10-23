//
//  MasterViewController.m
//  GramManager
//
//  Created by Oli Rodden on 10/10/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "MasterViewController.h"
#import "UserProfile+Helper.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.    
    for (UIView *view in self.viewsToStyle) {
        view.layer.borderWidth=1.0;
        view.layer.borderColor=[UIColor blackColor].CGColor;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:userProfile.likeTime];
    if (secondsBetween >= 3600.000001) {
        userProfile.likesInHour = [NSNumber numberWithInt:0];
    }
}

-(IBAction)popSelf{
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

- (void)animateConstraintsWithDuration:(CGFloat)duration andDelay:(CGFloat)delay{
    [UIView animateWithDuration:0.3
                          delay:delay
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:nil
    ];

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
