//
//  ViewController.m
//  Dont Get Bitten
//
//  Created by Oliver Rodden on 17/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    //Game
    NSTimer *updateTimer;
    
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
    [self newGame];
}

-(void)newGame{
    self.view.backgroundColor=[UIColor grayColor];
    
    scoring = NO;
    score = 0;
    biteCountDown = (arc4random()%100)+50;
    
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.016 target:self selector:@selector(update) userInfo:nil repeats:YES];
}

-(void)update{
    NSLog(@"%f, %f, %f, %f",[self.topJaw.layer.presentationLayer frame].origin.x, [self.topJaw.layer.presentationLayer frame].origin.y,self.topJaw.frame.size.width, self.topJaw.frame.size.height);
    if (scoring) {
        score++;
        self.scoreLbl.text = [NSString stringWithFormat:@"%d", score];
        if (CGRectContainsPoint([self.topJaw.layer.presentationLayer frame], fingerLoc)||CGRectContainsPoint([self.bottomJaw.layer.presentationLayer frame], fingerLoc)) {
//            self.view.backgroundColor=[UIColor redColor];
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    scoring=YES;
    fingerLoc = [(UITouch*)[touches anyObject] locationInView:self.view];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    fingerLoc = [(UITouch*)[touches anyObject] locationInView:self.view];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    scoring=NO;
//    self.view.backgroundColor = [UIColor grayColor];
}

-(void)bite{
    float speed = ((arc4random()%10)+20)/100.0;
    NSLog(@"%f, %f",self.topJaw.frame.size.width, self.topJaw.frame.size.height);
    [UIView animateWithDuration:speed
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.topJaw.frame=CGRectMake(0.0, 0.0, self.topJaw.frame.size.width, self.topJaw.frame.size.height);
//                         self.topJaw.frame=CGRectMake(self.topJaw.frame.origin.x, 0, self.topJaw.frame.size.width, self.topJaw.frame.size.height);
//                         self.bottomJaw.frame=CGRectMake(self.bottomJaw.frame.origin.x, 287.0, self.bottomJaw.frame.size.width, self.bottomJaw.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:speed
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
//                                              self.topJaw.frame=CGRectMake(self.bottomJaw.frame.origin.x, self.view.frame.origin.y-self.topJaw.frame.size.height+80.0, self.bottomJaw.frame.size.width, self.bottomJaw.frame.size.height);
//                                              self.bottomJaw.frame=CGRectMake(self.bottomJaw.frame.origin.x, 488.0, self.bottomJaw.frame.size.width, self.bottomJaw.frame.size.height);
                                          }
                                          completion:^(BOOL finished){
                                              
                                          }];
                     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
