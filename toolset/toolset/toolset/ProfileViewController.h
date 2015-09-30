//
//  ProfileViewController.h
//  toolset
//
//  Created by Oliver Rodden on 04/05/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdViewController.h"

@protocol profileVCDelegate <NSObject>

-(void)profileVCFinsihed;

@end

@interface ProfileViewController : AdViewController <UIWebViewDelegate>

@property (nonatomic, weak) id<profileVCDelegate> delegate;

@property NSURL *urlToShow;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *topBar;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *spinnerImgView;

//@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)backBtnPressed:(id)sender;

@end
