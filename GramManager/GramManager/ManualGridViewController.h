//
//  ManualGridViewController.h
//  GramManager
//
//  Created by Oliver Rodden on 29/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Insta.h"

@protocol manualGridViewControllerDelegate <NSObject>

-(void)getRidManGrid;

@end

@interface ManualGridViewController : UIViewController <instaDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) id<manualGridViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *hashtagTextField;
@property (weak, nonatomic) IBOutlet UICollectionView *postCollView;

- (IBAction)searchBtnPressed:(id)sender;


@end
