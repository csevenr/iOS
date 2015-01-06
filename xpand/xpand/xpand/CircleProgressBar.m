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

#define FONT [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0]

@interface CircleProgressBar (){
}

@end

@implementation CircleProgressBar

-(id)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]){
        self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width * 0.9, self.frame.size.height * 0.9)];
        self.textLabel.center = self.center;
        self.textLabel.numberOfLines = 0;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
//        self.textLabel.text = @"29 likes remaining";
        self.textLabel.font = FONT;
//        lbl.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.9];
        [self addSubview:self.textLabel];
    }
    return self;
}

-(void)setValue:(float)value{
    if (value == 1.0) {
        self->_value = 0.9;
    }else{
        self->_value = value;
    }
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();

    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:68.0 / 255.0 green:179.0 / 255.0 blue:254.0 / 255.0 alpha:1.0] CGColor]);

    UIBezierPath *darkGrey = [UIBezierPath bezierPath];
    [darkGrey addArcWithCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:self.frame.size.width/2 - 5 startAngle:DEGREES_TO_RADIANS_TOP(0) endAngle:DEGREES_TO_RADIANS_TOP(360) clockwise:YES];

    [darkGrey setLineWidth:3.0];
    [darkGrey stroke];
    
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:100.0 / 255.0 green:14.0 / 255.0 blue:121.0 / 255.0 alpha:1.0] CGColor]);
    
    UIBezierPath *lightGrey = [UIBezierPath bezierPath];
    [lightGrey addArcWithCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:self.frame.size.width/2 - 5 startAngle:DEGREES_TO_RADIANS_TOP(0) endAngle:DEGREES_TO_RADIANS_TOP(360 - (360 * self.value))  clockwise:NO];

    [lightGrey setLineWidth:3.0];
    [lightGrey stroke];
}


@end
