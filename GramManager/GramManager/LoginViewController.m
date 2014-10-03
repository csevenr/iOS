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
    for (int i=0; i<[userProfiles count]; i++) {
        UIButton *userBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0, 100.0+(52*i), self.view.frame.size.width, 50.0)];
        userBtn.backgroundColor = [UIColor blackColor];
        if ([(UserProfile*)[userProfiles objectAtIndex:i] userName]!=nil) {
            [userBtn setTitle:[(UserProfile*)[userProfiles objectAtIndex:i] userName] forState:UIControlStateNormal];
        }else{
            [userBtn setTitle:@"Retrieving user info" forState:UIControlStateNormal];
        }
        [userBtn addTarget:self action:@selector(accountBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        userBtn.tag=i;
        [self.view addSubview:userBtn];
        [btns addObject:userBtn];
    }
    if ([userProfiles count]<4) {
        UIButton *createBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0, 100.0+(52*[userProfiles count]), self.view.frame.size.width, 50.0)];
        createBtn.backgroundColor = [UIColor blackColor];
        [createBtn setTitle:@"Create account" forState:UIControlStateNormal];
        [createBtn addTarget:self action:@selector(accountBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        createBtn.tag=10;
        [self.view addSubview:createBtn];
        [btns addObject:createBtn];
    }
}

-(void)accountBtnPressed:(UIButton*)sender{
    if (sender.tag==10) {
        [self createNewAccount];
    }else{
        [UserProfile getUserProfileWithUserName:sender.titleLabel.text].isActive=[NSNumber numberWithBool:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)createNewAccount{
    UserProfile *userProfile = [UserProfile create];
    userProfile.isActive=[NSNumber numberWithBool:YES];
    [ModelHelper saveManagedObjectContext];
    
    [[ClientController sharedInstance] setupTokensInWebView:self.authWebView];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [self.view bringSubviewToFront:webView];
    NSString* urlString = [[request URL] absoluteString];
    
    NSRange equalRange = [urlString rangeOfString:@":" options:NSBackwardsSearch];
    NSString* stringToCheck = [urlString substringToIndex:equalRange.location + equalRange.length - 1];
    
    if ([stringToCheck isEqualToString:@"gmanager"]) {
        equalRange = [urlString rangeOfString:@"access_token=" options:NSBackwardsSearch];
        
        if ([[urlString substringToIndex:equalRange.location + equalRange.length - 1] isEqualToString:@"gmanager:%23access_token"]) {
            NSString *tokenString = [urlString substringFromIndex:equalRange.location + equalRange.length];

            NSLog(@"%@", tokenString);
            
            if ([UserProfile getToken:1]==nil) {
                [UserProfile getActiveUserProfile].token1=tokenString;
            }else if ([UserProfile getToken:2]==nil){
                [UserProfile getActiveUserProfile].token2=tokenString;
            }else if ([UserProfile getToken:3]==nil){
                [UserProfile getActiveUserProfile].token3=tokenString;
            }else if ([UserProfile getToken:4]==nil){
                [UserProfile getActiveUserProfile].token4=tokenString;
            }
            if ([UserProfile getToken:4]==nil) {
                [[ClientController sharedInstance] setupTokensInWebView:self.authWebView];
            }
        }
    }
    return YES;
}

-(void)userInfoFinished{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)auth{
    if ([UserProfile getActiveUserProfile].token4!=nil) {
        self.authWebView.hidden=YES;
        Insta *insta = [Insta new];
        insta.delegate=self;
        [insta getUserInfo];
        [self createBtns];
    }
}

@end
