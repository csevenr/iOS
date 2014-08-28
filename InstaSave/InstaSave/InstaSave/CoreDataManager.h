//
//  CoreDataManager.h
//  InstaSave
//
//  Created by Oliver Rodden on 04/02/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataManager : NSObject

+(void)addNewData:(NSData*)picData withMediaCredit:(NSString*)mediaCred title:(NSString*)titl andPubDate:(NSString*)pDate;
+(NSMutableArray*)getArrayOfPicBlocks;

@end
