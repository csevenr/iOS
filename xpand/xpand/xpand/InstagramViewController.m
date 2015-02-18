//
//  InstagramViewController.m
//  xpand
//
//  Created by Oliver Rodden on 02/01/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "InstagramViewController.h"
#import "UserProfile+Helper.h"

@interface InstagramViewController ()

@end

@implementation InstagramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Background
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width * 1.75, self.view.bounds.size.height * 1.2);
//    gradient.anchorPoint = CGPointMake(0.5, 0.5);
//    gradient.position = (CGPoint){CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)};
//    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:68.0 / 255.0 green:179.0 / 255.0 blue:254.0 / 255.0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:100.0 / 255.0 green:14.0 / 255.0 blue:121.0 / 255.0 alpha:1.0] CGColor], nil];
//    gradient.transform = CATransform3DMakeRotation(-28.0 / 180.0 * M_PI, 0.0, 0.0, 1.0);
//    [self.view.layer insertSublayer:gradient atIndex:0];
}

-(void)viewDidLayoutSubviews{
    for (UIButton *btn in self.btnsToStyle) {
        if (btn.tag == 1 || btn.tag == 2) {
            UIView *top = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, btn.frame.size.width, btn.frame.size.height/300)];
            top.backgroundColor = [UIColor blackColor];
            top.alpha = 0.1;
            [btn addSubview:top];
        }
        
        if (btn.tag == 0 || btn.tag == 1) {
            UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(0.0, btn.frame.size.height - (btn.frame.size.height/300) - 2, btn.frame.size.width, btn.frame.size.height/300)];
            bottom.backgroundColor = [UIColor whiteColor];
            bottom.alpha = 0.2;
            [btn addSubview:bottom];
        }
    }
}

- (IBAction)AutoBtnPressed:(id)sender {
    [self showXpandPlusView];
}

-(void)subscribeBtnPressed{
    [self performSegueWithIdentifier:@"auto" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end