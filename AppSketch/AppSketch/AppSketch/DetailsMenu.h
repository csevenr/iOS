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
-(void)setCurrentViewImage:(UIImage*)image;
-(void)setCurrentViewTitleLabel:(NSString*)string;


@end

@class NKOColorPickerView;

@interface DetailsMenu : UIView <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) id<DetailsMenuDelegate> delegate;

@property (nonatomic, weak) IBOutlet NKOColorPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *backgroundImageButton;
@property (weak, nonatomic) IBOutlet UITextField *textTextField;

- (IBAction)backgroundSegConValueChanged:(UISegmentedControl *)sender;
- (IBAction)chooseImageBtn:(id)sender;

@end
