//
//  ViewController.m
//  GramManager
//
//  Created by Oliver Rodden on 25/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "ViewController.h"
#import "Insta.h"

#define CLIENTID @"c4b88ed082c246b0bb4d12a0c1b8d59d"
#define CLIENTSECRET @"6710fd780b504f9eb627eaf337d39759"
#define REDIRECTURI @"gManager://"

@interface ViewController (){
    NSString *tokenString;
    NSString *postId;
}
@end

@implementation ViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    tokenString = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    if (tokenString == nil) {
        [Insta requestTokenIn:self.oAuthWebView];
        self.oAuthWebView.hidden=NO;
    }
}

- (IBAction)searchBtnPressed:(id)sender {
    NSLog(@"searchBtnPressed");
    if (![self.hashtagTextField.text isEqualToString:@""]) {
        
    }
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString* urlString = [[request URL] absoluteString];
    
    NSRange equalRange = [urlString rangeOfString:@":" options:NSBackwardsSearch];
    NSString* stringToCheck = [urlString substringToIndex:equalRange.location + equalRange.length - 1];
    
    if ([stringToCheck isEqualToString:@"gmanager"]) {
        equalRange = [urlString rangeOfString:@"access_token=" options:NSBackwardsSearch];
        tokenString = [urlString substringFromIndex:equalRange.location + equalRange.length];
        
//        NSLog(@"# tokenString: %@", tokenString);
        [[NSUserDefaults standardUserDefaults] setObject:tokenString forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return YES;
}

-(void)auth{
    NSLog(@"auth");
    self.oAuthWebView.hidden=YES;
}



- (IBAction)getJSONBtnPressed:(id)sender {
   
}

- (IBAction)likeBtnPressed:(id)sender {
    NSString *urlForLike = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/likes?access_token=%@", postId, tokenString];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlForLike]];
    [req setHTTPMethod:@"POST"];
    [NSURLConnection sendAsynchronousRequest:req queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlForLike]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error");
        } else {
            NSDictionary *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"## %@", jsonDictionary);
            NSLog(@"post with id: %@ liked",postId);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
