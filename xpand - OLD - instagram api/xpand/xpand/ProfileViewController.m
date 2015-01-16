//
//  ProfileViewController.m
//  GramManager
//
//  Created by Oliver Rodden on 09/10/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "ProfileViewController.h"
#import "Insta.h"
#import "UserProfile+Helper.h"
#import "ModelHelper.h"

@interface ProfileViewController () {
    BOOL updated;
    Insta *insta;
}

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_async(dispatch_get_main_queue(), ^{
        insta = [Insta new];
        insta.delegate = self;
        [self setUpView];
    });
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(4.0, 0.0, 100.0, 30.0)];
    [backBtn setTitle:@"Back" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popSelf) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:FONT];
    [backBtn sizeToFit];
    [self.view addSubview:backBtn];
}

-(void)setUpView{
    userProfile = [UserProfile getActiveUserProfile];
    self.usernameLbl.text = userProfile.userName;
    if (userProfile.profilePicture!=nil) {
        self.profilePicImg.image = [UIImage imageWithData:userProfile.profilePicture];
    }
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:userProfile.profilePictureURL]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error c");
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.profilePicImg.image = [UIImage imageWithData:data];
                userProfile.profilePicture = data;
                [ModelHelper saveManagedObjectContext];
            });
        }
    }];
    self.profilePicImg.layer.cornerRadius=self.profilePicImg.frame.size.width/2;
    self.profilePicImg.clipsToBounds=YES;
    self.followersLbl.text = [NSString stringWithFormat:@"Followers: %d",[userProfile.followers intValue]];
    self.followingLbl.text = [NSString stringWithFormat:@"Following: %d",[userProfile.follows intValue]];
    if ([userProfile.recentCount intValue]==1) {//+++ check on 1 and less then 10 posts
        self.lastTenPostsLbl.text = @"Post stats";
    }else if ([userProfile.recentCount intValue]>=10){
        self.lastTenPostsLbl.text = [NSString stringWithFormat:@"Last %d posts",[userProfile.recentCount intValue]];
    }/*else{
      self.lastTenPostsLbl.text = @"Last 10 posts";
      }*/
    self.averageLikesLbl.text = [NSString stringWithFormat:@"Average likes: %d",[userProfile.recentLikes intValue]/[userProfile.recentCount intValue]];
    self.mostLikesLbl.text = [NSString stringWithFormat:@"Most likes: %d",[userProfile.recentMostLikes intValue]];
    self.leastLikesLbl.text = [NSString stringWithFormat:@"Least likes: %d",[userProfile.recentLeastLikes intValue]];
    
    if (!updated) {
//        Insta *insta = [Insta new];
//        insta.delegate = self;
        [insta getUserInfoWithToken:nil];
    }
}

-(void)userInfoFinished{
    updated = YES;
    [self setUpView];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSNumber*)sender{
    if ([segue.identifier isEqualToString:@"login"]){
        userProfile.isActive=[NSNumber numberWithBool:NO];
        
        self.loginVc = (LoginViewController*)segue.destinationViewController;
        self.loginVc.delegate = self;
    }
}

- (IBAction)xpandPlusBtnPressed:(id)sender {
    [self showXpandPlusView];
}

- (IBAction)logoutBtnPressed{
    [insta logout];
    [self.logoutBtn setTitle:@"Logging Out" forState:UIControlStateNormal];
}

-(void)logoutFinished{
    [self popSelf];
}

-(void)loginFinished{
    [self setUpView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
