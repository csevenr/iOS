//
//  ProfileViewController.h
//  GramManager
//
//  Created by Oliver Rodden on 09/10/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"
#import "LoginViewController.h"

@interface ProfileViewController : MasterViewController <loginDelegate, instaDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profilePicImg;
@property (weak, nonatomic) IBOutlet UILabel *usernameLbl;
@property (weak, nonatomic) IBOutlet UILabel *followersLbl;
@property (weak, nonatomic) IBOutlet UILabel *followingLbl;
@property (weak, nonatomic) IBOutlet UILabel *lastTenPostsLbl;
@property (weak, nonatomic) IBOutlet UILabel *averageLikesLbl;
@property (weak, nonatomic) IBOutlet UILabel *mostLikesLbl;
@property (weak, nonatomic) IBOutlet UILabel *leastLikesLbl;

@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

- (IBAction)xpandPlusBtnPressed:(id)sender;
- (IBAction)logoutBtnPressed;

@end
