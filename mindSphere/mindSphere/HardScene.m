//
//  HardScene.m
//  mindSphere
//
//  Created by Oliver Rodden on 22/11/2013.
//  Copyright (c) 2013 Oliver Rodden. All rights reserved.
//

#import "HardScene.h"

@implementation HardScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor redColor];
    }
    return self;
}

@end
