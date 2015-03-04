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