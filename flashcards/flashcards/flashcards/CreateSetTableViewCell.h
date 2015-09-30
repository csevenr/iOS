//
//  CreateSetTableViewCell.h
//  flashcards
//
//  Created by Oliver Rodden on 06/05/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreateSetTableViewCellDelegate <NSObject>

-(void)cellIsFinishedWithTitle:(NSString *)title;

@end

@interface CreateSetTableViewCell : UITableViewCell

@property (nonatomic, weak) id<CreateSetTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

- (IBAction)doneBtnPressed:(id)sender;

@end
