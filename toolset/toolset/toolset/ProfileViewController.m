//
//  ProfileViewController.m
//  toolset
//
//  Created by Oliver Rodden on 04/05/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIScreenEdgePanGestureRecognizer *edgeSwipe = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(leftEdgeSwiped)];
    edgeSwipe.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgeSwipe];
    
    self.topBar.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.topBar.frame.size.height);
    self.titleLbl.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.topBar.frame.size.height);
    
    self.webView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.contentOffset = CGPointMake(0.0, 50.0);
    
    self.spinnerImgView.center = self.view.center;
    [self startSpinner];
    
    NSRange range = [self.urlToShow.absoluteString rangeOfString:@"/" options: NSBackwardsSearch];
    NSString *profileString = [self.urlToShow.absoluteString substringFromIndex:(range.location+1)];
    self.titleLbl.text = profileString;
    
    NSURLRequest *req = [NSURLRequest requestWithURL:self.urlToShow];
    [self.webView loadRequest:req];
}

-(void)leftEdgeSwiped{
    [self.delegate profileVCFinsihed];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"%@", webView.request.URL.absoluteString);
    
    NSRange range = [webView.request.URL.absoluteString rangeOfString:@"/" options: NSBackwardsSearch];
    NSString *stringToCheck = [webView.request.URL.absoluteString substringToIndex:(range.location+1)];
    
    if ([stringToCheck isEqualToString:@"https://mobile.twitter.com/"]) {
        
    }
    
    [self fadeWebView:NO withDelay:0.2];
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(50.0, 0.0, 0.0, 0.0);
}

-(void)fadeWebView:(BOOL)fadeOut withDelay:(CGFloat)delay{
    [UIView animateWithDuration:0.4
                          delay:delay
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         if (fadeOut) {
                             self.webView.alpha = 0.0;
                         }else{
                             self.webView.alpha = 1.0;
                         }
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

-(void)startSpinner{
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat: 2 * M_PI];
    animation.duration = 1.0f;
    animation.repeatCount = HUGE_VAL;
    [self.spinnerImgView.layer addAnimation:animation forKey:@"MyAnimation"];
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

- (IBAction)backBtnPressed:(id)sender {
    [self.delegate profileVCFinsihed];
}

@end
