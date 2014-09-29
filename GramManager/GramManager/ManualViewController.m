//
//  ManualViewController.m
//  GramManager
//
//  Created by Oli Rodden on 26/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "ManualViewController.h"

@implementation ManualViewController

-(id)init{
    if (self=[super init]) {
        UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipedRight)];
        right.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:right];
    }
    return self;
}

- (IBAction)searchBtnPressed:(id)sender {
    [self getJSON];
}

-(void)swipedRight{
    [self.delegate getRid];
}

-(void)getJSON{
    if (![self.hashtagTextField.text isEqualToString:@""]) {
        [[Insta sharedInstance] getJsonForHashtag:self.hashtagTextField.text];
        [[Insta sharedInstance] setDelegate:self];
    }
}

-(void)JSONReceived:(NSDictionary *)JSONDictionary{
    
}

@end
