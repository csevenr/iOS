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
#import <QuartzCore/QuartzCore.h>

@interface LoginViewController (){
    NSMutableArray *btns;
    UIActivityIndicatorView *activityIndicator;
    NSMutableArray *tokens;
    
    NSString *token;
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
    self.loginBtn.layer.cornerRadius = 4.0;
    [self.loginBtn.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.loginBtn.layer setShadowOffset:CGSizeMake(0.0, 2.0)];
    [self.loginBtn.layer setShadowOpacity:0.2];
    [self.loginBtn.layer setShadowRadius:1.0];
    
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
    [self presentOAuth];
    //--OLD--
    /*
    [self createNewAccount];
     */
}

//-(void)accountBtnPressed:(UIButton*)sender{
//    if (sender.tag==10) {
//        [self createNewAccount];
//        [activityIndicator startAnimating];
//        activityIndicator.hidden = NO;
//    }else{
//        [UserProfile getUserProfileWithUserName:sender.titleLabel.text].isActive=[NSNumber numberWithBool:YES];
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
//}

-(void)presentOAuth{
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://xpand.today/api/"]];
    [self.authWebView loadRequest:requestObj];
    [self.view bringSubviewToFront:self.authWebView];
    self.authWebView.hidden = NO;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString* urlString = [[webView.request URL] absoluteString];

    NSLog(@"%@", urlString);
    
    if ([urlString isEqualToString:@"https://xpand.today/api/json-login.php"]) {
        webView.hidden = YES;

        NSString *str = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"];
//            NSLog(@"%@",str);
        
        NSArray *jsonDictionary=[NSArray arrayWithObject:[NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        
        NSLog(@"%@", jsonDictionary);
        
//        NSLog(@"%@", [[jsonDictionary objectAtIndex:0] objectForKey:@"instagram_access_token"]);
        
        token = [[jsonDictionary objectAtIndex:0] objectForKey:@"instagram_access_token"];
        
        self.loginBtn.enabled = NO;
        
        if (userProfile == nil) {
            userProfile = [UserProfile create];
            userProfile.isActive = [NSNumber numberWithBool:YES];
            userProfile.token = token;
            userProfile.userId = [[jsonDictionary objectAtIndex:0] objectForKey:@"id"];
        }
        
        Insta *insta = [Insta new];
        insta.delegate=self;
        [insta getUserInfo];
    }
}

-(void)userInfoFinished{
    userProfile = [UserProfile getActiveUserProfile];
    dispatch_async(dispatch_get_main_queue(), ^{
        userProfile.token = token;
        [ModelHelper saveManagedObjectContext];
        [self popSelf];
    });
}

//--OLD--
/*
-(void)createNewAccount{
    [[ClientController sharedInstance] setupToken:1 inWebView:self.authWebView];
}
*/

//--OLD--
/*
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
*/

//--OLD--
/*
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
 */

//--OLD--
/*
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
*/
@end
