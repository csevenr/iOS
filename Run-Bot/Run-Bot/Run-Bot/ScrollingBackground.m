//
//  ScrollingBackground.m
//  Run-Bot
//
//  Created by Oliver Rodden on 18/02/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "ScrollingBackground.h"

@interface ScrollingBackground (){
    UIImageView *viewOne;
    UIImageView *viewTwo;
}

@end

@implementation ScrollingBackground

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        viewOne = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, -self.frame.size.height, self.frame.size.width, self.frame.size.height)];
        viewOne.backgroundColor=[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
        [self addSubview:viewOne];
        
        viewTwo = [[UIImageView alloc]initWithFrame:self.frame];
        viewTwo.backgroundColor=[UIColor colorWithRed:0.0 green:0.9 blue:0.0 alpha:1.0];
        [self addSubview:viewTwo];
        
        [self animate];
    }
    return self;
}

-(void)animate{
    viewOne.frame=CGRectMake(0.0, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
    viewTwo.frame=self.frame;
    [UIView animateWithDuration:_speed
                          delay:0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         viewOne.frame=self.frame;
                         viewTwo.frame=CGRectMake(0.0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self animate];
                     }];
}

@end