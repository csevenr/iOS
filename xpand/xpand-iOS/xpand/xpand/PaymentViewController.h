//
//  PaymentViewController.h
//  xpand
//
//  Created by Oli Rodden on 10/03/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Insta.h"

@protocol paymentVCDelegate <NSObject>

-(void)paymentVCFinsihed;

@end

@interface PaymentViewController : UIViewController <UITextFieldDelegate, instaDelegate>

@property (nonatomic, weak) id<paymentVCDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *subscribeBtn;

- (IBAction)subscribeBtnPressed:(id)sender;

@end
