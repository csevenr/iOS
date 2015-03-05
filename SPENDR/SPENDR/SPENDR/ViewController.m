//
//  ViewController.m
//  SPENDR
//
//  Created by Oli Rodden on 15/01/2015.
//  Copyright (c) 2015 OliRodd. All rights reserved.
//

#import "ViewController.h"
#import "EntryTableViewCell.h"

#define GREEN [UIColor colorWithRed:88.0/255.0 green:254.0/255.0 blue:118.0/255.0 alpha:1.0]
#define DARKGREEN [UIColor colorWithRed:44.0/255.0 green:126.0/255.0 blue:59.0/255.0 alpha:1.0]
#define ORANGE [UIColor colorWithRed:254.0/255.0 green:172.0/255.0 blue:88.0/255.0 alpha:1.0]
#define BLUE [UIColor colorWithRed:88.0/255.0 green:210.0/255.0 blue:254.0/255.0 alpha:1.0]
#define RED [UIColor colorWithRed:254.0/255.0 green:88.0/255.0 blue:128.0/255.0 alpha:1.0]

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    self.titleLbl.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    self.balaceLbl.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    self.balaceLbl.text = @"£1660.82";
    self.entryTypeSegCon.tintColor = BLUE;
    self.entryTypeSegCon.selectedSegmentIndex = -1;
    self.entryTableView.backgroundColor = [UIColor clearColor];

    self.formView.layer.cornerRadius = 10.0;
    self.formView.layer.borderWidth = 3.0;
    self.formView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

-(EntryTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EntryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EntryCell"];
    
    if (cell == nil) {
        cell = [[EntryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EntryCell"] ;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == 0) {
        cell.titleLbl.text = @"Montly wage";
        cell.amountLbl.text = @"£1717.00";
        cell.summaryLbl.text = @"Income";
    }else if (indexPath.row == 1){
        cell.titleLbl.text = @"Weekly shop";
        cell.amountLbl.text = @"£47.58";
        cell.summaryLbl.text = @"Food";
    }else if (indexPath.row == 2){
        cell.titleLbl.text = @"Cinema ticket";
        cell.amountLbl.text = @"£8.60";
        cell.summaryLbl.text = @"Fun";
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (IBAction)entryTypeSegConValueChaged:(id)sender {
    NSLog(@"%@", self.formContainerView.constraints);
    [self replaceConstraintOnView:self.formContainerView withConstant:300.0 andAttribute:NSLayoutAttributeTopMargin onSelf:NO];
    [self animateConstraintsWithDuration:0.3 delay:0.0 andCompletionHandler:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)replaceConstraintOnView:(UIView *)view withConstant:(float)constant andAttribute:(NSLayoutAttribute)attribute onSelf:(BOOL)onSelf{
    UIView *viewForConstraints;
    if (onSelf) viewForConstraints = view;
    else viewForConstraints = self.view;
    
    //    NSLog(@"%@", viewForConstraints.constraints);
    
    /*=========================================
     
     THIS SHIT NEEDS UNDERSTANDING AND REWRITING
     
     =========================================*/
    
    [viewForConstraints.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if (constraint.firstItem == view) {
            //            NSLog(@"%@", constraint.firstItem);
            if ((constraint.firstAttribute == attribute)) {
                //                NSLog(@"## %d", constraint.firstAttribute);
                constraint.constant = constant;
                //                NSLog(@"yay");
            }
        }
    }];
}

- (void)animateConstraintsWithDuration:(CGFloat)duration delay:(CGFloat)delay andCompletionHandler:(void (^)(void))completionHandler{
    [UIView animateWithDuration:0.3
                          delay:delay
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                         if (completionHandler) {
                             completionHandler();
                         }
                     }];
    
}

@end
