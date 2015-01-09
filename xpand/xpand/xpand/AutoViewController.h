//
//  AutoViewController.h
//  xpand
//
//  Created by Oliver Rodden on 02/01/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"

@interface AutoViewController : MasterViewController

@property (weak, nonatomic) IBOutlet UIView *hashtagTextFieldView;
@property (weak, nonatomic) IBOutlet UITextField *hashtagTextField;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;

- (IBAction)startBtnPressed:(id)sender;

@end
