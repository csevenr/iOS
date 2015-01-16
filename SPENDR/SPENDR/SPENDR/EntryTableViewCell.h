//
//  EntryTableViewCell.h
//  SPENDR
//
//  Created by Oli Rodden on 15/01/2015.
//  Copyright (c) 2015 OliRodd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntryTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *changeLbl;
@property (strong, nonatomic) IBOutlet UILabel *amountLbl;
@property (strong, nonatomic) IBOutlet UILabel *titleLbl;
@property (strong, nonatomic) IBOutlet UILabel *summaryLbl;

@end
