//
//  Pixel.m
//  PixelArt
//
//  Created by Oliver Rodden on 26/02/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "Pixel.h"
#import "CanvasViewController.h"

@implementation Pixel

- (id)initWithFrame:(CGRect)frame andCanvas:(CanvasViewController*)viewController
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        canvas=viewController;
        [self addTarget:self action:@selector(changeColour) forControlEvents:UIControlEventTouchDown];
    }
    return self;
}

- (id)initWithCanvas:(CanvasViewController*)viewController
{
    self = [super init];
    if (self) {
        // Initialization code
        canvas=viewController;
        [self addTarget:self action:@selector(changeColour) forControlEvents:UIControlEventTouchDown];
        [self setBackgroundImage:[UIImage imageNamed:@"border.png"] forState:UIControlStateNormal];
    }
    return self;
}

-(void)changeColour{
    self.backgroundColor = [canvas currentColour];
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
