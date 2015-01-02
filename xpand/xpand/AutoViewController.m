//
//  AutoViewController.m
//  xpand
//
//  Created by Oliver Rodden on 02/01/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "AutoViewController.h"

@interface AutoViewController ()

@end

@implementation AutoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(4.0, 0.0, 100.0, 30.0)];
    [backBtn setTitle:@"Back" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popSelf) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:FONT];
    [backBtn sizeToFit];
    [self.view addSubview:backBtn];
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
