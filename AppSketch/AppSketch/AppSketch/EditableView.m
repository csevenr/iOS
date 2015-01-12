//
//  EditableView.m
//  AppSketch
//
//  Created by Oliver Rodden on 12/01/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "EditableView.h"

@implementation EditableView

-(id)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(changeFrame:)];
        [self addGestureRecognizer:pinch];
    }
    return self;
}

-(void)changeFrame:(UIPinchGestureRecognizer*)pinch{
    NSLog(@"%f", pinch.scale);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
