//
//  ViewController.m
//  Cells
//
//  Created by Oliver Rodden on 03/03/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDate *startDate = [NSDate date];
    for (int i = 0; i <= 600000; i++) {
        UIView *v = [UIView new];
        [self.view addSubview:v];
    }
    NSLog(@"%f", [[NSDate date] timeIntervalSinceDate:startDate]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
