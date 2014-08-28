//
//  PictureBlockViewController.h
//  InstaSave
//
//  Created by Oliver Rodden on 02/02/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstViewController.h"
@interface PictureBlockViewController : UIViewController <NSURLConnectionDataDelegate,UIGestureRecognizerDelegate> {
    NSMutableData *receivedData;
    UILabel *mediaCreditLbl;
    UIImageView *img;
    UIButton *img2;
    UILabel *titleLbl;
    NSInteger idNo;
    
    NSData *picData;
    
    FirstViewController *VC;
}

@property(nonatomic,strong) NSString *picTitle;
@property(nonatomic,strong) NSString *picPubDate;
@property(nonatomic,strong) NSString *picMediaCredit;
@property(nonatomic,strong) NSString *picLink;
@property(nonatomic,strong) NSData *picData;
@property(nonatomic,assign)NSInteger idNo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andParentViewController:(UIViewController*)viewC;
-(void)updateWithName:(NSString*)name title:(NSString*)title andUrl:(NSString*)url;

@end
