//
//  ViewController.h
//  SPENDR
//
//  Created by Oli Rodden on 15/01/2015.
//  Copyright (c) 2015 OliRodd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *titleLbl;
@property (strong, nonatomic) IBOutlet UILabel *balaceLbl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *entryTypeSegCon;
@property (strong, nonatomic) IBOutlet UITableView *entryTableView;
@property (strong, nonatomic) IBOutlet UIView *formContainerView;
@property (strong, nonatomic) IBOutlet UIView *formView;

- (IBAction)entryTypeSegConValueChaged:(id)sender;
@end

