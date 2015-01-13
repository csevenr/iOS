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
    
    [self.textTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)closeBtnPressed{
    [self.delegate hideDetailsMenu];
}

#pragma mark UITextField Delegate Methods

- (void)textFieldDidChange:(UITextField *)textField {
    [self.delegate setCurrentViewTitleLabel:textField.text];
}

@end