//
//  DetailsMenu.h
//  AppSketch
//
//  Created by Oliver Rodden on 13/01/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailsMenuDelegate <NSObject>

-(void)hideDetailsMenu;
-(void)setCurrentViewBackgroundColour:(UIColor*)colour;
-(void)setCurrentViewTitleLabel:(NSString*)string;

@end

@class NKOColorPickerView;

@interface DetailsMenu : UIView <UITextFieldDelegate>

@property (nonatomic, weak) id<DetailsMenuDelegate> delegate;

@property (nonatomic, weak) IBOutlet NKOColorPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITextField *textTextField;

@end
