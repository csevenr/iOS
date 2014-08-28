//
//  EiiRMAnnotation.m
//  rssMap
//
//  Created by Oliver Rodden on 20/10/2013.
//  Copyright (c) 2013 Oliver Rodden. All rights reserved.
//

#import "EiiRMAnnotation.h"

@implementation EiiRMAnnotation 

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIButton *mainButton = [[UIButton alloc]initWithFrame:CGRectMake(0.0, 0.0, 100.0, 100.0)];
        mainButton.imageView.image=[UIImage imageNamed:@"thumbnail45.png"];
        [mainButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:mainButton];
    }
    return self;
}

-(void)buttonPressed{
    NSLog(@"here3");
}

/*- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
