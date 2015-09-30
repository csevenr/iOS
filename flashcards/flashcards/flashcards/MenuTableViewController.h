//
//  MenuTableViewController.h
//  flashcards
//
//  Created by Oliver Rodden on 05/05/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateSetTableViewCell.h"

@interface MenuTableViewController : UITableViewController <CreateSetTableViewCellDelegate>

- (IBAction)addBtnPressed:(id)sender;

@end
