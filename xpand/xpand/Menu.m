//
//  Menu.m
//  GramManager
//
//  Created by Oliver Rodden on 02/10/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "Menu.h"

@interface Menu (){
    BOOL menuActive;
    CGRect originalFrame;
}

@end

@implementation Menu

-(id)initWithFrame:(CGRect)frame{
    if (self==[super initWithFrame:frame]) {
        UIButton *menuBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width, 18.0, 50.0, 50.0)];
        menuBtn.backgroundColor = [UIColor blackColor];
        [menuBtn addTarget:self action:@selector(menuBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:menuBtn];

        /*--Multi account stuff--
        UIButton *switchAccoutnsBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0, 300.0, 270.0, 50.0)];
        switchAccoutnsBtn.backgroundColor = [UIColor blackColor];
        [switchAccoutnsBtn setTitle:@"Switch accounts" forState:UIControlStateNormal];
        [switchAccoutnsBtn addTarget:self action:@selector(switchAccoutnsBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:switchAccoutnsBtn];
        -----------------------*/
        
        menuActive=NO;
    }
    return self;
}

-(void)menuBtnPressed{
    if (!menuActive) {
        originalFrame=self.frame;
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.frame=CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             menuActive=YES;
                         }];
    }else{
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.frame=originalFrame;
                         }
                         completion:^(BOOL finished){
                             menuActive=NO;
                         }];
    }
}

-(void)switchAccoutnsBtnPressed{
    [self menuBtnPressed];
    [self.delegate swicthButtonPressed];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!self.clipsToBounds && !self.hidden && self.alpha > 0) {
        for (UIView *subview in self.subviews.reverseObjectEnumerator) {
            CGPoint subPoint = [subview convertPoint:point fromView:self];
            UIView *result = [subview hitTest:subPoint withEvent:event];
            if (result != nil) {
                return result;
            }
        }
    }
    return nil;
}

@end
