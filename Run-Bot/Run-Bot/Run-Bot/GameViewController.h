//
//  GameViewController.h
//  Run-Bot
//
//  Created by Oliver Rodden on 18/02/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ScrollingBackground.h"
#import "Tree.h"

@interface GameViewController : UIViewController <collidableDelegate>

@property(nonatomic)NSMutableArray *objectsToRemove;//To prevent enumeration while mutating

@property(nonatomic)NSMutableArray *collidables;
@property(nonatomic)CGFloat speed;//lower number is higher speed vice versa.

@property (weak, nonatomic) IBOutlet ScrollingBackground *bg;
@property (weak, nonatomic) IBOutlet UIButton *infoBtn;
@property (weak, nonatomic) IBOutlet UILabel *distanceLbl;

@property(nonatomic)NSInteger currentCoins;
@property(nonatomic)NSInteger treesAvoided;
@property(nonatomic)NSInteger coinsMissed;

- (IBAction)removeInfo;
-(void)robotCollidedWith:(id)col;
-(void)gameOver;

@end
