//
//  MasterViewController.h
//  FailedBanks
//
//  Created by Oliver Rodden on 27/01/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController{
    NSArray *_failedBankInfos;
}

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (nonatomic, retain) NSArray *failedBankInfos;

@end
