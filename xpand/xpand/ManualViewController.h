//
//  ViewController.h
//  xpand
//
//  Created by Oliver Rodden on 27/11/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"
#import "LoginViewController.h"
#import "Insta.h"
#import "ClientController.h"

@class AlertLabel;

@interface ManualViewController : MasterViewController <instaDelegate, loginDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>{
    
    Insta *insta;
    ClientController *cc;

}

@property (weak, nonatomic) IBOutlet UITextField *hashtagTextField;
@property (weak, nonatomic) IBOutlet UITableView *hashtagTableView;
@property (nonatomic) AlertLabel *alertLbl;
@property (nonatomic) IBOutlet UILabel *likeCountLbl;
@property (nonatomic) IBOutlet UIView *searchContainer;

@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *searchActivityIndcator;
@property (weak, nonatomic) IBOutlet UILabel *likeStatusLbl;

@end

