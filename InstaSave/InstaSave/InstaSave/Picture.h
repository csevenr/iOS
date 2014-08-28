//
//  Picture.h
//  InstaSave
//
//  Created by Oliver Rodden on 04/02/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PictureInfo;

@interface Picture : NSManagedObject

@property (nonatomic, retain) NSData * pictureData;
@property (nonatomic, retain) PictureInfo *info;

@end
