//
//  CompressionUtils.m
//  WhatsSUP1
//
//  Created by Tim Teece on 04/09/2014.
//  Copyright (c) 2014 Tim Teece. All rights reserved.
//

#import "CompressionUtils.h"
#import <zlib.h>

@implementation CompressionUtils

+(CKAsset*)compress:(NSData*)buffer{
    const void* byteBuf = buffer.bytes;
    CKAsset* ret=nil;
    
    size_t compressedLength = compressBound(buffer.length);
    void* compressedBuffer = (void*)malloc(compressedLength);

    int result = compress2(compressedBuffer, &compressedLength, (unsigned char*)byteBuf, buffer.length, 6);
    
    if (result != Z_OK) // if something went wrong (result != 0)
    {
        NSString* error = @"unknown error";
        switch (result)
        {
            case Z_MEM_ERROR:
                error = @"not enough memory";
                break;
            case Z_BUF_ERROR:
                error = @"output buffer too small";
                break;
        }
        [NSException raise:@"compress failed" format:@"compression failed with error: %@", error];
    }
    
    // write the data to a file and convert into an asset
    NSData *compressedData = [[NSData alloc] initWithBytes:compressedBuffer length:compressedLength];

    // work out where to save the data to...
    NSString* tempFileName=[self tmpFile];
    
    if(tempFileName==nil){
        [NSException raise:@"compress failed" format:@"compression failed with error: %@", @"Error creating temp file"];
    }else{
        // write the data to the file
        NSURL* url = [[NSURL alloc] initFileURLWithPath:tempFileName];
        [compressedData writeToURL:url atomically:true];
        
        // need to create  a CKAsset from this file
        ret = [[CKAsset alloc] initWithFileURL:url];
    }
    
    // free compressed buffer
    free(compressedBuffer);
    
    return ret;
}

+(CKAsset*)convertNSdataDataToCKAsset:(NSData*)data{
    // work out where to save the data to...
    NSString* tempFileName=[self tmpFile];
    CKAsset* ret=nil;

    if(tempFileName==nil){
        [NSException raise:@"compress failed" format:@"compression failed with error: %@", @"Error creating temp file"];
    }else{
        // write the data to the file
        NSURL* url = [[NSURL alloc] initFileURLWithPath:tempFileName];
        [data writeToURL:url atomically:true];
        
        // need to create  a CKAsset from this file
        ret = [[CKAsset alloc] initWithFileURL:url];
    }
    
    return ret;
}


+(NSData*)compressNSData:(NSData*)buffer{
    const void* byteBuf = buffer.bytes;
    
    size_t compressedLength = compressBound(buffer.length);
    void* compressedBuffer = (void*)malloc(compressedLength);
    
    int result = compress2(compressedBuffer, &compressedLength, (unsigned char*)byteBuf, buffer.length, 6);
    
    if (result != Z_OK) // if something went wrong (result != 0)
    {
        NSString* error = @"unknown error";
        switch (result)
        {
            case Z_MEM_ERROR:
                error = @"not enough memory";
                break;
            case Z_BUF_ERROR:
                error = @"output buffer too small";
                break;
        }
        [NSException raise:@"compress failed" format:@"compression failed with error: %@", error];
    }
    
    // write the data to a file and convert into an asset
    NSData *compressedData = [[NSData alloc] initWithBytes:compressedBuffer length:compressedLength];
    
    // free compressed buffer
    free(compressedBuffer);
    
    return compressedData;
}

+(NSData*)deCompress:(CKAsset*)asset expectedDataLength:(size_t)length{
    NSString* filePath = asset.fileURL.path;
    NSData *uncompressedData =nil;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
        
        unsigned long datal = [data length];
        
        Bytef *buffer=(Bytef*)malloc(length);;
        Bytef *dataa=(Bytef*)malloc(datal);
        
        [data getBytes:dataa length:length];
        
        uLong len=length;
        uLong *ld =&len;
        
        uLong sl = datal;
        //*ld = length;
        
        if(uncompress(buffer, ld, dataa, sl) == Z_OK)
        {
            uncompressedData = [NSData dataWithBytes:buffer length:length];
        }
        free(buffer);
        free(dataa);
        
    }else
    {
        NSLog(@"File not exits");
    }
    return uncompressedData;
    

}


+(NSData*)deCompressNSData:(NSData *)data expectedDataLength:(size_t)length{
 
    NSData *uncompressedData =nil;
    unsigned long datal = [data length];
    
    Bytef *buffer=(Bytef*)malloc(length);;
    Bytef *dataa=(Bytef*)malloc(datal);
    
    [data getBytes:dataa length:length];
    
    uLong len=length;
    uLong *ld =&len;
    
    uLong sl = datal;
    //*ld = length;
    
    int retVal=uncompress(buffer, ld, dataa, sl);
    if(retVal == Z_OK)
    {
        uncompressedData = [NSData dataWithBytes:buffer length:length];
    }else{
        NSLog(@"Uncompress error %d",retVal);
    }
    free(buffer);
    free(dataa);

    return uncompressedData;

    
}

+(NSString *) tmpFile {
  NSString *tempFileTemplate = [NSTemporaryDirectory()
                                stringByAppendingPathComponent:@"path-XXXXXX.caf"];
  
  const char *tempFileTemplateCString =
  [tempFileTemplate fileSystemRepresentation];
  
  char *tempFileNameCString = (char *)malloc(strlen(tempFileTemplateCString) + 1);
  strcpy(tempFileNameCString, tempFileTemplateCString);
  int fileDescriptor = mkstemps(tempFileNameCString, 4);
  
  // no need to keep it open
  close(fileDescriptor);
  
  if (fileDescriptor == -1) {
      NSLog(@"Error while creating tmp file");
      return nil;
  }
  
  NSString *tempFileName = [[NSFileManager defaultManager]
                            stringWithFileSystemRepresentation:tempFileNameCString
                            length:strlen(tempFileNameCString)];
  
  free(tempFileNameCString);
  
  return tempFileName;
}
@end
