//
//  ViewController.m
//  GramManager
//
//  Created by Oliver Rodden on 25/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "AutoViewController.h"
#import "ManualViewController.h"
#import "Post.h"

@interface AutoViewController (){
    NSString *postId;
    NSString *tokenString;
    NSTimer *mainLoop;
    
    ManualViewController *manVc;
}
@end

@implementation AutoViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipedLeft)];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:left];
    
    tokenString = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    if (tokenString == nil) {
        [Insta requestTokenIn:self.oAuthWebView];
        self.oAuthWebView.hidden=NO;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    if (mainLoop==nil) {
        mainLoop = [NSTimer scheduledTimerWithTimeInterval:121.0 target:self selector:@selector(twoMinLike) userInfo:nil repeats:YES];
    }
}

-(void)twoMinLike{
    [self getJSON];
}

-(void)getJSON{
    if (![self.hashtagTextField.text isEqualToString:@""]) {
        [[Insta sharedInstance] getJsonForHashtag:self.hashtagTextField.text];
        [[Insta sharedInstance] setDelegate:self];
    }
}

-(void)JSONReceived:(NSDictionary *)JSONDictionary{
    //create pos objects
//    for (int i = 0; i<[[JSONDictionary objectForKey:@"data"] count]; i++) {
        NSDictionary *dict = [[JSONDictionary objectForKey:@"data"] objectAtIndex:0];
        Post *post = [[Post alloc]initWithDictionary:dict];
//    }
    
    [Insta likePost:post.postId withToken:tokenString];
    
    NSString *urlForPostImg = [[[[[JSONDictionary objectForKey:@"data"]objectAtIndex:0] objectForKey:@"images"] objectForKey:@"thumbnail"] objectForKey:@"url"];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlForPostImg]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error");
        } else {
            self.lastLikedImage.image = [UIImage imageWithData:data];
        }
    }];
}

-(void)swipedLeft{
    if (manVc==nil) {
        manVc = [ManualViewController new];
        manVc.delegate=self;
        [self.view addSubview:manVc.view];
    }
    [mainLoop invalidate];
}

-(void)getRid{
    if (manVc!=nil) {
        [manVc.view removeFromSuperview];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
