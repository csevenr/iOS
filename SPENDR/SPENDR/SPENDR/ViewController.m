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
    
    self.view.backgroundColor = GREEN;
    self.titleLbl.textColor = ORANGE;
    self.balaceLbl.textColor = DARKGREEN;
    self.balaceLbl.text = @"£1660.82";
    self.entryTypeSegCon.tintColor = BLUE;
    self.entryTypeSegCon.selectedSegmentIndex = -1;
    self.entryTableView.backgroundColor = [UIColor clearColor];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
