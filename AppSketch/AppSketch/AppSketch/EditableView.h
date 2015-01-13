//
//  EditableView.h
//  AppSketch
//
//  Created by Oliver Rodden on 12/01/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditableView;

@protocol EditableViewDelegate <NSObject>

-(void)editableViewDeleteBtnPressed;
-(void)editableViewDetailsBtnPressed;
-(void)editableViewShouldBecomeEditable:(EditableView*)v;
-(void)editableViewShouldBecomeUneditable;

@end

@interface EditableView : UIView

@property (nonatomic, weak) id<EditableViewDelegate> delegate;

@property BOOL editable;

@property UILabel *titleLabel;
@property UIImage *image;

@end
