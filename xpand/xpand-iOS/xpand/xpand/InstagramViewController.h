//
//  InstagramViewController.h
//  xpand
//
//  Created by Oliver Rodden on 02/01/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"
#import "PaymentViewController.h"

@interface InstagramViewController : MasterViewController <paymentVCDelegate>

@property PaymentViewController *paymentVC;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *mainBtns;

@property (weak, nonatomic) IBOutlet UIImageView *profilePicImgView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLbl;
- (IBAction)AutoBtnPressed:(id)sender;

@end
