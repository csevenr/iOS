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
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(4.0, 0.0, 100.0, 30.0)];
    [backBtn setTitle:@"Back" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popSelf) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:FONT];
    [backBtn sizeToFit];
    [self.view addSubview:backBtn];
}

-(void)viewDidAppear:(BOOL)animated{}

- (IBAction)loginBtnPressed:(id)sender {
    [self createNewAccount];
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
    }
    
    NSRange equalRange0 = [urlString rangeOfString:@"accounts" options:NSBackwardsSearch];
    if(equalRange0.length > 0) {
        webView.hidden=NO;
        [self.view bringSubviewToFront:webView];
        self.authWebView.hidden=NO;
    }
    
    NSRange equalRange = [urlString rangeOfString:@":" options:NSBackwardsSearch];
    NSString* stringToCheck = [urlString substringToIndex:equalRange.location + equalRange.length - 1];
    
    if ([stringToCheck isEqualToString:@"xpand"]) {
        equalRange = [urlString rangeOfString:@"access_token=" options:NSBackwardsSearch];
        
        if ([[urlString substringToIndex:equalRange.location + equalRange.length - 1] isEqualToString:@"xpand:%23access_token"]) {
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
    userProfile = [UserProfile getActiveUserProfile];
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
    NSLog(@"user profile %@", userProfile);
    dispatch_async(dispatch_get_main_queue(), ^{
        [ModelHelper saveManagedObjectContext];
        [self popSelf];
    });
}

-(void)auth{
    if ([tokens count]==4) {
        [self.loginBtn setTitle:@"Retrieving User Info" forState:UIControlStateNormal];
        self.loginBtn.enabled = NO;

        self.authWebView.hidden=YES;
        
        Insta *insta = [Insta new];
        insta.delegate=self;
        [insta getUserInfoWithToken:[tokens objectAtIndex:0]];
    }
}

@end
