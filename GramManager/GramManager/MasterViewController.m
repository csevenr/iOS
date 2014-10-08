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

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"login"]){
        self.loginVc = segue.destinationViewController;
    }
}

@end