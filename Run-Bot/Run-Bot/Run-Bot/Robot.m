//
//  Robot.m
//  Run-Bot
//
//  Created by Oliver Rodden on 19/02/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "Robot.h"
#import "GameViewController.h"
#import "Collidable.h"

@implementation Robot

- (id)initWithViewController:(GameViewController*)viewController
{
    self = [super init];
    if (self) {
        // Initialization code
        vc=viewController;
        
        self.frame=CGRectMake(0.0, 0.0, 60.0, 60.0);
        self.center=CGPointMake(160.0, 510.0);
        self.backgroundColor=[UIColor whiteColor];
        _location=2;
    }
    return self;
}

-(void)moveLeft{
    if (_location!=1) {
        [UIView animateWithDuration:0.05
                              delay:0.0
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                            self.center=CGPointMake(self.center.x-100, 510.0);
                         }
                         completion:^(BOOL finished){
                         }];
        _location--;
    }
}

-(void)moveRight{
    if (_location!=3) {
        [UIView animateWithDuration:0.05
                              delay:0.0
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.center=CGPointMake(self.center.x+100, 510.0);
                         }
                         completion:^(BOOL finished){
                         }];
        _location++;
    }
}

-(void)update{
    [self checkCollisions];
}

-(void)checkCollisions{
    if ([[vc collidables] count]!=0){
        for (Collidable *col in [vc collidables]) {
            if(CGRectIntersectsRect(((CALayer*)col.layer.presentationLayer).frame,
                                    ((CALayer*)self.layer.presentationLayer).frame)){
                [col collided];
            }
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
