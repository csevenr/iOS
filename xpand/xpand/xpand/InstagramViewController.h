//
//  InstagramViewController.h
//  xpand
//
//  Created by Oliver Rodden on 02/01/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"

@interface InstagramViewController : MasterViewController

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnsToStyle;

- (IBAction)AutoBtnPressed:(id)sender;

@end
