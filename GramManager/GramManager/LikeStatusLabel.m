//
//  LikeStatusLbl.m
//  GramManager
//
//  Created by Oliver Rodden on 08/10/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "LikeStatusLabel.h"

@interface LikeStatusLabel (){
    NSTimer *timer;
}

@end

@implementation LikeStatusLabel

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super initWithCoder:aDecoder]) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(update) userInfo:nil repeats:YES];
    }
    return self;
}

-(void)update{
    
}

@end
