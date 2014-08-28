//
//  Coin.m
//  Run-Bot
//
//  Created by Oliver Rodden on 14/05/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "Coin.h"

#import "GameViewController.h"

@interface Coin (){
    GameViewController *game;
}

@end

@implementation Coin

- (id)initWithViewController:(GameViewController*)viewController
{
    self = [super initWithViewController:viewController];
    if (self) {
        // Initialization code
        game = viewController;

        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

-(void)offScreen{
    game.coinsMissed++;
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
