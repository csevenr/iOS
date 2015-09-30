//
//  BurgerButton.m
//  toolset
//
//  Created by Oliver Rodden on 05/05/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "BurgerButton.h"

@interface BurgerButton (){
    NSMutableArray *bitsOfBurger;
    
    CGPoint line1Centre;
    CGPoint line3Centre;
    
    BOOL isBurgerState;
}

@end

@implementation BurgerButton

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super initWithCoder:aDecoder]) {
        bitsOfBurger = [NSMutableArray new];
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(10.0, 16.0, 30.0, 2.0)];
        line1.backgroundColor = [UIColor whiteColor];
        line1.layer.cornerRadius = line1.frame.size.height / 2;
        [self addSubview:line1];
        [bitsOfBurger addObject:line1];
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(10.0, 24.0, 30.0, 2.0)];
        line2.backgroundColor = [UIColor whiteColor];
        line2.layer.cornerRadius = line2.frame.size.height / 2;
        [self addSubview:line2];
        [bitsOfBurger addObject:line2];
        
        UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(10.0, 32.0, 30.0, 2.0)];
        line3.backgroundColor = [UIColor whiteColor];
        line3.layer.cornerRadius = line3.frame.size.height / 2;
        [self addSubview:line3];
        [bitsOfBurger addObject:line3];
        
        line1Centre = line1.center;
        line3Centre = line3.center;
    }
    return self;
}

-(void)animateToCross{
    isBurgerState = NO;
    
    UIView *line1 = [bitsOfBurger objectAtIndex:0];
    UIView *line2 = [bitsOfBurger objectAtIndex:1];
    UIView *line3 = [bitsOfBurger objectAtIndex:2];
    
    float degrees = 45.0;
    float radians = (degrees/180.0) * M_PI;
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                        line1.transform = CGAffineTransformMakeRotation(radians);
                        line3.transform = CGAffineTransformMakeRotation(-radians);
                        
                        line1.center = line2.center;
                        line3.center = line2.center;
                         
                         line2.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

-(void)animateToBurger{
    isBurgerState = YES;
    
    UIView *line1 = [bitsOfBurger objectAtIndex:0];
    UIView *line2 = [bitsOfBurger objectAtIndex:1];
    UIView *line3 = [bitsOfBurger objectAtIndex:2];
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         line1.transform = CGAffineTransformIdentity;
                         line3.transform = CGAffineTransformIdentity;
                         
                         line1.center = line1Centre;
                         line3.center = line3Centre;
                     
                         line2.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

-(void)changeStateToOpenState:(BOOL)openState{
    if (openState) {
        [self animateToCross];
    }else{
        [self animateToBurger];
    }
}

//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self changeState];
//    [super touchesEnded:touches withEvent:event];
//}

@end
