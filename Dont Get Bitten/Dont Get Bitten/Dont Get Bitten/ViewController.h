//
//  ViewController.h
//  Dont Get Bitten
//
//  Created by Oliver Rodden on 17/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface ViewController : UIViewController <ADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *scoreLbl;
@property (weak, nonatomic) IBOutlet UILabel *highscoreLbl;

@property (weak, nonatomic) IBOutlet UIImageView *topJaw;
@property (weak, nonatomic) IBOutlet UIImageView *bottomJaw;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *gameOverCol;

@property (weak, nonatomic) IBOutlet UILabel *charCounter;

//@property (weak, nonatomic) IBOutlet ADBannerView *adBanner;
- (IBAction)playAgainBtnPressed:(id)sender;
- (IBAction)facebookBtnPressed:(id)sender;
- (IBAction)twitterBtnPressed:(id)sender;

@end
