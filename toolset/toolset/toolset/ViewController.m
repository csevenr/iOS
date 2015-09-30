//
//  ViewController.m
//  toolset
//
//  Created by Oliver Rodden on 29/04/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "ViewController.h"
#import "Reachability.h"
#import "ORButton.h"
#import "BurgerButton.h"

/**-------------------
        Todo
-- iADs
-- differnent button active state
-- spinner (needs artwork)
-- back arrow (needs artwork)
 itunes connect release shizz
 scroll to top
 
 everything into classes
 --------------------*/

#define ORBLACK [UIColor colorWithRed:20.0 / 255.0 green:20.0 / 255.0 blue:20.0 / 255.0 alpha:1.0]
#define ORDARKGREY [UIColor colorWithRed:36.0 / 255.0 green:36.0 / 255.0 blue:36.0 / 255.0 alpha:1.0]
#define ORGREY [UIColor colorWithRed:58.0 / 255.0 green:58.0 / 255.0 blue:58.0 / 255.0 alpha:1.0]
#define ORLIGHTGREY [UIColor colorWithRed:145.0 / 255.0 green:145.0 / 255.0 blue:145.0 / 255.0 alpha:1.0]
#define ORWHITE [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0]

#define CLOSEDBUTTONX - 50.0
#define OPENEDBUTTONX 0

#define MAINURL @"https://toolset.co/twitter/m/"
#define COPYFOLLOWURL @"https://toolset.co/twitter/m/follow/copy-follow/"
#define KEYWORDFOLLOWURL @"https://toolset.co/twitter/m/follow/keyword-follow/"
#define KEYWORDUSERFOLLOWURL @"https://toolset.co/twitter/m/follow/keyword-user-follow/"
#define AUTOFAVOURITEURL @"https://toolset.co/twitter/m/auto/favorite/"
#define UNFOLLOWURL @"https://toolset.co/twitter/m/unfollow/"
#define WHITELISTURL @"https://toolset.co/twitter/m/unfollow/whitelist/"
#define LOGOUTURL @"https://toolset.co/twitter/m/logout/"

@interface ViewController (){
    BOOL menuIsOpen;
    BOOL infoIsOpen;
    
    BOOL loggedIn;
    
//    PageType currentPageType;
    
    NSURLRequest *currentRequest;
    NSTimer *reConnectTimer;
    
    NSTimer *connectionTimer;
    UIAlertView *timeoutAlert;
    BOOL connectionIsCrap;
}

@end

@implementation ViewController

# pragma mark - view controller cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    menuIsOpen = NO;
    [self setLoggedIn:NO];
    connectionIsCrap = NO;
    [self showUIWithTitle:nil];
    
    self.view.backgroundColor = ORWHITE;
    self.webView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.scrollsToTop = YES;
    self.topBar.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.topBar.frame.size.height);
    self.titleLbl.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.topBar.frame.size.height);
    self.infoBtn.frame = CGRectMake(self.view.frame.size.width - 40.0, self.infoBtn.frame.origin.y, self.infoBtn.frame.size.width, self.infoBtn.frame.size.height);
    self.infoTextView.frame = CGRectMake(self.infoTextView.frame.origin.x, self.infoTextView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - self.infoTextView.frame.origin.y);
    self.menuView.frame = CGRectMake(-self.menuView.frame.size.width, self.menuView.frame.origin.y, self.menuView.frame.size.width, self.view.frame.size.height);
    self.menuView.backgroundColor = ORGREY;
    self.menuBtn.frame = CGRectMake(0.0, self.menuBtn.frame.origin.y, self.menuBtn.frame.size.width, self.menuBtn.frame.size.height);
    [self.logoutBtn setTitleColor:ORLIGHTGREY forState:UIControlStateNormal];
    
    self.infoBtn.layer.borderWidth = 1.0;
    self.infoBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.infoBtn.layer.cornerRadius = self.infoBtn.frame.size.width / 2;
    
    for (UIButton *btn in self.menuBtns) {
        btn.frame = CGRectMake(CLOSEDBUTTONX, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height);
    }
    
    self.spinnerImgView.center = self.view.center;
    self.connectionLbl.center = self.view.center;
    [self startSpinner];
    
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:COPYFOLLOWURL]]];
    [self request:nsrequest];
    
    currentPageType = PageType_SignIn;
    
    UIScreenEdgePanGestureRecognizer *edgeSwipe = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(leftEdgeSwiped)];
    edgeSwipe.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgeSwipe];
}

- (void)viewNeedsReload{
    [self startSpinner];
}

# pragma mark - odds and sods
-(void)setLoggedIn:(BOOL)isLoggedIn{
    loggedIn = isLoggedIn;
    if (loggedIn == YES) {
        self.menuBtn.hidden = NO;
//        self.infoBtn.hidden = NO;
    }else{
        self.menuBtn.hidden = YES;
        self.infoBtn.hidden = YES;
    }
}

# pragma mark - animations

-(void)openMenu{
    if (!loggedIn) {
        return;
    }
    [self.menuBtn changeStateToOpenState:YES];
    self.webView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.15
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.menuView.frame = CGRectMake(0.0, self.menuView.frame.origin.y, self.menuView.frame.size.width, self.menuView.frame.size.height);
                         self.menuBtn.frame = CGRectMake(self.menuView.frame.size.width, self.menuBtn.frame.origin.y, self.menuBtn.frame.size.width, self.menuBtn.frame.size.height);
                         self.webView.frame = CGRectMake(self.menuView.frame.size.width, self.webView.frame.origin.y, self.webView.frame.size.width, self.webView.frame.size.height);
                         self.spinnerImgView.center = self.webView.center;
                         
                         self.titleLbl.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         menuIsOpen = YES;
                     }];
    
    [UIView animateWithDuration:0.15
                          delay:0.05
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         for (UIButton *btn in self.menuBtns) {
                             btn.frame = CGRectMake(OPENEDBUTTONX, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height);
                         }
                     }
                     completion:^(BOOL finished){
                         menuIsOpen = YES;
                     }];
}

- (void)closeMenu{
    [self.menuBtn changeStateToOpenState:NO];
    [UIView animateWithDuration:0.15
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.menuView.frame = CGRectMake(- self.menuView.frame.size.width, self.menuView.frame.origin.y, self.menuView.frame.size.width, self.menuView.frame.size.height);
                         self.menuBtn.frame = CGRectMake(0.0, self.menuBtn.frame.origin.y, self.menuBtn.frame.size.width, self.menuBtn.frame.size.height);
                         self.webView.frame = CGRectMake(0.0, self.webView.frame.origin.y, self.webView.frame.size.width, self.webView.frame.size.height);
                         self.spinnerImgView.center = self.webView.center;
                     
                         self.titleLbl.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         menuIsOpen = NO;
                         self.webView.userInteractionEnabled = YES;
                     }];
    
    [UIView animateWithDuration:0.15
                          delay:0.05
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         for (UIButton *btn in self.menuBtns) {
                             btn.frame = CGRectMake(CLOSEDBUTTONX, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height);
                         }
                         
                     }
                     completion:^(BOOL finished){
                         menuIsOpen = NO;
                     }];
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
                         if (!fadeOut) {
                             if (loggedIn) {
                                 if (![[NSUserDefaults standardUserDefaults] objectForKey:@"firstTime"]) {
                                     [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"firstTime"];
                                     [self bounceMenu];
                                 }
                             }
                         }
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

-(void)bounceMenu{
    [UIView animateWithDuration:0.15
                          delay:1.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.menuView.frame = CGRectMake(self.menuView.frame.origin.x + 60, self.menuView.frame.origin.y, self.menuView.frame.size.width, self.menuView.frame.size.height);
                         self.menuBtn.frame = CGRectMake(self.menuBtn.frame.origin.x + 60, self.menuBtn.frame.origin.y, self.menuBtn.frame.size.width, self.menuBtn.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.15
                                               delay:0.0
                                             options: UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              self.menuView.frame = CGRectMake(self.menuView.frame.origin.x - 60, self.menuView.frame.origin.y, self.menuView.frame.size.width, self.menuView.frame.size.height);
                                              self.menuBtn.frame = CGRectMake(self.menuBtn.frame.origin.x - 60, self.menuBtn.frame.origin.y, self.menuBtn.frame.size.width, self.menuBtn.frame.size.height);
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.15
                                                                    delay:0.0
                                                                  options: UIViewAnimationOptionCurveEaseOut
                                                               animations:^{
                                                                   self.menuView.frame = CGRectMake(self.menuView.frame.origin.x + 30, self.menuView.frame.origin.y, self.menuView.frame.size.width, self.menuView.frame.size.height);
                                                                   self.menuBtn.frame = CGRectMake(self.menuBtn.frame.origin.x + 30, self.menuBtn.frame.origin.y, self.menuBtn.frame.size.width, self.menuBtn.frame.size.height);
                                                               }
                                                               completion:^(BOOL finished){
                                                                   [UIView animateWithDuration:0.15
                                                                                         delay:0.0
                                                                                       options: UIViewAnimationOptionCurveEaseIn
                                                                                    animations:^{
                                                                                        self.menuView.frame = CGRectMake(self.menuView.frame.origin.x - 30, self.menuView.frame.origin.y, self.menuView.frame.size.width, self.menuView.frame.size.height);
                                                                                        self.menuBtn.frame = CGRectMake(self.menuBtn.frame.origin.x - 30, self.menuBtn.frame.origin.y, self.menuBtn.frame.size.width, self.menuBtn.frame.size.height);
                                                                                    }
                                                                                    completion:^(BOOL finished){
                                                                                        
                                                                                    }];
                                                               }];
                                          }];
                     }];
}

# pragma mark - networking

-(void)request:(NSURLRequest*)req{
    [self closeMenu];
    if (![req isKindOfClass:[NSTimer class]]) {
        currentRequest = req;
    }
    
    if ([self networkReachable]) {
        if (reConnectTimer != nil) {
            [reConnectTimer invalidate];
            reConnectTimer = nil;
        }
        
        [self.webView loadRequest:currentRequest];
        
        if (connectionIsCrap) {
            reConnectTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(request:) userInfo:nil repeats:NO];
        }else{
            if (connectionTimer == nil) {
                connectionTimer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(connectionTimeout) userInfo:nil repeats:NO];
            }
        }
    }else{
        reConnectTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(request:) userInfo:nil repeats:NO];

        [self showNoConnection];
    }
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
    
        NSRange range = [request.URL.absoluteString rangeOfString:@"/" options: NSBackwardsSearch];
        NSString *stringToCheck = [request.URL.absoluteString substringToIndex:(range.location+1)];

        if ([stringToCheck isEqualToString:@"https://twitter.com/"]) {
            [self performSegueWithIdentifier:@"profile" sender:request.URL];
            return NO;
        }
    }
    
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    connectionIsCrap = NO;
    [connectionTimer invalidate];
    connectionTimer = nil;
    if ([timeoutAlert isVisible]) {
        [timeoutAlert dismissWithClickedButtonIndex:3 animated:YES];
    }
    
    if ([webView.request.URL.absoluteString isEqualToString:MAINURL]) {
//        [self showUIWithTitle:@"Toolset"];
        currentPageType = PageType_SignIn;
        [self setLoggedIn:NO];
    }else if ([webView.request.URL.absoluteString isEqualToString:COPYFOLLOWURL]){
        [self showUIWithTitle:@"Copy Follow"];
        currentPageType = PageType_CopyFollow;
        [self setLoggedIn:YES];
        [(UIButton *)[self.orBtns objectAtIndex:0] setSelected:YES];
    }else if ([webView.request.URL.absoluteString isEqualToString:KEYWORDFOLLOWURL]){
        [self showUIWithTitle:@"Keyword Follow"];
        currentPageType = PageType_KeywordFollow;
        [self setLoggedIn:YES];
    }else if ([webView.request.URL.absoluteString isEqualToString:KEYWORDUSERFOLLOWURL]){
        [self showUIWithTitle:@"Keyword User Follow"];
        currentPageType = PageType_KeywordUserFollow;
        [self setLoggedIn:YES];
    }else if ([webView.request.URL.absoluteString isEqualToString:AUTOFAVOURITEURL]){
        [self showUIWithTitle:@"Auto Favorite"];
        currentPageType = PageType_AutoFavorite;
        [self setLoggedIn:YES];
    }else if ([webView.request.URL.absoluteString isEqualToString:UNFOLLOWURL]){
        [self showUIWithTitle:@"Unfollow"];
        currentPageType = PageType_Unfollow;
        [self setLoggedIn:YES];
    }else if ([webView.request.URL.absoluteString isEqualToString:WHITELISTURL]){
        [self showUIWithTitle:@"Whitelist"];
        currentPageType = PageType_Whitelist;
        [self setLoggedIn:YES];
    }else{
//        NSRange range = [webView.request.URL.absoluteString rangeOfString:@"/" options: NSBackwardsSearch];
//        NSString *stringToCheck = [webView.request.URL.absoluteString substringToIndex:(range.location+1)];
//        
//        if (![stringToCheck isEqualToString:@"https://api.twitter.com/oauth/"]) {
//            NSURLRequest *nsrequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:COPYFOLLOWURL]]];
//            [self request:nsrequest];
//        }
        currentPageType = PageType_SignIn;
        [self setLoggedIn:NO];
    }

    [self fadeWebView:NO withDelay:0.3];
}

- (BOOL)networkReachable{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return NO;
    } else {
        return YES;
    }
}

-(void)connectionTimeout{
    [connectionTimer invalidate];
    connectionTimer = nil;
    timeoutAlert = [[UIAlertView alloc]initWithTitle:@"Connection Timed Out" message:@"Your connection has timed out, please make sure you are connected to the internet and try again" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try again", nil];
    timeoutAlert.tag = 1;
    [timeoutAlert show];
}

# pragma mark - inputs

- (IBAction)menuBtnPressed{
    if (menuIsOpen == YES) {
        [self closeMenu];
    }else{
        [self openMenu];
    }
}

-(void)leftEdgeSwiped{
    [self openMenu];
}

- (IBAction)menuSwipeClose:(id)sender {
    [self closeMenu];
}

- (IBAction)infoBtnPressed:(id)sender {
    if (infoIsOpen == YES) {
        infoIsOpen = NO;
        [UIView animateWithDuration:0.15
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.topBar.frame = CGRectMake(self.topBar.frame.origin.x, self.topBar.frame.origin.y, self.topBar.frame.size.width, 50.0/*dirty*/);
                             [self.infoBtn setTitle:@"i" forState:UIControlStateNormal];
                         }
                         completion:^(BOOL finished){
                         }];
    }else{
        infoIsOpen = YES;
        [UIView animateWithDuration:0.15
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.topBar.frame = CGRectMake(self.topBar.frame.origin.x, self.topBar.frame.origin.y, self.topBar.frame.size.width, self.view.frame.size.height);
                             [self.infoBtn setTitle:@"X" forState:UIControlStateNormal];
                         }
                         completion:^(BOOL finished){
                         }];
    }
}

- (IBAction)copyFollowBtnPressed:(ORButton*)sender{
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:[NSURL URLWithString:COPYFOLLOWURL]];
    [self request:nsrequest];
    [self showUIWithTitle:@"Copy Follow"];
    currentPageType = PageType_CopyFollow;
    [self unselectBtnCol];
    [sender setSelected:YES];
}

- (IBAction)keywordFollowBtnPressed:(ORButton*)sender{
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:[NSURL URLWithString:KEYWORDFOLLOWURL]];
    [self request:nsrequest];
    [self showUIWithTitle:@"Keyword Follow"];
    currentPageType = PageType_KeywordFollow;
    [self unselectBtnCol];
    [sender setSelected:YES];
}

- (IBAction)keywordUserFollowBtnPressed:(ORButton*)sender{
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:[NSURL URLWithString:KEYWORDUSERFOLLOWURL]];
    [self request:nsrequest];
    [self showUIWithTitle:@"Keyword User Follow"];
    currentPageType = PageType_KeywordUserFollow;
    [self unselectBtnCol];
    [sender setSelected:YES];
}

- (IBAction)autoFavBtnPressed:(ORButton*)sender{
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:[NSURL URLWithString:AUTOFAVOURITEURL]];
    [self request:nsrequest];
    [self showUIWithTitle:@"Auto Favorite"];
    currentPageType = PageType_AutoFavorite;
    [self unselectBtnCol];
    [sender setSelected:YES];
}

- (IBAction)unfollowBtnPressed:(ORButton*)sender{
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:[NSURL URLWithString:UNFOLLOWURL]];
    [self request:nsrequest];
    [self showUIWithTitle:@"Unfollow"];
    currentPageType = PageType_Unfollow;
    [self unselectBtnCol];
    [sender setSelected:YES];
}

- (IBAction)whitelistBtnPressed:(ORButton*)sender{
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:[NSURL URLWithString:WHITELISTURL]];
    [self request:nsrequest];
    [self showUIWithTitle:@"Whitelist"];
    currentPageType = PageType_Whitelist;
    [self unselectBtnCol];
    [sender setSelected:YES];
}

- (IBAction)logoutBtnPressed{
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:[NSURL URLWithString:LOGOUTURL]];
    [self request:nsrequest];
    [self showUIWithTitle:nil];
    [self fadeWebView:YES withDelay:0.0];
    currentPageType = PageType_SignIn;
    [self unselectBtnCol];
    [self setLoggedIn:NO];
    [self hideAd];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject]locationInView:self.view];
    if (menuIsOpen) {
        if (CGRectContainsPoint(self.webView.frame, point)) {
            [self closeMenu];
        }
    }
}

#pragma mark - ui changes

-(void)showUIWithTitle:(NSString*)title{
    if (title == nil) {
        self.topBar.hidden = YES;
        self.menuBtn.hidden = YES;
    }else{
        self.topBar.hidden = NO;
        self.titleLbl.text = title;
        self.menuBtn.hidden = NO;
    }
    self.spinnerImgView.hidden = NO;
    self.connectionLbl.hidden = YES;
    
    [self fadeWebView:YES withDelay:0.0];

}

-(void)hideTopBar{
    self.topBar.hidden = YES;
}

-(void)unselectBtnCol{
    for (ORButton *btn in self.orBtns) {
        [btn setSelected:NO];
    }
}

-(void)showNoConnection{
    [self fadeWebView:YES withDelay:0.0];
    self.spinnerImgView.hidden = YES;
    self.connectionLbl.hidden = NO;
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self request:currentRequest];
    }else if (buttonIndex == 0) {
        [self showNoConnection];
        connectionIsCrap = YES;
        reConnectTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(request:) userInfo:nil repeats:NO];
    }
}

#pragma mark - Navigation
 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [(ProfileViewController *)[segue destinationViewController] setUrlToShow:sender];
    [(ProfileViewController *)[segue destinationViewController] setDelegate:self];
}

-(void)profileVCFinsihed{
    [self startSpinner];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
