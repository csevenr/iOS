//
//  CardView.h
//  flashcards
//
//  Created by Oliver Rodden on 12/05/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardView : UIView

@property (nonatomic) BOOL isInEditMode;

@property IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UITextField *editTitleTextField;
@property IBOutlet UITextView *descLbl;

@property(nonatomic) NSInteger cardId;

@property NSLayoutConstraint *leftCardConstraint;
@property NSLayoutConstraint *rightCardConstraint;
@end
