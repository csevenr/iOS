//
//  CircleProgressBar.m
//  circleProg
//
//  Created by Oli Rodden on 17/12/2014.
//  Copyright (c) 2014 OliRodd. All rights reserved.
//

#import "CircleProgressBar.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define DEGREES_TO_RADIANS_TOP(angle) DEGREES_TO_RADIANS(angle-90)

@interface CircleProgressBar (){
}

@end

@implementation CircleProgressBar

-(id)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]){
//        UIBezierPath *path = [UIBezierPath new];
//        [path addArcWithCenter:self.center radius:50 startAngle:0 endAngle:2 * M_PI clockwise:YES];
//        value = 0.967;
        
        NSTimer *timerr = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timer) userInfo:nil repeats:YES];

    }
    return self;
}

-(void)timer{
//    count ++;
    [self setNeedsDisplay];
}

-(void)setValue:(float)value{
    self->_value = value;
    [self setNeedsDisplay];
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
 

    
    CGContextRef context = UIGraphicsGetCurrentContext();

    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);

    UIBezierPath *darkGrey = [UIBezierPath bezierPath];
    [darkGrey addArcWithCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:self.frame.size.width/2 - 5 startAngle:DEGREES_TO_RADIANS_TOP(0) endAngle:DEGREES_TO_RADIANS_TOP(360) clockwise:YES];

    [darkGrey setLineWidth:3.0];
    [darkGrey stroke];
    
    CGContextSetStrokeColorWithColor(context, [[UIColor darkGrayColor] CGColor]);
    
    UIBezierPath *lightGrey = [UIBezierPath bezierPath];
    [lightGrey addArcWithCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:self.frame.size.width/2 - 5 startAngle:DEGREES_TO_RADIANS_TOP(0) endAngle:DEGREES_TO_RADIANS_TOP(360 - (360 * self.value))  clockwise:NO];

    [lightGrey setLineWidth:3.0];
    [lightGrey stroke];
}


@end
