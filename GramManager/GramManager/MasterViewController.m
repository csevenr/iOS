//
//  MasterViewController.m
//  GramManager
//
//  Created by Oliver Rodden on 30/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "MasterViewController.h"
#import "ModelHelper.h"
#import "UserProfile+Helper.h"

@interface MasterViewController(){
    UserProfile *userProfile;
    Menu * menu;
}

@end

@implementation MasterViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self==[super initWithCoder:aDecoder]) {
        insta = [Insta new];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    //add tool bar
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0.0, 524.0, 320.0, 44.0)];
    toolBar.backgroundColor=[UIColor yellowColor];
    [self.view addSubview:toolBar];
    
//    //prepare webview
//    self.authWebView = [[UIWebView alloc]initWithFrame:self.view.frame];
//    self.authWebView.hidden=YES;
//    self.authWebView.delegate=self;
//    [self.view addSubview:self.authWebView];
    
    //add side menu
    menu = [[Menu alloc]initWithFrame:CGRectMake(-self.view.frame.size.width+50.0, 0.0, self.view.frame.size.width-50.0, self.view.frame.size.height)];
    menu.delegate=self;
    menu.backgroundColor = [UIColor blueColor];
    [self.view addSubview:menu];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.likeCountLbl.text=[NSString stringWithFormat:@"%d",[userProfile.likedPosts count]];
}

-(void)viewDidAppear:(BOOL)animated{
    [self login];
}

-(void)login{
    if ([UserProfile getActiveUserProfile]!=nil) {
        userProfile = [UserProfile getActiveUserProfile];
    }else{
        [self performSegueWithIdentifier:@"login" sender:nil];
    }
}

-(void)swicthButtonPressed{
    [UserProfile deactivateCurrentUserProfile];
    userProfile = nil;
    [self login];
}

-(void)auth{
    NSLog(@"Master auth?");
//    NSLog(@"auth");
//    self.authWebView.hidden=YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"login"]){
        self.loginVc = segue.destinationViewController;
    }
}

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (alertView.tag==0) {
//        self.authWebView.hidden=NO;
//        [self.view bringSubviewToFront:self.authWebView];
//        //Add spinner
//        
//        [self createNewAccount];
//    }else if (alertView.tag==1){
//        
//    }
//}

//-(void)createNewAccount{
//    userProfile = [UserProfile create];
//    userProfile.isActive=[NSNumber numberWithBool:YES];
//    [ModelHelper saveManagedObjectContext];
//    
//    cc = [ClientController sharedInstance];
//    [cc setupTokensInWebView:self.authWebView];
//}

//-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    
//    NSString* urlString = [[request URL] absoluteString];
//    
//    NSRange equalRange = [urlString rangeOfString:@":" options:NSBackwardsSearch];
//    NSString* stringToCheck = [urlString substringToIndex:equalRange.location + equalRange.length - 1];
//    
//    if ([stringToCheck isEqualToString:@"gmanager"]) {
//        equalRange = [urlString rangeOfString:@"access_token=" options:NSBackwardsSearch];
//        
//        if ([[urlString substringToIndex:equalRange.location + equalRange.length - 1] isEqualToString:@"gmanager:%23access_token"]) {
//            NSString *tokenString = [urlString substringFromIndex:equalRange.location + equalRange.length];
//            [cc.tokens addObject:tokenString];// --- will be in core data
//            
//            NSLog(@"A");
//            if ([UserProfile getToken:1]==nil) {
//                NSLog(@"1");
//                userProfile.token1=tokenString;
//            }else if ([UserProfile getToken:2]==nil){
//                NSLog(@"2");
//                userProfile.token2=tokenString;
//            }else if ([UserProfile getToken:3]==nil){
//                NSLog(@"3");
//                userProfile.token3=tokenString;
//            }else if ([UserProfile getToken:4]==nil){
//                NSLog(@"4");
//                userProfile.token4=tokenString;
//            }
//            NSLog(@"B");
//            if ([cc.tokens count]!=4) {
//                [cc setupTokensInWebView:self.authWebView];
//                NSLog(@"C");
//            }else{
////                [[NSUserDefaults standardUserDefaults] setObject:cc.tokens forKey:@"tokens"];// --- will be in core data
////                [[NSUserDefaults standardUserDefaults] synchronize];
//            }
//        }
//    }
//    return YES;
//}

@end