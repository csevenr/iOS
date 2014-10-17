//
//  MasterViewController.m
//  GramManager
//
//  Created by Oli Rodden on 10/10/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "MasterViewController.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSLog(@"%f", [(NSLayoutConstraint*)[self.view.constraints objectAtIndex:15] priority]);
//    NSLog(@"%@", [(NSLayoutConstraint*)[self.view.constraints objectAtIndex:15] firstItem]);
//    NSLog(@"%ld", [(NSLayoutConstraint*)[self.view.constraints objectAtIndex:15] firstAttribute]);
//    NSLog(@"%ld", [(NSLayoutConstraint*)[self.view.constraints objectAtIndex:15] relation]);
//    NSLog(@"%@", [(NSLayoutConstraint*)[self.view.constraints objectAtIndex:15] secondItem]);
//    NSLog(@"%ld", [(NSLayoutConstraint*)[self.view.constraints objectAtIndex:15] secondAttribute]);
//    NSLog(@"%f", [(NSLayoutConstraint*)[self.view.constraints objectAtIndex:15] multiplier]);
//    NSLog(@"%f", [(NSLayoutConstraint*)[self.view.constraints objectAtIndex:15] constant]);
//    NSLog(@"%@", [(NSLayoutConstraint*)[self.view.constraints objectAtIndex:15] identifier]);
//    NSLog(@"%d", [(NSLayoutConstraint*)[self.view.constraints objectAtIndex:15] shouldBeArchived]);
    
    for (UIView *view in self.viewsToStyle) {
        view.layer.borderWidth=1.0;
        view.layer.borderColor=[UIColor blackColor].CGColor;
    }
    
//    ADBannerView *adBanner = [[ADBannerView alloc]initWithFrame:CGRectMake(0.0, self.view.frame.size.height, self.view.frame.size.width, 50.0)];
//    adBanner.delegate=self;
//    [self.view addSubview:adBanner];
}

-(IBAction)popSelf{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark iAd

- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
//    NSLog(@"%@", banner.constraints);
//    NSLog(@"%@", self.view.constraints);
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                     }];
}
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         banner.frame=CGRectMake(0.0, self.view.frame.size.height, banner.frame.size.width, banner.frame.size.height);
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                     }];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
    return YES;
}
- (void)bannerViewActionDidFinish:(ADBannerView *)banner{}


@end
