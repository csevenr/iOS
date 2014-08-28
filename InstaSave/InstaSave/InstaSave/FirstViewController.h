//
//  FirstViewController.h
//  tabbed
//
//  Created by Oliver Rodden on 02/02/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLParser.h"

@class PictureBlockViewController;

@interface FirstViewController : UIViewController <UIScrollViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    UILabel *titleLbl;
    UITableView *picTableView;
    NSMutableArray *picBlocks;
    XMLParser *parser;
    NSString *searchTerm;
    
    PictureBlockViewController *toSave;
}

-(void)updateCells;
-(void)pictureBlockTapped:(PictureBlockViewController*)picBlock;

@end
