//
//  ViewController.h
//  GramManager
//
//  Created by Oliver Rodden on 25/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"

#import "ManualGridViewController.h"

@interface AutoViewController : MasterViewController

@property (weak, nonatomic) IBOutlet UITextField *hashtagTextField;
@property (strong, nonatomic) IBOutlet UIImageView *lastLikedImage;

@end

