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
    
    insta = [Insta new];
    
    self.view.backgroundColor = [UIColor colorWithRed:20.0 / 255.0 green:20.0 / 255.0 blue:20.0 / 255.0 alpha:1.0];
    
    for (UIButton *pillBtn in self.pillBtns) {
        pillBtn.layer.borderWidth = 1;
        pillBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        pillBtn.layer.cornerRadius = 12;
    }
    
    self.startBtn.layer.cornerRadius = 4.0;
    
    [self.hashtagTextField setFont:FONT];
    
//    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(4.0, 0.0, 100.0, 30.0)];
//    [backBtn setTitle:@"Back" forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(popSelf) forControlEvents:UIControlEventTouchUpInside];
//    [backBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
//    [backBtn.titleLabel setFont:FONT];
//    [backBtn sizeToFit];
//    [self.view addSubview:backBtn];
}

-(void)viewDidAppear:(BOOL)animated{

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

- (IBAction)pillBtnPressed:(UIButton*)sender {
    NSCharacterSet *charactersToRemove = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    NSString *trimmedReplacement = [[sender.titleLabel.text componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@""];

    self.hashtagTextField.text = trimmedReplacement;
}

- (IBAction)startBtnPressed:(id)sender {
    [insta setUpAutoWithHashtag:self.hashtagTextField.text];
}

@end