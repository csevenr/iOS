//
//  MenuViewController.h
//  Run-Bot
//
//  Created by Oliver Rodden on 18/02/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollingBackground.h"

@interface MenuViewController : UIViewController

@property (weak, nonatomic) IBOutlet ScrollingBackground *bg;
@property (weak, nonatomic) IBOutlet UIImageView *titleImg;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *statsBtn;
@property (weak, nonatomic) IBOutlet UIButton *storeBtn;

@end
