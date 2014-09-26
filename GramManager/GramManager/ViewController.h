//
//  ViewController.h
//  GramManager
//
//  Created by Oliver Rodden on 25/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIWebViewDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *oAuthWebView;

@property (weak, nonatomic) IBOutlet UITextField *hashtagTextField;

@property (weak, nonatomic) IBOutlet UIImageView *firstImage;

- (IBAction)searchBtnPressed:(id)sender;
- (IBAction)likeBtnPressed:(id)sender;
-(void)auth;

@end

