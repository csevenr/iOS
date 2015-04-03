//
//  ViewController.h
//  Bite Me
//
//  Created by Oliver Rodden on 19/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface ViewController : UIViewController <UITextFieldDelegate, ADBannerViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *topJaw;
@property (weak, nonatomic) IBOutlet UIImageView *bottomJaw;

@property (weak, nonatomic) IBOutlet UILabel *scoreLbl;
@property (weak, nonatomic) IBOutlet UILabel *highscoreLbl;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnsToStlye;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *gameOverCol;

@property (weak, nonatomic) IBOutlet UILabel *charCounter;

@property (weak, nonatomic) IBOutlet UIButton *playAgainButton;
@property (weak, nonatomic) IBOutlet UIButton *submitScoreBtn;
@property (weak, nonatomic) IBOutlet UIButton *facebookBtn;
@property (weak, nonatomic) IBOutlet UIButton *twitterBtn;

@property (weak, nonatomic) IBOutlet UIVisualEffectView *submitScoreView;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UIView *textFieldHolder;

- (IBAction)submitScoreBtnPressed:(id)sender;
- (IBAction)submitBtnPressed:(id)sender;

- (IBAction)submitQuitBtnPressed:(id)sender;
- (IBAction)leaderboardBtnPressed:(id)sender;

@end
