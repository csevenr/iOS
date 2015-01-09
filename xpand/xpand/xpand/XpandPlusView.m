//
//  XpandPlusViewController.m
//  xpand
//
//  Created by Oliver Rodden on 08/01/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "XpandPlusView.h"

@interface XpandPlusView ()

@end

@implementation XpandPlusView

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super initWithCoder:aDecoder]){
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.cornerRadius = 8.0;
    }
    return self;
}

-(void)awakeFromNib {
    self.subscribeBtn.layer.borderWidth = 1.0;
    self.subscribeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.subscribeBtn.layer.cornerRadius = 8.0;
    
    self.closeBtn.layer.borderWidth = 1.0;
    self.closeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.closeBtn.layer.cornerRadius = 15.0;
}

- (IBAction)closeBtnPressed:(id)sender {
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         self.alpha=0.0;
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }];
}

- (IBAction)subscribeBtnPressed:(id)sender {
    [self.delegate subscribeBtnPressed];
}

@end
