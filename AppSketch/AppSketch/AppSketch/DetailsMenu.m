//
//  DetailsMenu.m
//  AppSketch
//
//  Created by Oliver Rodden on 13/01/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "DetailsMenu.h"
#import "NKOColorPickerView.h"

@implementation DetailsMenu

-(id)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]){
        
    }
    return self;
}

-(void)awakeFromNib{
    [self.pickerView setDidChangeColorBlock:^(UIColor *color){
        [self.delegate setCurrentViewBackgroundColour:color];
    }];
    
    UIButton *closeMenuBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
    closeMenuBtn.backgroundColor = [UIColor redColor];
    closeMenuBtn.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    closeMenuBtn.layer.borderWidth = 2.0;
    closeMenuBtn.layer.cornerRadius = 15.0;
    [closeMenuBtn setTitle:@"X" forState:UIControlStateNormal];
    [closeMenuBtn addTarget:self action:@selector(closeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeMenuBtn];
    
    self.backgroundImageButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.backgroundImageButton.layer.borderWidth = 3.0;
    self.backgroundImageButton.layer.cornerRadius = 10.0;
    self.backgroundImageButton.clipsToBounds = YES;
    
    [self.textTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)closeBtnPressed{
    [self textFieldShouldReturn:self.textTextField];
    [self.delegate hideDetailsMenu];
}

#pragma mark UITextField Delegate Methods

- (void)textFieldDidChange:(UITextField *)textField {
    [self.delegate setCurrentViewTitleLabel:textField.text];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)backgroundSegConValueChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0){
        self.pickerView.hidden = NO;
        self.backgroundImageButton.hidden = YES;
    }else if (sender.selectedSegmentIndex == 1){
        self.pickerView.hidden = YES;
        self.backgroundImageButton.hidden = NO;
    }
}

- (IBAction)chooseImageBtn:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [(UIViewController*)self.delegate presentViewController:picker animated:YES completion:nil];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *imageToUse;
    if ([info objectForKey:UIImagePickerControllerEditedImage] != nil) {
        imageToUse = [info objectForKey:UIImagePickerControllerEditedImage];
    }else{
        imageToUse = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    [self.backgroundImageButton setImage:imageToUse forState:UIControlStateNormal];
    [self.delegate setCurrentViewImage:imageToUse];
    [(UIViewController*)self.delegate dismissViewControllerAnimated:picker
                                                         completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [(UIViewController*)self.delegate dismissViewControllerAnimated:picker
                                                         completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }];
}

@end