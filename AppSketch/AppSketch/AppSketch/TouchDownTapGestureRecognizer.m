//
//  TouchDownTapGestureRecognizer.m
//  AppSketch
//
//  Created by Oliver Rodden on 12/01/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "TouchDownTapGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface TouchDownTapGestureRecognizer (){
    id targetForSelectors;
    SEL doTouchDownAction;
    NSTimer *failTimer;
    NSInteger taps;
    CGPoint finalLocation;
}

@end

@implementation TouchDownTapGestureRecognizer

-(id)initWithTarget:(id)target action:(SEL)action secondeAction:(SEL)secondAction{
    if (self == [super initWithTarget:target action:action]) {
        targetForSelectors = target;
        doTouchDownAction = secondAction;
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (![failTimer isValid]) {
        failTimer = [NSTimer scheduledTimerWithTimeInterval:0.35*self.numberOfTapsRequired target:self selector:@selector(failed) userInfo:nil repeats:NO];
        taps=0;
    }
    taps++;// = self.numberOfTapsRequired;
    
    if (self.state == UIGestureRecognizerStatePossible) {
        if (taps == self.numberOfTapsRequired) {
            UITouch *touch = [[event allTouches] anyObject];
            CGPoint location = [touch locationInView:self.view];
            
            finalLocation = location;
            
            [targetForSelectors performSelector:doTouchDownAction withObject:self];
        }
    }
}

//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"moved1");
//    UITouch *touch = [[event allTouches] anyObject];
//    CGPoint location = [touch locationInView:self.view];
//}

- (CGPoint)locationInView:(UIView *)view
{
    return finalLocation;
}

-(void)failed{
    [failTimer invalidate];
    taps = 0;
    self.state = UIGestureRecognizerStateFailed;//maybe need to check if good or not
}

@end
