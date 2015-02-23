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

-(void)viewDidLayoutSubviews{
//    for (UIButton *btn in self.btnsToStyle) {
//        if (btn.tag == 1 || btn.tag == 2) {
//            UIView *top = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, btn.frame.size.width, 1.0)];
//            top.backgroundColor = [UIColor blackColor];
//            top.alpha = 0.1;
//            [btn addSubview:top];
//        }
//        
//        if (btn.tag == 0 || btn.tag == 1) {
//            UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(0.0, btn.frame.size.height - 1.0, btn.frame.size.width, 1.0)];
//            bottom.backgroundColor = [UIColor whiteColor];
//            bottom.alpha = 0.2;
//            [btn addSubview:bottom];
//        }
//    }
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