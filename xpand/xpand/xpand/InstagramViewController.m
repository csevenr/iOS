//
//  InstagramViewController.m
//  xpand
//
//  Created by Oliver Rodden on 02/01/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "InstagramViewController.h"

@interface InstagramViewController ()

@end

@implementation InstagramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Background
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width * 1.75, self.view.bounds.size.height * 1.2);
    gradient.anchorPoint = CGPointMake(0.5, 0.5);
    gradient.position = (CGPoint){CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)};
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:68.0 / 255.0 green:179.0 / 255.0 blue:254.0 / 255.0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:100.0 / 255.0 green:14.0 / 255.0 blue:121.0 / 255.0 alpha:1.0] CGColor], nil];
    gradient.transform = CATransform3DMakeRotation(-28.0 / 180.0 * M_PI, 0.0, 0.0, 1.0);
    [self.view.layer insertSublayer:gradient atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
