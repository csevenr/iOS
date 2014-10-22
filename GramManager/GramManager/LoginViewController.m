//
//  LoginViewController.m
//  GramManager
//
//  Created by Oliver Rodden on 03/10/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "LoginViewController.h"
#import "UserProfile+Helper.h"
#import "ModelHelper.h"
#import "ClientController.h"

@interface LoginViewController (){
    NSMutableArray *btns;
    UIActivityIndicatorView *activityIndicator;
    NSMutableArray *tokens;
}

@end

@implementation LoginViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self==[super initWithCoder:aDecoder]) {
        btns=[NSMutableArray new];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:42.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:1.0];
    [self createBtns];
}

-(void)createBtns{
    if (btns!=nil){
        for (UIButton *btn in btns) {
            [btn removeFromSuperview];
        }
        [btns removeAllObjects];
    }
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0, 162.0, self.view.frame.size.width, 60.0)];
        if (self.login) {
            if ([UserProfile getActiveUserProfile]) {//dont add a target here, dont want anyone pressing it.
                [loginBtn setTitle:@"Retrieving user info" forState:UIControlStateNormal];
            }else{
                [loginBtn setTitle:@"Log in" forState:UIControlStateNormal];
                [loginBtn addTarget:self action:@selector(accountBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            }
        }else{
            [loginBtn setTitle:@"Logging out" forState:UIControlStateNormal];
            NSURLRequest *requestObj;
            requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://instagram.com/accounts/logout/"]];
            [self.authWebView loadRequest:requestObj];
        }
        loginBtn.tag=10;
        loginBtn.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
        [loginBtn setTitleColor:[UIColor colorWithRed:42.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.view addSubview:loginBtn];
        [btns addObject:loginBtn];
        
        activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(200.0, 20.0, 20.0, 20.0)];
        activityIndicator.color=[UIColor colorWithRed:42.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:1.0];
        activityIndicator.hidden=YES;
        [loginBtn addSubview:activityIndicator];
}

-(void)accountBtnPressed:(UIButton*)sender{
    if (sender.tag==10) {
        [self createNewAccount];
        [activityIndicator startAnimating];
        activityIndicator.hidden = NO;
    }else{
        [UserProfile getUserProfileWithUserName:sender.titleLabel.text].isActive=[NSNumber numberWithBool:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)createNewAccount{
    [[ClientController sharedInstance] setupToken:1 inWebView:self.authWebView];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString* urlString = [[request URL] absoluteString];
    
    NSLog(@"%@", urlString);
    
    if ([urlString isEqualToString:@"http://instagram.com/"]||[urlString isEqualToString:@"about:blank"]) {
        self.authWebView.hidden=YES;
        self.login=YES;
        [self createBtns];
    }
    
    NSRange equalRange0 = [urlString rangeOfString:@"accounts" options:NSBackwardsSearch];
    if(equalRange0.length > 0) {
        webView.hidden=NO;
        [self.view bringSubviewToFront:webView];
        self.authWebView.hidden=NO;
    }
    
    NSRange equalRange = [urlString rangeOfString:@":" options:NSBackwardsSearch];
    NSString* stringToCheck = [urlString substringToIndex:equalRange.location + equalRange.length - 1];
    
    if ([stringToCheck isEqualToString:@"gmanager"]) {
        equalRange = [urlString rangeOfString:@"access_token=" options:NSBackwardsSearch];
        
        if ([[urlString substringToIndex:equalRange.location + equalRange.length - 1] isEqualToString:@"gmanager:%23access_token"]) {
            NSString *tokenString = [urlString substringFromIndex:equalRange.location + equalRange.length];

            NSLog(@"%@", tokenString);
            
            if ([tokens count]==0) {
                tokens = [NSMutableArray new];
                [tokens addObject:tokenString];
                [[ClientController sharedInstance] setupToken:2 inWebView:self.authWebView];
            }else if ([tokens count]==1){
                [tokens addObject:tokenString];
                [[ClientController sharedInstance] setupToken:3 inWebView:self.authWebView];
            }else if ([tokens count]==2){
                [tokens addObject:tokenString];
                [[ClientController sharedInstance] setupToken:4 inWebView:self.authWebView];
            }else if ([tokens count]==3){
                [tokens addObject:tokenString];
            }
        }
    }
    return YES;
}

-(void)userInfoFinished{
    UserProfile *userProfile = [UserProfile getActiveUserProfile];
    NSLog(@"user profile %@", userProfile);
    if (userProfile.token1==nil) {
        userProfile.token1=[tokens objectAtIndex:0];
    }
    if (userProfile.token2==nil){
        userProfile.token2=[tokens objectAtIndex:1];
    }
    if (userProfile.token3==nil){
        userProfile.token3=[tokens objectAtIndex:2];
    }
    if (userProfile.token4==nil){
        userProfile.token4=[tokens objectAtIndex:3];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [ModelHelper saveManagedObjectContext];
        [self.delegate loginFinished];
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

-(void)auth{
    if ([tokens count]==4) {
        [self createBtns];
        activityIndicator.frame=CGRectMake(activityIndicator.frame.origin.x+50.0, activityIndicator.frame.origin.y, activityIndicator.frame.size.width, activityIndicator.frame.size.height);
        [activityIndicator startAnimating];
        activityIndicator.hidden = NO;
        self.authWebView.hidden=YES;
        Insta *insta = [Insta new];
        insta.delegate=self;
        [insta getUserInfoWithToken:[tokens objectAtIndex:0]];
    }
}

@end
