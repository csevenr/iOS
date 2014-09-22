//
//  SavedPathLocations.m
//  WhatsSUP1
//
//  Created by Tim Teece on 03/07/2014.
//  Copyright (c) 2014 Tim Teece. All rights reserved.
//

#import "SavedPathLocations.h"
#import "SavedSUPPath.h"


@implementation SavedPathLocations

@dynamic altitude;
@dynamic degrees;
@dynamic direction;
@dynamic hAcc;
@dynamic lat;
@dynamic lon;
@dynamic speed;
@dynamic stepNo;
@dynamic timestamp;
@dynamic vAcc;
@dynamic inPath;
@dynamic totDistance;
@dynamic cloudKitId;

-(CKToCDMap*) saveToCloudKit:(CKDatabase *)db addToPath:(CKRecordID*)pthid{
    
    if ([self.cloudKitId length] ==0){
        CKRecord * pathRec= [[CKRecord alloc ] initWithRecordType:@"SavedSUPPathLocation"];
        
        [pathRec setObject:self.altitude forKey:@"altitude"];
        [pathRec setObject:self.degrees forKey:@"degrees"];
        [pathRec setObject:self.direction forKey:@"direction"];
        [pathRec setObject:self.hAcc forKey:@"hAcc"];
        
        CLLocation *end = [[CLLocation alloc] initWithLatitude:self.lat.doubleValue longitude:self.lon.doubleValue];
        [pathRec setObject:end forKey:@"loc"];
        
        [pathRec setObject:self.speed forKey:@"speed"];
        [pathRec setObject:self.stepNo forKey:@"stepNo"];
        [pathRec setObject:self.timestamp forKey:@"timestamp"];
        [pathRec setObject:self.vAcc forKey:@"vAcc"];
        [pathRec setObject:self.totDistance forKey:@"totDistance"];
        //CKReference * pathReference=[[CKReference alloc] initWithRecord:pth action:CKReferenceActionNone];
        
        CKReference * pathReference=[[CKReference alloc] initWithRecordID:pthid action:CKReferenceActionNone];
        pathRec[@"PathRef"]=pathReference;
        
        self.cloudKitId=pathRec.recordID.description;

        /*
        [db saveRecord:pathRec completionHandler:^(CKRecord *savedPath,NSError* error){
            if(error!=nil){
                NSLog(@"Something went wrong");
                NSLog(@"%@",error.description);
            }else{
                // save the path values
                NSLog(@"%@",savedPath.recordID.description);
                // link this to the path
                
                self.cloudKitId=savedPath.recordID.description;
                
                @try{
                    NSError* error1=nil;
                    [[self managedObjectContext] save:&error1];
                }@catch(NSException *e){
                    NSLog(@"Error saving to cloud %@", [e description]);
                }
                
            }
        }];*/
        CKToCDMap * ret= [[CKToCDMap alloc] init];
        [ret setCdRef:self];
        [ret setCkRef:pathRec];
        return ret;
    }else{
        return nil;
    }
   
}



@end
