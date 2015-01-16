//
//  EntryTableViewCell.m
//  SPENDR
//
//  Created by Oli Rodden on 15/01/2015.
//  Copyright (c) 2015 OliRodd. All rights reserved.
//

#import "EntryTableViewCell.h"

@implementation EntryTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
