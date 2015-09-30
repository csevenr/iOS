//
//  ORButton.m
//  toolset
//
//  Created by Oliver Rodden on 01/05/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "ORButton.h"

#define ORBLACK [UIColor colorWithRed:20.0 / 255.0 green:20.0 / 255.0 blue:20.0 / 255.0 alpha:1.0]
#define ORDARKGREY [UIColor colorWithRed:36.0 / 255.0 green:36.0 / 255.0 blue:36.0 / 255.0 alpha:1.0]
#define ORLIGHTGREY [UIColor colorWithRed:145.0 / 255.0 green:145.0 / 255.0 blue:145.0 / 255.0 alpha:1.0]
#define ORWHITE [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0]
#define ORGOLD [UIColor colorWithRed:255.0 / 255.0 green:218.0 / 255.0 blue:104.0 / 255.0 alpha:1.0]

@interface ORButton (){
    UIView *dot;
}

@end

@implementation ORButton

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super initWithCoder:aDecoder]) {
        dot = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 10.0, 10.0)];
        dot.backgroundColor = [UIColor whiteColor];
        dot.center = CGPointMake(18.0, self.frame.size.height / 2);
        
        dot.layer.cornerRadius = dot.frame.size.width / 2;
        
        [self addSubview:dot];
        dot.hidden = YES;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected == YES) {
        dot.hidden = NO;
        self.contentEdgeInsets = UIEdgeInsetsMake(self.contentEdgeInsets.top, 34.0, self.contentEdgeInsets.bottom, self.contentEdgeInsets.right);
    }else{
        dot.hidden = YES;
        self.contentEdgeInsets = UIEdgeInsetsMake(self.contentEdgeInsets.top, 10.0, self.contentEdgeInsets.bottom, self.contentEdgeInsets.right);
    }
}

@end
