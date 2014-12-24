//
//  MasterViewController.h
//  GramManager
//
//  Created by Oliver Rodden on 30/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"


@interface LikeMasterViewController : MasterViewController <UITextFieldDelegate>{
}

@property (weak, nonatomic) IBOutlet UITextField *hashtagTextField;
@property (weak, nonatomic) IBOutlet UITableView *hashtagTableView;
@property (nonatomic) IBOutlet UILabel *likeCountLbl;
@property (nonatomic) IBOutlet UIView *searchContainer;

-(void)getJSON;
- (IBAction)searchBtnPressed;
//-(void)showAlertLabelWithString:(NSString*)string;

@end
