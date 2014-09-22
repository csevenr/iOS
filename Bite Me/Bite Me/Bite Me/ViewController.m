//
//  ViewController.m
//  Bite Me
//
//  Created by Oliver Rodden on 19/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    //Game
    NSTimer *updateTimer;
    BOOL playing;
    
    //Player
    BOOL scoring;
    int score;
    int currentTouchScore;
    int mod;
    CGPoint fingerLoc;
    
    //Jaws
    int biteCountDown;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.016 target:self selector:@selector(update) userInfo:nil repeats:YES];    
    
    [self newGame];
}

-(void)viewDidAppear:(BOOL)animated{
    self.topJaw.frame=CGRectMake(0.0, -self.topJaw.frame.size.height*0.66, self.topJaw.frame.size.width, self.topJaw.frame.size.height);
    self.bottomJaw.frame=CGRectMake(self.bottomJaw.frame.origin.x, self.view.frame.size.height-self.bottomJaw.frame.size.height/2.5, self.bottomJaw.frame.size.width, self.bottomJaw.frame.size.height);
    
    NSLog(@"%f, %f, %f, %f",self.topJaw.frame.origin.x, self.topJaw.frame.origin.y, self.topJaw.frame.size.width, self.topJaw.frame.size.height);
    NSLog(@"%f, %f, %f, %f",self.bottomJaw.frame.origin.x, self.bottomJaw.frame.origin.y, self.bottomJaw.frame.size.width, self.bottomJaw.frame.size.height);
}

-(void)newGame{
    self.view.backgroundColor=[UIColor grayColor];
    
    playing = YES;
    scoring = NO;
    score = 0;
    self.scoreLbl.text = @"0";
    biteCountDown = (arc4random()%50)+100;
}

-(void)update{
    if (playing) {
        if (scoring) {
            [self score];
            self.scoreLbl.text = [NSString stringWithFormat:@"%u", score];
            if (CGRectContainsPoint([self.topJaw.layer.presentationLayer frame], fingerLoc)||CGRectContainsPoint([self.bottomJaw.layer.presentationLayer frame], fingerLoc)) {
                [self gameOver];
            }
            biteCountDown--;
            if (biteCountDown<=0) {
                [self bite];
                biteCountDown = (arc4random()%50)+100;
            }
        }
    }
}

-(void)score{
    currentTouchScore++;
    if (currentTouchScore>0&&currentTouchScore<=15) {
        mod=5;
    }else if (currentTouchScore>15&&currentTouchScore<=30) {
        mod=4;
    }else if (currentTouchScore>30&&currentTouchScore<=45) {
        mod=3;
    }else if (currentTouchScore>45) {
        mod=1;
    }
    if (currentTouchScore%mod==0) {
        score++;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (playing) {
        scoring=YES;
        fingerLoc = [(UITouch*)[touches anyObject] locationInView:self.view];
        currentTouchScore=0;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (playing) {
        fingerLoc = [(UITouch*)[touches anyObject] locationInView:self.view];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (playing) {
        scoring=NO;
    }
}

-(void)bite{
    float speed = ((arc4random()%5)+25)/100.0;
    [UIView animateWithDuration:speed
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                        self.topJaw.frame=CGRectMake(0.0, 0.0, self.topJaw.frame.size.width, self.topJaw.frame.size.height);
                         self.bottomJaw.frame=CGRectMake(self.bottomJaw.frame.origin.x, self.view.frame.size.height-self.bottomJaw.frame.size.height /*287.0*/, self.bottomJaw.frame.size.width, self.bottomJaw.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:speed
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                            if (playing) {
                                                self.topJaw.frame=CGRectMake(0.0, -self.topJaw.frame.size.height*0.66, self.topJaw.frame.size.width, self.topJaw.frame.size.height);
                                                self.bottomJaw.frame=CGRectMake(self.bottomJaw.frame.origin.x, self.view.frame.size.height-self.bottomJaw.frame.size.height/2.5, self.bottomJaw.frame.size.width, self.bottomJaw.frame.size.height);
                                            }
                                          }
                                          completion:nil
                          ];
                     }];
}

-(void)gameOver{
    playing = NO;
    [self checkHighscore];
    [UIView animateWithDuration:0.6
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.topJaw.frame=CGRectMake(0.0, 0.0, self.topJaw.frame.size.width, self.topJaw.frame.size.height);
                         self.bottomJaw.frame=CGRectMake(self.bottomJaw.frame.origin.x, self.view.frame.size.height-self.bottomJaw.frame.size.height /*287.0*/, self.bottomJaw.frame.size.width, self.bottomJaw.frame.size.height);
                         self.scoreLbl.frame=CGRectMake(self.scoreLbl.frame.origin.x, self.scoreLbl.frame.origin.y+90.0, self.scoreLbl.frame.size.width, self.scoreLbl.frame.size.height);
                         for (UIView *v in self.gameOverCol) {
                             v.alpha=1.0;
                         }
                     }
                     completion:^(BOOL finished){
                     }];
}

-(void)checkHighscore{
    int highscore = [[[NSUserDefaults standardUserDefaults]objectForKey:@"highscore"] intValue];
    int newScore = [self.scoreLbl.text intValue];
    if (highscore==0||highscore<newScore){
        highscore=newScore;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:highscore] forKey:@"highscore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"set new highscore: %d", highscore);
    }
    self.highscoreLbl.text=[NSString stringWithFormat:@"%d",highscore];
}

- (IBAction)playAgainBtnPressed:(id)sender {
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.topJaw.frame=CGRectMake(0.0, -self.topJaw.frame.size.height*0.66, self.topJaw.frame.size.width, self.topJaw.frame.size.height);
                         self.bottomJaw.frame=CGRectMake(self.bottomJaw.frame.origin.x, self.view.frame.size.height-self.bottomJaw.frame.size.height/2.5, self.bottomJaw.frame.size.width, self.bottomJaw.frame.size.height);
                         
                         self.scoreLbl.frame=CGRectMake(self.scoreLbl.frame.origin.x, self.scoreLbl.frame.origin.y-90.0, self.scoreLbl.frame.size.width, self.scoreLbl.frame.size.height);
                         for (UIView *v in self.gameOverCol) {
                             v.alpha=0.0;
                         }
                     }
                     completion:^(BOOL finished){
                         [self newGame];
                     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark social shizz

- (IBAction)facebookBtnPressed:(id)sender {
}

- (IBAction)twitterBtnPressed:(id)sender {
    
}

#pragma mark iAd shizz

- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         banner.frame=CGRectMake(0.0, self.view.frame.size.height-banner.frame.size.height, banner.frame.size.width, banner.frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];
}
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         banner.frame=CGRectMake(0.0, self.view.frame.size.height, banner.frame.size.width, banner.frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
    return YES;
}
- (void)bannerViewActionDidFinish:(ADBannerView *)banner{}

@end
