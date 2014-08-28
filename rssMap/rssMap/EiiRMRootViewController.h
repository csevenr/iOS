//
//  EiiRMRootViewController.h
//  rssMap
//
//  Created by Oliver Rodden on 18/10/2013.
//  Copyright (c) 2013 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EiiRMArticle.h"

@interface EiiRMRootViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate>{

    BOOL itemNode;
    NSInteger articleCount;
}

@property(nonatomic,strong)NSString *currentElement;
@property(nonatomic,strong)NSString *currentString;
@property(nonatomic,strong)NSMutableArray *articles;
@property(nonatomic,strong)EiiRMArticle *article0;
@property(nonatomic,strong)EiiRMArticle *article1;
@property(nonatomic,strong)EiiRMArticle *article2;
@property(nonatomic,strong)EiiRMArticle *article3;
@property(nonatomic,strong)EiiRMArticle *article4;
@property(nonatomic,strong)EiiRMArticle *article5;
@property(nonatomic,strong)EiiRMArticle *article6;

@end
