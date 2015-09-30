//
//  AdViewController.h
//  toolset
//
//  Created by Oliver Rodden on 12/05/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

typedef NS_ENUM(NSUInteger, PageType) {
    PageType_CopyFollow,
    PageType_KeywordFollow,
    PageType_KeywordUserFollow,
    PageType_AutoFavorite,
    PageType_Unfollow,
    PageType_Whitelist,
    PageType_SignIn
};

@interface AdViewController : UIViewController <ADBannerViewDelegate>{
    PageType currentPageType;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;

-(void)hideAd;
-(void)startSpinner;

@end
