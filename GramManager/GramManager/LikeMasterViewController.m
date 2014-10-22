//
//  MasterViewController.m
//  GramManager
//
//  Created by Oliver Rodden on 30/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "LikeMasterViewController.h"
#import "ManualGridViewController.h"
#import "AutoViewController.h"
#import "ModelHelper.h"
#import "UserProfile+Helper.h"
#import "LoginViewController.h"

@interface LikeMasterViewController(){
    Menu * menu;
}

@end

@implementation LikeMasterViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self==[super initWithCoder:aDecoder]) {
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    insta = [Insta new];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.likeCountLbl.text=[NSString stringWithFormat:@"%d",[userProfile.likedPosts count]];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self login];
}

-(void)login{
    if ([UserProfile getActiveUserProfile]!=nil) {
        userProfile = [UserProfile getActiveUserProfile];
    }else{
        [self performSegueWithIdentifier:@"login" sender:[NSNumber numberWithBool:YES]];
    }
}

-(void)likedPost{
    self.likeCountLbl.text=[NSString stringWithFormat:@"%d",[userProfile.likedPosts count]];
}

-(void)swicthButtonPressed{
    [UserProfile deactivateCurrentUserProfile];
    userProfile = nil;
    [self login];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSNumber*)sender{
    if ([segue.identifier isEqualToString:@"login"]){
        self.loginVc = segue.destinationViewController;
        [(LoginViewController*)self.loginVc setLogin:[sender boolValue]];
    }
}

@end