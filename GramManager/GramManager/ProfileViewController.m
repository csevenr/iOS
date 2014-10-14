//
//  ProfileViewController.m
//  GramManager
//
//  Created by Oliver Rodden on 09/10/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "ProfileViewController.h"
#import "UserProfile+Helper.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
}

-(void)setUpView{
    userProfile = [UserProfile getActiveUserProfile];
    
    self.usernameLbl.text = userProfile.userName;
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:userProfile.profilePictureURL]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error c");
        } else {
            self.profilePicImg.image = [UIImage imageWithData:data];
        }
    }];
    self.profilePicImg.layer.cornerRadius=self.profilePicImg.frame.size.width/2;
    self.profilePicImg.clipsToBounds=YES;
    self.followersLbl.text = [NSString stringWithFormat:@"Followers: %d",[userProfile.followerCount intValue]];
    self.averageLikesLbl.text = [NSString stringWithFormat:@"Average likes: %d",[userProfile.recentLikes intValue]/[userProfile.recentCount intValue]];
    
    self.logoutBtn.layer.borderWidth=2.0;
    self.logoutBtn.layer.borderColor=[UIColor blackColor].CGColor;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSNumber*)sender{
    if ([segue.identifier isEqualToString:@"login"]){
        userProfile.isActive=[NSNumber numberWithBool:NO];
        
        self.loginVc = (LoginViewController*)segue.destinationViewController;
        [self.loginVc setLogin:NO];
        self.loginVc.delegate = self;
    }
}

-(void)loginFinished{
    [self setUpView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
