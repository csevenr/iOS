//
//  Robot.h
//  Run-Bot
//
//  Created by Oliver Rodden on 19/02/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameViewController;

@interface Robot : UIImageView{
    GameViewController *vc;
}

@property(nonatomic)NSInteger location;//1 = left lane, 2 = middle lane, 3 = right lane.

- (id)initWithViewController:(GameViewController*)vc;
-(void)moveLeft;
-(void)moveRight;
-(void)update;

@end
