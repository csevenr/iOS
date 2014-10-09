//
//  ProfileViewController.m
//  GramManager
//
//  Created by Oliver Rodden on 09/10/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "ProfileViewController.h"
#import "UserProfile+Helper.h"
#import "LoginViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usernameLbl.text = [UserProfile getActiveUserProfile].userName;
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[UserProfile getActiveUserProfile].profilePictureURL]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error");
        } else {
            self.profilePicImg.image = [UIImage imageWithData:data];
        }
    }];
    self.followersLbl.text = [NSString stringWithFormat:@"%@ %d", self.followersLbl.text,[[UserProfile getActiveUserProfile].followerCount intValue]];
    self.averageLikesLbl.text = [NSString stringWithFormat:@"%@ %d", self.averageLikesLbl.text,[[UserProfile getActiveUserProfile].recentLikes intValue]/[[UserProfile getActiveUserProfile].recentCount intValue]];
    
    self.logoutBtn.layer.borderWidth=2.0;
    self.logoutBtn.layer.borderColor=[UIColor blackColor].CGColor;
    // Do any additional setup after loading the view.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSNumber*)sender{
    if ([segue.identifier isEqualToString:@"login"]){
        [UserProfile getActiveUserProfile].isActive=[NSNumber numberWithBool:NO];
        
        self.loginVc = (LoginViewController*)segue.destinationViewController;
        [self.loginVc setLogin:NO];
    }
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
