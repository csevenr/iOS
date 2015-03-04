//
//  AutoViewController.h
//  xpand
//
//  Created by Oliver Rodden on 02/01/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"
#import "Insta.h"

@interface AutoViewController : MasterViewController{
    Insta *insta;
}

@property (weak, nonatomic) IBOutlet UIView *hashtagTextFieldView;
@property (weak, nonatomic) IBOutlet UITextField *hashtagTextField;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *pillBtns;
- (IBAction)startBtnPressed:(id)sender;

@end
