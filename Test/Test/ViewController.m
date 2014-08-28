//
//  ViewController.m
//  Test
//
//  Created by Oliver Rodden on 24/10/2013.
//  Copyright (c) 2013 Oliver Rodden. All rights reserved.
//

#import "ViewController.h"

#define NUMBEROFDOTS 100
#define SIZEOFDOTS 3

@interface ViewController ()
@property()NSMutableArray *dots;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dots = [NSMutableArray new];
    
    for (int i=0; i<NUMBEROFDOTS; i++) {
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height-10, SIZEOFDOTS, SIZEOFDOTS)];
        NSLog(@"1 %f",v.frame.origin.x);
        if (i==NUMBEROFDOTS-1) {
            [v setBackgroundColor:[UIColor whiteColor]];
        }else{
            [v setBackgroundColor:[UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1.0]];
        }
        [self.view addSubview:v];
        [_dots addObject:v];
    }}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UIView *v in _dots) {
        [self moveView:v];
    }
}

-(void)moveView:(UIView*)v{
    [UIView transitionWithView:v duration:1.0
                       options:UIViewAnimationOptionCurveEaseOut
                    animations:^{[v setFrame:CGRectMake((arc4random()%(int)self.view.bounds.size.width), (arc4random()%(int)self.view.bounds.size.height), SIZEOFDOTS, SIZEOFDOTS)];}
                    completion:^(BOOL finished){
                        if (finished) {
                            [self moveView2:v];
                        }
                    }];
}

-(void)moveView2:(UIView*)v{
    CGFloat finalDest;
    NSLog(@"2 %f",v.frame.origin.x);
    if (v.frame.origin.x>=160.0) {
        finalDest = v.frame.origin.x*2;
        NSLog(@"3 %f",finalDest);
    }else{
        finalDest = v.frame.origin.x*-2;
        NSLog(@"3 %f",finalDest);
    }
    [UIView transitionWithView:v duration:1.0
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^{[v setFrame:CGRectMake(finalDest, self.view.bounds.size.height-10, SIZEOFDOTS, SIZEOFDOTS)];}
                    completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
