//
//  ViewController.h
//  toolset
//
//  Created by Oliver Rodden on 29/04/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdViewController.h"
#import "ProfileViewController.h"

@class ORButton, BurgerButton;

@interface ViewController : AdViewController <UIWebViewDelegate, UIAlertViewDelegate, profileVCDelegate>

//@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *topBar;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIButton *infoBtn;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet BurgerButton *menuBtn;
@property (strong, nonatomic) IBOutletCollection(ORButton) NSArray *orBtns;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *menuBtns;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (weak, nonatomic) IBOutlet UILabel *connectionLbl;
@property (weak, nonatomic) IBOutlet UIImageView *spinnerImgView;

- (void)viewNeedsReload;

- (IBAction)menuBtnPressed;
- (IBAction)menuSwipeClose:(id)sender;

- (IBAction)infoBtnPressed:(id)sender;

- (IBAction)copyFollowBtnPressed:(ORButton*)sender;
- (IBAction)keywordFollowBtnPressed:(ORButton*)sender;
- (IBAction)keywordUserFollowBtnPressed:(ORButton*)sender;
- (IBAction)autoFavBtnPressed:(ORButton*)sender;
- (IBAction)unfollowBtnPressed:(ORButton*)sender;
- (IBAction)whitelistBtnPressed:(ORButton*)sender;
- (IBAction)logoutBtnPressed;

@end

