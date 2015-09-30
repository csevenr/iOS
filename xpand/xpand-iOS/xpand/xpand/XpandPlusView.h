//
//  XpandPlusViewController.h
//  xpand
//
//  Created by Oliver Rodden on 08/01/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XpandPlusDelegate <NSObject>

@optional

-(void)subscribeBtnPressed;
-(void)popUpDismissed;
-(void)subscribed;

@end

@interface XpandPlusView : UIView

@property (nonatomic, weak) id<XpandPlusDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *subscribeBtn;

- (IBAction)closeBtnPressed:(id)sender;
- (IBAction)subscribeBtnPressed:(id)sender;
-(void)closeSelf;

@end
