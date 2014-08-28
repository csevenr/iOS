//
//  Colliable.m
//  Run-Bot
//
//  Created by Oliver Rodden on 19/02/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "Collidable.h"
#import "GameViewController.h"

@implementation Collidable
@synthesize location;

- (id)initWithViewController:(GameViewController*)viewController
{
    self = [super init];
    if (self) {
        // Initialization code        
        self.frame=CGRectMake(0.0, 0.0, 50.0, 50.0);
        location = (arc4random()%3)+1;
        if (location==1) self.center=CGPointMake(60.0, -60.0);
        if (location==2) self.center=CGPointMake(160.0, -60.0);
        if (location==3) self.center=CGPointMake(260.0, -60.0);
        self.backgroundColor=[UIColor whiteColor];
        
        [UIView animateWithDuration:0.72//bg speed*1.2
                              delay:0.0
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             if (location==1) self.center=CGPointMake(60.0, 628.0);
                             if (location==2) self.center=CGPointMake(160.0, 628.0);
                             if (location==3) self.center=CGPointMake(260.0, 628.0);
                         }
                         completion:^(BOOL finished){
                             [[viewController objectsToRemove]addObject:self];
                             [self offScreen];
                         }];
    }
    return self;
}

-(void)collided{
    [self.delegate robotCollidedWith:self];
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
