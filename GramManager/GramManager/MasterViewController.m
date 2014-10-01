//
//  MasterViewController.m
//  GramManager
//
//  Created by Oliver Rodden on 30/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "MasterViewController.h"
#import "ModelHelper.h"
#import "UserProfile.h"

@implementation MasterViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self==[super initWithCoder:aDecoder]) {
        
        insta = [Insta new];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.authWebView = [[UIWebView alloc]initWithFrame:self.view.frame];
    self.authWebView.hidden=YES;
    self.authWebView.delegate=self;
    [self.view addSubview:self.authWebView];
    
    cc = [ClientController sharedInstance];
    [cc setupTokensInWebView:self.authWebView];
}

-(void)auth{
//    NSLog(@"auth");
    self.authWebView.hidden=YES;
    if ([cc.tokens count]==4) {
        [self coreDataSetup];
    }
}

-(void)coreDataSetup{
    UserProfile *userProfile = (UserProfile*)[ModelHelper createNewObjectForEntityName:@"UserProfile"];
    userProfile.totalLikesThroughApp = [NSNumber numberWithInt:0];
    [ModelHelper saveManagedObjectContext];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    webView.hidden=NO;
    
    NSString* urlString = [[request URL] absoluteString];
    
    NSRange equalRange = [urlString rangeOfString:@":" options:NSBackwardsSearch];
    NSString* stringToCheck = [urlString substringToIndex:equalRange.location + equalRange.length - 1];
    
    if ([stringToCheck isEqualToString:@"gmanager"]) {
        equalRange = [urlString rangeOfString:@"access_token=" options:NSBackwardsSearch];
        
        if ([[urlString substringToIndex:equalRange.location + equalRange.length - 1] isEqualToString:@"gmanager:%23access_token"]) {
            NSString *tokenString = [urlString substringFromIndex:equalRange.location + equalRange.length];
            
//          NSLog(@"# tokenString: %@", tokenString);
            
            [cc.tokens addObject:tokenString];
//            NSLog(@"%@", cc.tokens);
            if ([cc.tokens count]!=4) {
                [cc setupTokensInWebView:self.authWebView];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:cc.tokens forKey:@"tokens"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }
    return YES;
}

@end
