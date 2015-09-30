//
//  CardView.m
//  flashcards
//
//  Created by Oliver Rodden on 12/05/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "CardView.h"

@implementation CardView

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super initWithCoder:aDecoder]) {

    }
    return self;
}

-(void)setIsInEditMode:(BOOL)isInEditMode{
    self->_isInEditMode = isInEditMode;
    
    if (isInEditMode == YES) {
        self.editTitleTextField.text = self.titleLbl.text;
        self.editTitleTextField.hidden = NO;
        [self.editTitleTextField becomeFirstResponder];
        
        [self.descLbl setEditable:YES];
    } else {
        self.titleLbl.text = self.editTitleTextField.text;
        self.editTitleTextField.hidden = YES;
        [self.editTitleTextField resignFirstResponder];
        
        [self.descLbl setEditable:NO];
        [self.descLbl resignFirstResponder];
    }
}

- (void)drawRect:(CGRect)rect {
    
    self.layer.cornerRadius = 4.0;
    self.titleLbl.layer.cornerRadius = 2.0;
    self.descLbl.layer.cornerRadius = 2.0;
    
    self.clipsToBounds = YES;
    self.clipsToBounds = YES;
    self.clipsToBounds = YES;
}

-(void)didMoveToSuperview{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.78571429 constant:0]];
    
}

@end
