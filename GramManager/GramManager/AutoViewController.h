//
//  ViewController.h
//  GramManager
//
//  Created by Oliver Rodden on 25/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Insta.h"
#import "ManualViewController.h"
#import "ManualGridViewController.h"

@interface AutoViewController : UIViewController <UIWebViewDelegate, instaDelegate, manualViewControllerDelegate, manualGridViewControllerDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *oAuthWebView;
@property (weak, nonatomic) IBOutlet UITextField *hashtagTextField;
@property (strong, nonatomic) IBOutlet UIImageView *lastLikedImage;

-(void)auth;

@end

