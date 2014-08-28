//
//  Pixel.m
//  touch test
//
//  Created by Oliver Rodden on 26/08/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "Pixel.h"

@implementation Pixel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        
    }
    return self;
}

-(void)changeColor:(UIColor*)colour{
    self.backgroundColor=colour;
}

-(void)showHideGrid{
    if (self.layer.borderWidth != 0.0) {
        self.layer.borderWidth = 0.0;
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }else{
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor blackColor].CGColor;
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
