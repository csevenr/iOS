//
//  ViewController.h
//  Bite Me
//
//  Created by Oliver Rodden on 19/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface ViewController : UIViewController <ADBannerViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *topJaw;
@property (weak, nonatomic) IBOutlet UIImageView *bottomJaw;

@property (weak, nonatomic) IBOutlet UILabel *scoreLbl;
@property (weak, nonatomic) IBOutlet UILabel *highscoreLbl;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnsToStlye;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *gameOverCol;

@property (weak, nonatomic) IBOutlet UILabel *charCounter;

@end
