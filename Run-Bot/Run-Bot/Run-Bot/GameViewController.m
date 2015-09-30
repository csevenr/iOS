//
//  GameViewController.m
//  Run-Bot
//
//  Created by Oliver Rodden on 18/02/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "GameViewController.h"

#import "StatController.h"
#import "RunBotConstants.h"

#import "Robot.h"
#import "Tree.h"
#ifdef EXTREME
#import "CoinDisplay.h"
#import "Coin.h"
#endif

#define NEWCOLLIDE (arc4random()%20)+20

@interface GameViewController (){
#ifdef EXTREME
    CoinDisplay *coinDisplay;
#endif
    Robot *robot;
    NSTimer *gameTimer;
    BOOL gameOn;
    NSInteger distance;
    NSInteger distanceCountdown;
    NSInteger collidableCountDown;
}

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

//    [_bg setSpeed:2.0];
    
#ifdef EXTREME
    coinDisplay = [CoinDisplay new];
    [self.view addSubview:coinDisplay];
#endif
    
    robot = [[Robot alloc]initWithViewController:self];
    
    UIFont *customFont = [UIFont fontWithName:@"V5ProphitCell" size:20];
    [_distanceLbl setFont:customFont];
    [self.view bringSubviewToFront:_distanceLbl];//+++
    
    _infoBtn.backgroundColor = [UIColor whiteColor];
    _infoBtn.alpha=0.5;
    [self.view bringSubviewToFront:_infoBtn];//+++
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self changeLocationWith:touches];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [self changeLocationWith:touches];
}

-(void)changeLocationWith:(NSSet *)touches{
    for (UITouch *touch in touches){
        CGPoint location = [touch locationInView:self.view];
        if (location.x < self.view.frame.size.width*0.33){
            if (robot.location==1)return;
            if (robot.location==2)[robot moveLeft];
        }else if (location.x <= self.view.frame.size.width*0.66 && location.x >= self.view.frame.size.width*0.33){
            if (robot.location==1)[robot moveRight];
            if (robot.location==2)return;
            if (robot.location==3)[robot moveLeft];
        }else if (location.x >= self.view.frame.size.width*0.66){
            if (robot.location==2)[robot moveRight];
            if (robot.location==3)return;
        }
    }
}

-(void)startGame{
    if (robot==nil) {
        robot = [[Robot alloc]initWithViewController:self];
    }
    
    [self.view addSubview:robot];
    
    if (_collidables==nil) {
        _collidables = [NSMutableArray new];
    }
    
    if (_objectsToRemove==nil) {
        _objectsToRemove = [NSMutableArray new];
    }
    
    distance=0;
    _distanceLbl.text=[NSString stringWithFormat:@"%d",(int)distance];
    distanceCountdown=10;
    
    collidableCountDown = NEWCOLLIDE;//(arc4random()%20)+50;
    
    if (gameTimer==nil) {
        gameTimer = [NSTimer scheduledTimerWithTimeInterval:0.015 target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
    }
    gameOn = YES;
}

-(void)gameLoop{
    if (gameOn) {
        distanceCountdown--;
        if (distanceCountdown==0) {
            distance++;
            distanceCountdown=10;
        }
        _distanceLbl.text=[NSString stringWithFormat:@"%d",(int)distance];
//        [_bg setSpeed:1.8];
        [robot update];//call update on the robot, to avoid multiple timers
        collidableCountDown--;
        if (collidableCountDown==0) {
#ifdef EXTREME
            int ran = (arc4random()%3);
            if (ran==0||ran==1) {
                [self addTree];
            }else{
                [self addCoin];
            }
#else
            [self addTree];
#endif
            collidableCountDown = NEWCOLLIDE;
        }
    }else{
        if ([_collidables count] == 0 && _infoBtn.hidden == YES){
            [_infoBtn setHidden:NO];
        }
    }
    if ([_objectsToRemove count]>0) {
        [_collidables removeObjectsInArray:_objectsToRemove];
        [_objectsToRemove removeAllObjects];
    }
    //check total trees
    //check total missed coins
    //check total coins
}

-(void)addTree{
    Tree *tree = [[Tree alloc]initWithViewController:self];
    tree.delegate=self;
    [self.view addSubview:tree];
    [_collidables addObject:tree];
}

#ifdef EXTREME
-(void)addCoin{
    Coin *coin = [[Coin alloc]initWithViewController:self];
    coin.delegate=self;
    [self.view addSubview:coin];
    [_collidables addObject:coin];
}
#endif

-(void)gameOver{
    gameOn=NO;
//    [_bg setSpeed:2.0];
    [robot removeFromSuperview];
    robot = nil;
    
//    [[StatController sharedInstance] test];
    
    //check best trees
//    [[StatController sharedInstance] checkStat:BESTTREES withValue:[NSString stringWithFormat:@"%d",_treesAvoided]];
    //check best time
    //check total time
    //check best distance
    //check total distance
    //check best missed coins
    //check best coins
}

-(void)robotCollidedWith:(Collidable*)col{
    if ([col isKindOfClass:[Tree class]]){
        [self gameOver];
    }
#ifdef EXTREME
    else if ([col isKindOfClass:[Coin class]]){
        [UIView transitionWithView:col
                          duration:0.4
                           options:UIViewAnimationOptionCurveEaseOut
                        animations:^{
                            col.frame=coinDisplay.frame;
                        }
                        completion:^(BOOL finished){;
                            if (finished) {
                                _currentCoins++;
                                [coinDisplay animFinished];
                            }
                        }];
    }
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)removeInfo{
    [_infoBtn setHidden:YES];
    [self startGame];
}

@end
