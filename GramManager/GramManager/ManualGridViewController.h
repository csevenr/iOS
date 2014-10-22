//
//  ManualGridViewController.h
//  GramManager
//
//  Created by Oliver Rodden on 29/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LikeMasterViewController.h"

@interface ManualGridViewController : LikeMasterViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *searchActivityIndcator;
@property (weak, nonatomic) IBOutlet UICollectionView *postCollView;
@property (weak, nonatomic) IBOutlet UILabel *likeStatusLbl;

//- (IBAction)searchBtnPressed;

@end
