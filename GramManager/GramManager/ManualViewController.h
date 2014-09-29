//
//  ManualViewController.h
//  GramManager
//
//  Created by Oli Rodden on 26/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Insta.h"

@protocol manualViewControllerDelegate <NSObject>

-(void)getRidMan;

@end

@interface ManualViewController : UIViewController <instaDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<manualViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *hashtagTextField;
@property (strong, nonatomic) IBOutlet UITableView *postTableView;

- (IBAction)searchBtnPressed:(id)sender;

@end
