//
//  EiiRMCell.h
//  rssMap
//
//  Created by Oliver Rodden on 18/10/2013.
//  Copyright (c) 2013 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EiiRMArticle;

@interface EiiRMCell : UITableViewCell <NSURLConnectionDataDelegate>

@property (nonatomic, strong)UIImageView *thumbNail;
@property (nonatomic, strong)UILabel *titleLbl;
@property (nonatomic, strong)UILabel *mediaCreditLbl;
@property (nonatomic, strong)UILabel *pubDateLbl;
@property (nonatomic, strong)NSMutableData *receivedData;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withArticle:(EiiRMArticle*)art;

@end
