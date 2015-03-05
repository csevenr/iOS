//
//  SetUpViewController.m
//  SPENDR
//
//  Created by Oliver Rodden on 05/03/2015.
//  Copyright (c) 2015 OliRodd. All rights reserved.
//

#import "SetUpViewController.h"

@interface SetUpViewController ()

@end

@implementation SetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.nextBtn.layer.cornerRadius = 4.0;
    [self.nextBtn.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.nextBtn.layer setShadowOffset:CGSizeMake(0.0, 2.0)];
    [self.nextBtn.layer setShadowOpacity:0.2];
    [self.nextBtn.layer setShadowRadius:1.0];
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
