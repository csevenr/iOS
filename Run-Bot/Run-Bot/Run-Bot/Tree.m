//
//  Tree.m
//  Run-Bot
//
//  Created by Oliver Rodden on 14/05/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "Tree.h"

#import "GameViewController.h"

@interface Tree (){
    GameViewController *game;
}

@end

@implementation Tree

- (id)initWithViewController:(GameViewController*)viewController
{
    self = [super initWithViewController:viewController];
    if (self) {
        // Initialization code
        game = viewController;
        
        self.backgroundColor = [UIColor colorWithRed:12.0/255.0 green:110.0/255.0 blue:9.0/255.0 alpha:1.0];
    }
    return self;
}

-(void)offScreen{
    game.treesAvoided++;
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
