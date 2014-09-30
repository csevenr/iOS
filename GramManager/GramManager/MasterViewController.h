//
//  MasterViewController.h
//  GramManager
//
//  Created by Oliver Rodden on 30/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClientController.h"
#import "Insta.h"

@interface MasterViewController : UIViewController <instaDelegate, UIWebViewDelegate>{
    ClientController *cc;
    Insta *insta;
}

@property (nonatomic) IBOutlet UIWebView *authWebView;

-(void)auth;

@end
