//
//  PictureInfo.h
//  InstaSave
//
//  Created by Oliver Rodden on 04/02/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PictureInfo : NSManagedObject

@property (nonatomic, retain) NSString * mediaCredit;
@property (nonatomic, retain) NSString * pubDate;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSManagedObject *pic;

@end
