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
    Insta *insta;
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
}

-(void)viewDidAppear:(BOOL)animated{}

- (IBAction)loginBtnPressed:(id)sender {
    [self presentOAuth];

}

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
            userProfile.userId = [[jsonDictionary objectAtIndex:0] objectForKey:@"xpand_id"];
        }
        
        insta = [Insta new];
        insta.delegate=self;
        [insta getUserInfo];
    }
}

-(void)userInfoFinished{
    userProfile = [UserProfile getActiveUserProfile];
    dispatch_async(dispatch_get_main_queue(), ^{
        userProfile.token = token;
        [ModelHelper saveManagedObjectContext];
        insta.delegate = nil;
        [self popSelf];
    });
}

@end
