//
//  PostTableViewCell.m
//  GramManager
//
//  Created by Oliver Rodden on 29/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "PostTableViewCell.h"

@implementation PostTableViewCell

-(void)setPost:(Post *)post{
    self->_post = post;
    [self setUpCell];
}

-(void)setUpCell{
    self.textLabel.text = [self.post userName];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
