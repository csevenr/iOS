//
//  ViewController.h
//  flashcards
//
//  Created by Oliver Rodden on 05/05/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"
#import "CardSet+Helper.h"

@interface CardViewerViewController : UIViewController

@property (nonatomic) CardSet *currentCardSet;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBtn;

- (IBAction)addBtnPressed:(id)sender;
@end

