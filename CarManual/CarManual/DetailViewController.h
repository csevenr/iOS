//
//  DetailViewController.h
//  CarManual
//
//  Created by Oliver Rodden on 02/03/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) NSDictionary *currentSectionDict;

@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainImgViewHeightConstraint;

@end

