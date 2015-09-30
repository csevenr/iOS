
//
//  AdViewController.m
//  toolset
//
//  Created by Oliver Rodden on 12/05/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "AdViewController.h"



@interface AdViewController () {
    ADBannerView *adBanner;
    
}

@end

@implementation AdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    adBanner = [[ADBannerView alloc]initWithFrame:CGRectMake(0.0, self.view.frame.size.height, self.view.frame.size.width, 50.0)];
    adBanner.delegate = self;
    [self.view addSubview:adBanner];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [self.view bringSubviewToFront:adBanner];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark iAd shizz

- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
    if (currentPageType != PageType_SignIn) {
        [UIView animateWithDuration:0.1
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             adBanner.frame=CGRectMake(0.0, self.view.frame.size.height-adBanner.frame.size.height, adBanner.frame.size.width, adBanner.frame.size.height);
                             if (self.webView.frame.size.height == self.view.frame.size.height) {
                                 self.webView.frame = CGRectMake(self.webView.frame.origin.x, self.webView.frame.origin.y, self.webView.frame.size.width, self.webView.frame.size.height - 50);
                             }
                         }
                         completion:^(BOOL finished){
                         }];
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    [self hideAd];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner{
    [self startSpinner];
}

-(void)hideAd{
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         adBanner.frame=CGRectMake(0.0, self.view.frame.size.height, adBanner.frame.size.width, adBanner.frame.size.height);
                         self.webView.frame = CGRectMake(self.webView.frame.origin.x, self.webView.frame.origin.y, self.webView.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];
}

@end
