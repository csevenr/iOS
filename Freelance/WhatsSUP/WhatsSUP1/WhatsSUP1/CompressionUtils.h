//
//  CompressionUtils.h
//  WhatsSUP1
//
//  Created by Tim Teece on 04/09/2014.
//  Copyright (c) 2014 Tim Teece. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <cloudkit/CloudKit.h>

@interface CompressionUtils : NSObject
+(CKAsset*)compress:(NSData*)buffer;
+(NSData*)compressNSData:(NSData*)buffer;
+(NSData*)deCompress:(CKAsset*)asset expectedDataLength:(size_t)length;
+(NSData*)deCompressNSData:(NSData*)asset expectedDataLength:(size_t)length;
+(NSString *) tmpFile;
+(CKAsset*)convertNSdataDataToCKAsset:(NSData*)data;

@end
