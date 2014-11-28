//
//  PostCollectionViewCell.h
//  GramManager
//
//  Created by Oliver Rodden on 29/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@interface PostCollectionViewCell : UICollectionViewCell

@property (nonatomic) UIImageView *mainImg;

@property (nonatomic) Post *post;

@end
