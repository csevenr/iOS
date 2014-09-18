//
//  ViewController.m
//  Dont Get Bitten
//
//  Created by Oliver Rodden on 17/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "ViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@interface ViewController (){
    //Game
    NSTimer *updateTimer;
    BOOL playing;
    
    //Player
    BOOL scoring;
    int score;
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
//    [self facebook];
    [self newGame];
}

-(void)newGame{
    self.view.backgroundColor=[UIColor grayColor];
    
    playing = YES;
    scoring = NO;
    score = 0;
    self.scoreLbl.text = @"0";
    biteCountDown = (arc4random()%100)+50;
    
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.016 target:self selector:@selector(update) userInfo:nil repeats:YES];
}

-(void)update{
    if (playing) {
        if (scoring) {
            score++;
            self.scoreLbl.text = [NSString stringWithFormat:@"%d", score];
            if (CGRectContainsPoint([self.topJaw.layer.presentationLayer frame], fingerLoc)||CGRectContainsPoint([self.bottomJaw.layer.presentationLayer frame], fingerLoc)) {
                [self gameOver];
            }else{
    //            self.view.backgroundColor=[UIColor grayColor];
            }
            biteCountDown--;
            if (biteCountDown<=0) {
                [self bite];
                biteCountDown = (arc4random()%100)+50;
            }
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (playing) {
        scoring=YES;
        fingerLoc = [(UITouch*)[touches anyObject] locationInView:self.view];
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
    float speed = ((arc4random()%10)+20)/100.0;
    [UIView animateWithDuration:speed
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.topJaw.frame=CGRectMake(0.0, 0.0, self.topJaw.frame.size.width, self.topJaw.frame.size.height);
                         self.bottomJaw.frame=CGRectMake(self.bottomJaw.frame.origin.x, 287.0, self.bottomJaw.frame.size.width, self.bottomJaw.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         if (!playing) {
                             
                         }else{
                             [UIView animateWithDuration:speed
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveEaseOut
                                              animations:^{
                                                  self.topJaw.frame=CGRectMake(self.topJaw.frame.origin.x, -204.0, self.topJaw.frame.size.width, self.topJaw.frame.size.height);
                                                  self.bottomJaw.frame=CGRectMake(self.bottomJaw.frame.origin.x, 488.0, self.bottomJaw.frame.size.width, self.bottomJaw.frame.size.height);
                                              }
                                              completion:^(BOOL finished){
                                                  
                                              }];
                         }
                     }];
}

-(void)gameOver{
    playing = NO;
    [self checkHighscore];
    [UIView animateWithDuration:0.6
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         if (self.topJaw.frame.origin.y==-204.0) {
                             self.topJaw.frame=CGRectMake(0.0, 0.0, self.topJaw.frame.size.width, self.topJaw.frame.size.height);
                             self.bottomJaw.frame=CGRectMake(self.bottomJaw.frame.origin.x, 287.0, self.bottomJaw.frame.size.width, self.bottomJaw.frame.size.height);
                         }
                         self.scoreLbl.frame=CGRectMake(self.scoreLbl.frame.origin.x, self.scoreLbl.frame.origin.y+90.0, self.scoreLbl.frame.size.width, self.scoreLbl.frame.size.height);
                         for (UIView *v in self.gameOverCol) {
                             v.alpha=1.0;
                         }
                     }
                     completion:^(BOOL finished){
                     }];
}

-(void)checkHighscore{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"highscore"]==nil){
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[self.scoreLbl.text intValue]] forKey:@"highscore"];
    }else if ([[NSUserDefaults standardUserDefaults]objectForKey:@"highscore"]<self.scoreLbl.text){
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[self.scoreLbl.text intValue]] forKey:@"highscore"];
    }
    self.highscoreLbl.text=[NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"highscore"] intValue]];
}

- (IBAction)playAgainBtnPressed:(id)sender {
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.topJaw.frame=CGRectMake(self.topJaw.frame.origin.x, -204.0, self.topJaw.frame.size.width, self.topJaw.frame.size.height);
                         self.bottomJaw.frame=CGRectMake(self.bottomJaw.frame.origin.x, 488.0, self.bottomJaw.frame.size.width, self.bottomJaw.frame.size.height);
                         
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
