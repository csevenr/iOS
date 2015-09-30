//
//  XpandPlusViewController.m
//  xpand
//
//  Created by Oliver Rodden on 08/01/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "XpandPlusView.h"
#import "XpandIAPHelper.h"

@interface XpandPlusView ()

@end

@implementation XpandPlusView

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super initWithCoder:aDecoder]){
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.cornerRadius = 8.0;
        
//        [[XpandIAPHelper sharedInstance] requestProductsWithCompletionHandler:nil];//+++ remove all this shit
    }
    return self;
}

-(void)awakeFromNib {
    self.subscribeBtn.layer.cornerRadius = 4.0;
    [self.subscribeBtn.layer setShadowColor:[UIColor lightGrayColor].CGColor];
    [self.subscribeBtn.layer setShadowOffset:CGSizeMake(0.0, 2.0)];
    [self.subscribeBtn.layer setShadowOpacity:0.5];
    [self.subscribeBtn.layer setShadowRadius:0.0];
}

- (IBAction)closeBtnPressed:(id)sender {
    [self closeSelf];
}

- (IBAction)subscribeBtnPressed:(id)sender {
    [self.delegate subscribeBtnPressed];
}

-(void)closeSelf{
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

@end