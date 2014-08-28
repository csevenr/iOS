//
//  CoinDisplay.m
//  Run-Bot
//
//  Created by Oliver Rodden on 20/05/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "CoinDisplay.h"

#import "GameViewController.h"

@interface CoinDisplay (){
    GameViewController *game;
    
    UIImageView *coin;
    UILabel *coinLbl;
}

@end

@implementation CoinDisplay

- (id)initWithFrame:(CGRect)frame andGame:(GameViewController*)viewController
{
    self = [super initWithFrame:frame];
    if (self) {
        game=viewController;
        
        self.frame=CGRectMake(270.0, 10.0, 40.0, 40.0);//set this here for ease with animation
        
        coin = [UIImageView new];
        coin.backgroundColor = [UIColor yellowColor];
        coin.frame=CGRectMake(0.0, 0.0, 40.0, 40.0);
        [self addSubview:coin];
        
        coinLbl = [UILabel new];
        coinLbl.frame=CGRectMake(-12.0, 40.0, 64.0, 20.0);
        coinLbl.text=[NSString stringWithFormat:@"%d",game.currentCoins];
        coinLbl.textAlignment=NSTextAlignmentCenter;
        [self addSubview:coinLbl];
        
        UIFont *customFont = [UIFont fontWithName:@"V5ProphitCell" size:16];
        [coinLbl setFont:customFont];
    }
    return self;
}

-(void)animFinished{
    coinLbl.text=[NSString stringWithFormat:@"%d",game.currentCoins];
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
