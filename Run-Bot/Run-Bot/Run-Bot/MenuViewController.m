//
//  MenuViewController.m
//  Run-Bot
//
//  Created by Oliver Rodden on 18/02/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "MenuViewController.h"

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
#ifdef EXTREME
    _storeBtn.hidden=NO;
#endif
    
    [_bg setSpeed:2.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
