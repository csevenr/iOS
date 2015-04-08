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
    
    //some layout stuff
    CGFloat socialBtnY = self.view.frame.size.height - 120;
    self.playAgainButton.center = CGPointMake(self.view.center.x, self.view.center.y - 10.0);
    self.submitScoreBtn.frame = CGRectMake(self.submitScoreBtn.frame.origin.x, socialBtnY - 70, self.submitScoreBtn.frame.size.width, self.submitScoreBtn.frame.size.height);
    self.facebookBtn.frame = CGRectMake(self.facebookBtn.frame.origin.x, socialBtnY, self.facebookBtn.frame.size.width, self.facebookBtn.frame.size.height);
    self.twitterBtn.frame = CGRectMake(self.twitterBtn.frame.origin.x, socialBtnY, self.twitterBtn.frame.size.width, self.twitterBtn.frame.size.height);
    
    self.textFieldHolder.layer.cornerRadius = 10.0;
    
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
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"lastNickname"]) {
        self.nicknameTextField.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"lastNickname"];
    }

    /*------------------UI bits-------------------*/
    
    for (UIButton *btn in self.btnsToStlye) {
        btn.clipsToBounds = NO;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor colorWithWhite:0.87 alpha:1.0];
        
        btn.layer.cornerRadius = 10.0;
        btn.layer.shadowColor = [UIColor colorWithWhite:0.7 alpha:1.0].CGColor;
        btn.layer.shadowOffset = CGSizeMake(0.0, 4.0);
        btn.layer.shadowOpacity = 1.0;
        btn.layer.shadowRadius = 0.1;
    }
    
    /*--------------------------------------------*/
    
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.016 target:self selector:@selector(update) userInfo:nil repeats:YES];
    
    [self newGame];
}

-(void)viewDidAppear:(BOOL)animated{
    self.topJaw.frame=CGRectMake(0.0, -self.topJaw.frame.size.height*0.66, self.topJaw.frame.size.width, self.topJaw.frame.size.height);
    self.bottomJaw.frame=CGRectMake(self.bottomJaw.frame.origin.x, self.view.frame.size.height - self.bottomJaw.frame.size.height / 2.5, self.bottomJaw.frame.size.width, self.bottomJaw.frame.size.height);
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
    }else{
        if (!CGRectContainsPoint(self.textFieldHolder.frame, [(UITouch*)[touches anyObject] locationInView:self.view])) {
            [self.nicknameTextField resignFirstResponder];
        }

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
    NSLog(@"%f", speed);
    [UIView animateWithDuration:speed
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                        self.topJaw.frame=CGRectMake(0.0, (self.view.frame.size.height / 2) - self.topJaw.frame.size.height + 10, self.topJaw.frame.size.width, self.topJaw.frame.size.height);
                         self.bottomJaw.frame=CGRectMake(self.bottomJaw.frame.origin.x, (self.view.frame.size.height / 2) - 10, self.bottomJaw.frame.size.width, self.bottomJaw.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:speed
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                            if (playing) {
                                                self.topJaw.frame=CGRectMake(0.0, -self.topJaw.frame.size.height*0.66, self.topJaw.frame.size.width, self.topJaw.frame.size.height);
                                                self.bottomJaw.frame=CGRectMake(self.bottomJaw.frame.origin.x, self.view.frame.size.height - self.bottomJaw.frame.size.height / 2.5, self.bottomJaw.frame.size.width, self.bottomJaw.frame.size.height);
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
                         self.topJaw.frame=CGRectMake(0.0, (self.view.frame.size.height / 2) - self.topJaw.frame.size.height + 10, self.topJaw.frame.size.width, self.topJaw.frame.size.height);
                         self.bottomJaw.frame=CGRectMake(self.bottomJaw.frame.origin.x, (self.view.frame.size.height / 2) - 10, self.bottomJaw.frame.size.width, self.bottomJaw.frame.size.height);
                         self.scoreLbl.frame=CGRectMake(self.scoreLbl.frame.origin.x, self.scoreLbl.frame.origin.y + 60.0, self.scoreLbl.frame.size.width, self.scoreLbl.frame.size.height);
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
    self.submitScoreBtn.enabled = YES;
    self.submitScoreBtn.alpha = 1.0;
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.topJaw.frame=CGRectMake(0.0, -self.topJaw.frame.size.height*0.66, self.topJaw.frame.size.width, self.topJaw.frame.size.height);
                         self.bottomJaw.frame=CGRectMake(self.bottomJaw.frame.origin.x, self.view.frame.size.height - self.bottomJaw.frame.size.height / 2.5, self.bottomJaw.frame.size.width, self.bottomJaw.frame.size.height);
                         
                         self.scoreLbl.frame=CGRectMake(self.scoreLbl.frame.origin.x, self.scoreLbl.frame.origin.y - 60.0, self.scoreLbl.frame.size.width, self.scoreLbl.frame.size.height);
                         for (UIView *v in self.gameOverCol) {
                             v.alpha=0.0;
                         }
                     }
                     completion:^(BOOL finished){
                         [self newGame];
                     }];
}

- (IBAction)submitScoreBtnPressed:(id)sender {
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.submitScoreView.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                     }];
}

- (IBAction)submitBtnPressed:(id)sender {
    if (self.nicknameTextField.text.length == 0){
        self.nicknameTextField.placeholder = @"You'll need a nickname!!";
        return;
    }
    if (![self checkIfNotAllWhiteSpace:self.nicknameTextField.text]) {
        self.nicknameTextField.text = @"";
        self.nicknameTextField.placeholder = @"Something better then that!! ";
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:self.nicknameTextField.text forKey:@"lastNickname"];
    
    [self.nicknameTextField resignFirstResponder];
    
    [self.submitBtn setTitle:@"Submitting" forState:UIControlStateNormal];
    self.submitBtn.enabled = NO;
    self.submitBtn.alpha = 0.3;
    
    NSString *urlForTag = [NSString stringWithFormat:@"https://xpand.today/biteme/submitscore.php?nickname=%@&score=%d",self.nicknameTextField.text, score];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlForTag]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Submission Failed" message:@"Make sure you've got an internet connection and try again!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.submitBtn.enabled = YES;
                self.submitBtn.alpha = 1.0;
            });
        } else {
            NSDictionary *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
//            NSLog(@"__%@", jsonDictionary);
            if ([[jsonDictionary objectForKey:@"code"] integerValue] == 200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.submitBtn setTitle:@"Successful" forState:UIControlStateNormal];
                    self.submitBtn.alpha = 0.7;
                    
                    self.submitScoreBtn.enabled = NO;
                    self.submitScoreBtn.alpha = 0.3;
                });
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Submission Failed" message:@"Sorry, but your score didn't submit, maybe our servers are down. You could always try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.submitBtn.enabled = YES;
                    self.submitBtn.alpha = 1.0;
                });
            }
        }
    }];
}

-(BOOL)checkIfNotAllWhiteSpace:(NSString*)string{
    NSMutableString *stringToCheckAgainst = [NSMutableString stringWithFormat:@""];
    BOOL notAllWhiteSpace = YES;
    for (int i = 0; i <= 30; i++){
        [stringToCheckAgainst appendString:@" "];
        if ([string isEqualToString:stringToCheckAgainst]){
            notAllWhiteSpace = NO;
        }else{
            notAllWhiteSpace = YES;
        }
    }
    return notAllWhiteSpace;
}

- (IBAction)submitQuitBtnPressed:(id)sender {
    [self.nicknameTextField resignFirstResponder];
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.submitScoreView.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         self.submitBtn.enabled = YES;
                         self.submitBtn.alpha = 1.0;
                         [self.submitBtn setTitle:@"Submit" forState:UIControlStateNormal];
                     }];
}

- (IBAction)leaderboardBtnPressed:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"https://xpand.today/biteme"]]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://xpand.today/biteme"]];
    }
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

#pragma mark textField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if (newLength > 30){
        return NO;
    }
    
    
    NSMutableCharacterSet *allowedCharacters = [NSMutableCharacterSet alphanumericCharacterSet];
    [allowedCharacters formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSCharacterSet *blockedChars = [allowedCharacters invertedSet];
    return ([string rangeOfCharacterFromSet:blockedChars].location == NSNotFound);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.nicknameTextField resignFirstResponder];
    return YES;
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
