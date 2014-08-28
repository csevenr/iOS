//
//  EiiRMArticleViewController.h
//  rssMap
//
//  Created by Oliver Rodden on 18/10/2013.
//  Copyright (c) 2013 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EiiRMRootViewController.h"

@class EiiRMArticle;

@interface EiiRMArticleViewController : EiiRMRootViewController

@property (nonatomic, assign)UILabel *titleLbl;
@property (nonatomic, assign)UILabel *mediaCreditLbl;
@property (nonatomic, assign)UILabel *pubDateLbl;
@property (nonatomic, assign)EiiRMArticle *article;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withArticle:(EiiRMArticle*)art;

@end
