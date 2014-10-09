//
//  MasterViewController.m
//  GramManager
//
//  Created by Oliver Rodden on 30/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "MasterViewController.h"
#import "ManualGridViewController.h"
#import "AutoViewController.h"
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
    //add tab bar
    UITabBar *tabBar = [[UITabBar alloc]initWithFrame:CGRectMake(0.0, 518.0, 320.0, 50.0)];
    tabBar.delegate=self;
    [self.view addSubview:tabBar];
    
    UITabBarItem *manBtn = [[UITabBarItem alloc]initWithTitle:@"Manual" image:[UIImage imageNamed:@"manualIcon.png"] tag:0];
    UITabBarItem *autoBtn = [[UITabBarItem alloc]initWithTitle:@"Automatic" image:[UIImage imageNamed:@"autoIcon.png"] tag:1];
    
    [tabBar setItems:[NSArray arrayWithObjects:manBtn, autoBtn, nil]];
    
    if ([self isKindOfClass:[ManualGridViewController class]]) {
        [tabBar setSelectedItem:manBtn];
    }else if ([self isKindOfClass:[AutoViewController class]]){
        [tabBar setSelectedItem:autoBtn];
    }
    
    //add side menu
    menu = [[Menu alloc]initWithFrame:CGRectMake(-self.view.frame.size.width+50.0, 0.0, self.view.frame.size.width-50.0, self.view.frame.size.height)];
    menu.delegate=self;
    menu.backgroundColor = [UIColor blueColor];
    [self.view addSubview:menu];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if ([self isKindOfClass:[ManualGridViewController class]]&&item.tag==1) {
        [self performSegueWithIdentifier:@"auto" sender:nil];
    }else if ([self isKindOfClass:[AutoViewController class]]&&item.tag==0){
        [self performSegueWithIdentifier:@"man" sender:nil];
    }
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