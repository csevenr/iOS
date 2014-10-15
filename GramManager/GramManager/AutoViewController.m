//
//  ViewController.m
//  GramManager
//
//  Created by Oliver Rodden on 25/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "AutoViewController.h"
#import "Post.h"

@interface AutoViewController (){
    NSString *postId;
    NSString *tokenString;
    NSTimer *mainLoop;
    
    ManualGridViewController *manGridVc;
}
@end

@implementation AutoViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self==[super initWithCoder:aDecoder]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self timerLike];
    if (mainLoop==nil) {
        mainLoop = [NSTimer scheduledTimerWithTimeInterval:36.0 target:self selector:@selector(timerLike) userInfo:nil repeats:YES];
    }
}

-(void)timerLike{
    [self getJSON];
}

-(void)getJSON{
    if (![self.hashtagTextField.text isEqualToString:@""]) {
        [insta getJsonForHashtag:self.hashtagTextField.text];
        [insta setDelegate:self];
    }
}

-(void)JSONReceived:(NSDictionary *)JSONDictionary{
//    for (int i = 0; i<[[JSONDictionary objectForKey:@"data"] count]; i++) {
        NSDictionary *dict = [[JSONDictionary objectForKey:@"data"] objectAtIndex:0];
        Post *post = [[Post alloc]initWithDictionary:dict];
//    }
    
    [insta likePost:post];
    
    NSString *urlForPostImg = [[[[[JSONDictionary objectForKey:@"data"]objectAtIndex:0] objectForKey:@"images"] objectForKey:@"thumbnail"] objectForKey:@"url"];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlForPostImg]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error a");
        } else {
            self.lastLikedImage.image = [UIImage imageWithData:data];
        }
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    if (mainLoop!=nil) {
        [mainLoop invalidate];
        mainLoop=nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
