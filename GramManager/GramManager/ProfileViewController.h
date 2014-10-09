//
//  ProfileViewController.h
//  GramManager
//
//  Created by Oliver Rodden on 09/10/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;

@interface ProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *profilePicImg;
@property (weak, nonatomic) IBOutlet UILabel *usernameLbl;
@property (weak, nonatomic) IBOutlet UILabel *followersLbl;
@property (weak, nonatomic) IBOutlet UILabel *averageLikesLbl;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

@property (nonatomic) LoginViewController *loginVc;

@end
