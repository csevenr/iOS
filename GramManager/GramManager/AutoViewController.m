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

- (IBAction)searchBtnPressed {
    if (![self.hashtagTextField.text isEqualToString:@""]) {
        [self timerLike];
        if (mainLoop==nil) {
            mainLoop = [NSTimer scheduledTimerWithTimeInterval:36.0 target:self selector:@selector(timerLike) userInfo:nil repeats:YES];
        }
    }else{
        NSLog(@"no hashtag");
    }
}

-(void)timerLike{
    [self getJSON];
}

-(void)JSONReceived:(NSDictionary *)JSONDictionary{
    NSDictionary *dict = [[JSONDictionary objectForKey:@"data"] objectAtIndex:0];
    Post *post = [[Post alloc]initWithDictionary:dict];
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
    [super textFieldShouldReturn:textField];
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
