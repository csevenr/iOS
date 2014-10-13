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
//#import "Insta.h"

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
    NSArray *userProfiles = [UserProfile getUserProfiles];
    
    /*--Multi account stuff--
//    for (int i=0; i<[userProfiles count]; i++) {
//        UIButton *userBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0, 100.0+(62*i), self.view.frame.size.width, 60.0)];
//        if ([(UserProfile*)[userProfiles objectAtIndex:i] userName]!=nil) {
//            [userBtn setTitle:[(UserProfile*)[userProfiles objectAtIndex:i] userName] forState:UIControlStateNormal];
//        }else{
//            [userBtn setTitle:@"Retrieving user info" forState:UIControlStateNormal];
//        }
//        [userBtn addTarget:self action:@selector(accountBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//        userBtn.tag=i;
//        userBtn.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
//        [userBtn setTitleColor:[UIColor colorWithRed:42.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:1.0] forState:UIControlStateNormal];
//        [self.view addSubview:userBtn];
//        [btns addObject:userBtn];
//    }
          -----------------------*/
    
    if ([userProfiles count]<4) {
        UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0, 100.0+(62*[userProfiles count]), self.view.frame.size.width, 60.0)];
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
    [[ClientController sharedInstance] setupTokensInWebView:self.authWebView];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString* urlString = [[request URL] absoluteString];
    
//    NSLog(@"%@", urlString);
    
    if ([urlString isEqualToString:@"http://instagram.com/"]) {
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

//            NSLog(@"%@", tokenString);
            
            //CORE DATA TOKENS
//            if ([UserProfile getToken:1]==nil) {
//                [UserProfile getActiveUserProfile].token1=tokenString;
//            }else if ([UserProfile getToken:2]==nil){
//                [UserProfile getActiveUserProfile].token2=tokenString;
//            }else if ([UserProfile getToken:3]==nil){
//                [UserProfile getActiveUserProfile].token3=tokenString;
//            }else if ([UserProfile getToken:4]==nil){
//                [UserProfile getActiveUserProfile].token4=tokenString;
//            }
//            if ([UserProfile getToken:4]==nil) {
//                [[ClientController sharedInstance] setupTokensInWebView:self.authWebView];
//            }
            
            //TEMP TOKENS
            if ([tokens count]==0) {
                tokens = [NSMutableArray new];
                [tokens addObject:tokenString];
            }else if ([tokens count]==1){
                [tokens addObject:tokenString];
            }else if ([tokens count]==2){
                [tokens addObject:tokenString];
            }else if ([tokens count]==3){
                [tokens addObject:tokenString];
            }
            if ([tokens count]!=4) {
                [[ClientController sharedInstance] setupTokensInWebView:self.authWebView];
            }
        }
    }
    return YES;
}

-(void)userInfoFinished{
    if ([UserProfile getToken:1]==nil) {
        [UserProfile getActiveUserProfile].token1=[tokens objectAtIndex:0];
    }else if ([UserProfile getToken:2]==nil){
        [UserProfile getActiveUserProfile].token2=[tokens objectAtIndex:1];
    }else if ([UserProfile getToken:3]==nil){
        [UserProfile getActiveUserProfile].token3=[tokens objectAtIndex:2];
    }else if ([UserProfile getToken:4]==nil){
        [UserProfile getActiveUserProfile].token4=[tokens objectAtIndex:3];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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