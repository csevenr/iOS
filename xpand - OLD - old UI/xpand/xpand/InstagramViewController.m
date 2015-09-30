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
    for (UIButton *btn in self.mainBtns) {
        [btn setEnabled:NO];
    }
    [self performSegueWithIdentifier:@"payment" sender:nil];
//    [self performSegueWithIdentifier:@"auto" sender:nil];
}

-(void)popUpDismissed{
    for (UIButton *btn in self.mainBtns) {
        [btn setEnabled:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end