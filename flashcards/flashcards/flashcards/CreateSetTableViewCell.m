//
//  CreateSetTableViewCell.m
//  flashcards
//
//  Created by Oliver Rodden on 06/05/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "CreateSetTableViewCell.h"

@implementation CreateSetTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)doneBtnPressed:(id)sender {
    if (![self.nameTextField.text isEqualToString:@""]) {
        [self.delegate cellIsFinishedWithTitle:self.nameTextField.text];
    }
}

@end
