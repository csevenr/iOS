//
//  ViewController.m
//  Bite Me
//
//  Created by Oliver Rodden on 19/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "ViewController.h"
#import <Social/Social.h>

@interface ViewController (){
    //Game
    BOOL instructionsVisable;
    UILabel *instructions;
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
    
    instructionsVisable = NO;
    
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"firstTime"]) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"firstTime"];
        instructions = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.width)];
        instructions.center = self.view.center;
        instructions.text = @"PRESS AND HOLD TO SCORE";
        instructions.textColor = [UIColor whiteColor];
        instructions.font = [UIFont fontWithName:@"AvenirNext-HeavyItalic" size:40.0];
        instructions.numberOfLines = 0;
        instructions.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:instructions];
        
        instructionsVisable = YES;
    }

    /*------------------UI bits-------------------*/
    
    for (UIButton *btn in self.btnsToStlye) {
        btn.clipsToBounds = NO;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        
        btn.layer.cornerRadius = 10.0;
        btn.layer.shadowColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
        btn.layer.shadowOffset = CGSizeMake(0.0, 2.0);
        btn.layer.shadowOpacity = 1.0;
        btn.layer.shadowRadius = 1.0;
    }
    
    /*--------------------------------------------*/
    
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.016 target:self selector:@selector(update) userInfo:nil repeats:YES];
    
    [self newGame];
}

-(void)viewDidAppear:(BOOL)animated{
    self.topJaw.frame=CGRectMake(0.0, -self.topJaw.frame.size.height*0.66, self.topJaw.frame.size.width, self.topJaw.frame.size.height);
    self.bottomJaw.frame=CGRectMake(self.bottomJaw.frame.origin.x, self.view.frame.size.height-self.bottomJaw.frame.size.height/2.5, self.bottomJaw.frame.size.width, self.bottomJaw.frame.size.height);
}

-(void)newGame{
    self.view.backgroundColor=[UIColor grayColor];
    
    playing = YES;
    scoring = NO;
    score = 0;
    self.scoreLbl.text = @"0";
    biteCountDown = (arc4random()%80)+80;
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
                biteCountDown = (arc4random()%80)+80;
            }
        }
    }
}

-(void)score{
    currentTouchScore++;
    if (currentTouchScore > 0 && currentTouchScore <= 20) {
        mod=5;
    }else if (currentTouchScore == 21) {
        mod=4;
        [self showMultiplier:2];
    }else if (currentTouchScore == 41) {
        mod=3;
        [self showMultiplier:3];
    }else if (currentTouchScore == 61) {
        mod=2;
        [self showMultiplier:4];
    }else if (currentTouchScore == 81) {
        mod=1;
        [self showMultiplier:5];
    }
    if (currentTouchScore%mod==0) {
        score++;
    }
}

-(void)showMultiplier:(NSInteger)multiplier{
    UILabel *multiplierLbl = [[UILabel alloc]initWithFrame:CGRectMake(270.0, 6.0, 40.0, 40.0)];
    multiplierLbl.text = [NSString stringWithFormat:@"X%ld", (long)multiplier];
    multiplierLbl.textColor = [UIColor whiteColor];
    multiplierLbl.font = [UIFont fontWithName:@"AvenirNext-HeavyItalic" size:26.0];
    [self.view addSubview:multiplierLbl];
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         multiplierLbl.frame = CGRectMake(multiplierLbl.frame.origin.x, multiplierLbl.frame.origin.y - 10.0, multiplierLbl.frame.size.width, multiplierLbl.frame.size.height);
                         multiplierLbl.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         [multiplierLbl removeFromSuperview];
                     }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (instructionsVisable == YES) {
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             instructions.alpha = 0.0;
                         }
                         completion:^(BOOL finished){
                             [instructions removeFromSuperview];
                         }];
    }
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
                        self.topJaw.frame=CGRectMake(0.0, (self.view.frame.size.height / 2) - self.topJaw.frame.size.height, self.topJaw.frame.size.width, self.topJaw.frame.size.height);
                         self.bottomJaw.frame=CGRectMake(self.bottomJaw.frame.origin.x, self.view.frame.size.height / 2/*-self.bottomJaw.frame.size.height*/ /*287.0*/, self.bottomJaw.frame.size.width, self.bottomJaw.frame.size.height);
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
                         self.topJaw.frame=CGRectMake(0.0, (self.view.frame.size.height / 2) - self.topJaw.frame.size.height, self.topJaw.frame.size.width, self.topJaw.frame.size.height);
                         self.bottomJaw.frame=CGRectMake(self.bottomJaw.frame.origin.x, self.view.frame.size.height / 2 /*-self.bottomJaw.frame.size.height*/ /*287.0*/, self.bottomJaw.frame.size.width, self.bottomJaw.frame.size.height);
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
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:[NSString stringWithFormat:@"Just scored %d on Bite me!", score]];
        [controller addURL:[NSURL URLWithString:@"google.com"]];
        [controller addImage:[self socialScoreImage]];
        [self presentViewController:controller animated:YES completion:Nil];
    }
}

- (IBAction)twitterBtnPressed:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[NSString stringWithFormat:@"Just scored %d on Bite me!", score]];
        [tweetSheet addURL:[NSURL URLWithString:@"google.com"]];
        [tweetSheet addImage:[self socialScoreImage]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}

-(UIImage*)socialScoreImage{
    UIImage *start = [UIImage imageNamed:@"socialBg1080.png"];
    UIImageView *v = [[UIImageView alloc]initWithImage:start];
    
    UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, start.size.width, start.size.height)];
    myLabel.text = self.scoreLbl.text;
    myLabel.font = [UIFont fontWithName:@"AvenirNext-HeavyItalic" size:240.0];
    myLabel.textAlignment = NSTextAlignmentCenter;
    myLabel.textColor = [UIColor whiteColor];
    [v addSubview:myLabel];
    
    UIGraphicsBeginImageContextWithOptions(start.size, NO, 0.0); //retina res
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    [myLabel.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    return image;
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
