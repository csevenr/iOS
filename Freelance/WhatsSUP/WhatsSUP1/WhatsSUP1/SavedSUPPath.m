//
//  SavedSUPPath.m
//  WhatsSUP1
//
//  Created by Tim Teece on 03/07/2014.
//  Copyright (c) 2014 Tim Teece. All rights reserved.
//

#import "SavedSUPPath.h"
#import "TSavedPathLocation.h"
#import "CompressionUtils.h"
#import <cloudkit/CloudKit.h>
#import  "CKToCDMap.h"
#import  "ScaleSaver.h"

@implementation SavedSUPPath

@dynamic averageSpeed;
@dynamic date;
@dynamic endDate;
@dynamic inCloud;
@dynamic inFaceBook;
@dynamic inTwitter;
@dynamic distance;
@dynamic endLat;
@dynamic endLon;
@dynamic eventCount;
@dynamic maxLat;
@dynamic maxLon;
@dynamic minLat;
@dynamic minLon;
@dynamic rate;
@dynamic startLat;
@dynamic startLon;
@dynamic topAltitude;
@dynamic topSpeed;
@dynamic user;
@dynamic name;
@dynamic desc;
@dynamic waveHeight;
@dynamic weather;
@dynamic windSpeed;
@dynamic cloudKitId;
@dynamic fullypostedtocloud;
@dynamic compressedPath;
@dynamic uncompressedPath;
@dynamic uncompressedLength;

// these are the different scale levels to store items at, size is in meters
static double scaleArray[] = { 256.0, 1024.0, 4069.0, 16384.0, 65536.0, 262144.0,1048576.0};
static int sizeOfScaleArray=7;

- (void)awakeFromFetch {
    [super awakeFromFetch];
    [self setUncompressedPath:nil]; // to be completed thorugh get orderedpath

}

-(void)initNew{
    if ([self uncompressedPath]==nil)
        [self setUncompressedPath:[[NSMutableArray alloc] init]];
    
}

- (void)willSave {
    // compress the array and set the value
    if([self compressedPath]==nil)
        [self updateCompressedData];
    [super willSave];
}

-(void)updateCompressedData{
    if([self uncompressedPath]!=nil){
        if ([[self uncompressedPath]  count]>0){
            // archive the data array
            NSData *dataarray = [NSKeyedArchiver archivedDataWithRootObject:[self uncompressedPath]];
            if (dataarray != nil) {
                NSData *compressedData=[CompressionUtils compressNSData:dataarray];
                [self setCompressedPath:compressedData];
                //[self setPrimitiveValue:[NSKeyedArchiver archivedDataWithRootObject:compressedData] forKey:@"compressedPath"];
                NSNumber *size=[[NSNumber alloc] initWithUnsignedLong:[dataarray length]];
                [self setUncompressedLength:size];
//                [self setPrimitiveValue:[NSKeyedArchiver archivedDataWithRootObject:size]
//                                 forKey:@"uncompressedLength"];
                NSLog(@"Number of items to be saved : %d",[[self uncompressedPath] count]);
            }else {
                [self setPrimitiveValue:nil forKey:@"compressedPath"];
            }
        }else {
            [self setPrimitiveValue:nil forKey:@"compressedPath"];
        }
    }else {
        [self setPrimitiveValue:nil forKey:@"compressedPath"];
    }
    
}
    
- (void)addPathObject:(TSavedPathLocation *)value {
    /*NSMutableArray* tempSet = [NSMutableArray arrayWithArray:self.path ];
    [tempSet addObject:value];
    self.path = tempSet;
     */
    /*NSMutableSet *tempSet= [NSMutableSet setWithSet:self.path];
    [tempSet addObject:value];
    self.path=tempSet;*/
    
    [[self uncompressedPath] addObject:value];
}

-(NSArray*)getOrderedPath{
    if ([self uncompressedPath]==nil){
        if ([self compressedPath]!=nil){
            // decompress the path into the array
            if ([self uncompressedLength]!=nil) {
                // we can uncompress the data
                unsigned long size=[[self uncompressedLength] unsignedLongValue];
                NSData* uncompressedData=[CompressionUtils deCompressNSData:[self compressedPath] expectedDataLength:size];
                [self setUncompressedPath:[NSKeyedUnarchiver unarchiveObjectWithData:uncompressedData]];
            }else{
                [self setUncompressedPath:[[NSMutableArray alloc] init]];
            }
        }else{
            [self setUncompressedPath:[[NSMutableArray alloc] init]];
        }
    }
    return [self uncompressedPath];
/*    NSSortDescriptor* sd= [NSSortDescriptor sortDescriptorWithKey:@"totDistance" ascending:true];
    if (self.path!=nil){
        return [self.path sortedArrayUsingDescriptors:[NSArray arrayWithObject:sd]];
    }else{
        return [[NSArray alloc] init];
    }*/
}

-(void)complete{
    // if anything needs puttin in here do it now.
}

- (NSNumber*)getAverageSpeed{
    double total=0;
    NSArray* pth=[self getOrderedPath];
    for (int x=0;x<pth.count;x++){
        TSavedPathLocation *ssl= pth[x];
        total=total + ssl.speed.doubleValue;
    }

    double retVal=total/pth.count;
    return [[NSNumber alloc ] initWithDouble:retVal];
    
}

- (NSNumber*)getMaxSpeed{
    double topSpeed=0;
    NSArray* pth=[self getOrderedPath];

    for (int x=0;x<pth.count;x++){
        TSavedPathLocation *ssl= pth[x];
        if (ssl.speed.doubleValue > topSpeed)
            topSpeed=ssl.speed.doubleValue;
    }
    
    return [[NSNumber alloc ] initWithDouble:topSpeed];
    
}

- (NSNumber*)getMinSpeed{
    double minSpeed=99999.999;
    NSArray* pth=[self getOrderedPath];

    for (int x=0;x<pth.count;x++){
        TSavedPathLocation *ssl=pth[x];
        if (ssl.speed.doubleValue < minSpeed)
            minSpeed=ssl.speed.doubleValue;
    }
    
    return [[NSNumber alloc ] initWithDouble:minSpeed];
    
}




- (NSNumber*)getAverageSpeedOverDistance:(NSNumber*) distance forInterval:(NSNumber*)interval{
    double total=0;
    int numpoints=0;
    int intervalint=interval.intValue;
    double fromDistance = distance.doubleValue * (intervalint - 1);
    double toDistance = distance.doubleValue * intervalint;
    
    NSArray* pth=[self getOrderedPath];

    for (int x=0;x<pth.count;x++){
        TSavedPathLocation *ssl= pth[x];
        if (ssl.totDistance.doubleValue >= fromDistance && ssl.totDistance.doubleValue < toDistance) {
            numpoints++;
            total=total + ssl.speed.doubleValue;
        }
    }
    if(numpoints>0){
        double retVal=total/numpoints;
        return [[NSNumber alloc ] initWithDouble:retVal];
    }else{
        return [[NSNumber alloc ] initWithDouble:0.0];
    }
}




- (NSString *)getDurationFormatted{
    NSString *aReturnValue = nil;
    unsigned int theUnits = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitNanosecond;
    NSCalendar *aCalender = [NSCalendar currentCalendar];

    if (self.date != nil && self.endDate != nil){
        NSDateComponents *aDateComponents = [aCalender components:theUnits fromDate:self.date toDate:self.endDate options:0];
        //int nanoseconds=[aDateComponents nanosecond];
        int milisecond= (int)[aDateComponents nanosecond]/10000000;
        
        aReturnValue = [NSString stringWithFormat:@"%02d:%02d:%02d.%02d", [aDateComponents hour], [aDateComponents minute], [aDateComponents second],milisecond];
    
        return aReturnValue;
    }else
        return @"-";
}

- (NSString *)getDurationToNowFormatted{
    NSString *aReturnValue = nil;
    unsigned int theUnits = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitNanosecond;
    NSCalendar *aCalender = [NSCalendar currentCalendar];
    NSDate *d1 = [NSDate date];

    NSDateComponents *aDateComponents = [aCalender components:theUnits fromDate:self.date toDate:d1 options:0];
    int milisecond= (int)[aDateComponents nanosecond]/10000000;
    
    aReturnValue = [NSString stringWithFormat:@"%02d:%02d:%02d.%02d", [aDateComponents hour], [aDateComponents minute], [aDateComponents second],milisecond];
    return aReturnValue;
}


- (int)getDuration{
    NSCalendar *c = [NSCalendar currentCalendar];
    if(self.date!=nil && self.endDate!=nil){
        NSDate *d1 = self.date;
        NSDate *d2 = self.endDate;
        NSDateComponents *components = [c components:NSCalendarUnitSecond fromDate:d2 toDate:d1 options:0];
        NSInteger diff = components.minute;
        return diff;
    }
    return 0;
    
    //NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit
}


- (NSArray*) saveToCloudKit{

    if ([self fullypostedtocloud]){
        return nil; // get out quick
    }
    
    NSMutableArray * records=[[NSMutableArray alloc ]init];
   // CKRecord * pathRec= nil;

    if ([[self cloudKitId] length]==0) {
        CKRecord * pathRec= [[CKRecord alloc ] initWithRecordType:@"SavedSUPPath"];
        [pathRec setObject:self.averageSpeed forKey:@"averageSpeed"];
        [pathRec setObject:self.date forKey:@"date"];
        [pathRec setObject:self.endDate forKey:@"endDate"];
        [pathRec setObject:self.distance forKey:@"distance"];
        
        CLLocation *end = [[CLLocation alloc] initWithLatitude:self.endLat.doubleValue longitude:self.endLon.doubleValue];
        [pathRec setObject:end forKey:@"endloc"];

        CLLocation *start = [[CLLocation alloc] initWithLatitude:self.startLat.doubleValue longitude:self.startLon.doubleValue];
        [pathRec setObject:start forKey:@"startloc"];
        [pathRec setObject:self.rate forKey:@"rate"];
        [pathRec setObject:self.name forKey:@"name"];
        [pathRec setObject:self.desc forKey:@"desc"];
        [pathRec setObject:self.topAltitude forKey:@"topAltitude"];
        [pathRec setObject:self.topSpeed forKey:@"topSpeed"];
        [pathRec setObject:self.user forKey:@"user"];
        [pathRec setObject:self.waveHeight forKey:@"waveHeight"];
        [pathRec setObject:self.weather forKey:@"weather"];
        [pathRec setObject:self.windSpeed forKey:@"windSpeed"];
/*
        // get and save the path elements
        NSArray* pth=[self getOrderedPath];
        NSMutableArray* pathData = [[NSMutableArray alloc] init];
        for (int x=0;x<pth.count;x++){
            SavedPathLocations *ssl= pth[x];
            TSavedPathLocation* tloc=[[TSavedPathLocation alloc] initWithLocation:ssl];
            NSData* data = [NSKeyedArchiver archivedDataWithRootObject:tloc];
            [pathData addObject:data];
        }
        
        if(pathData.count>0){
            NSData *dataarray = [NSKeyedArchiver archivedDataWithRootObject:pathData];
        
            // need to create an asset as this can be big, also needto compress the asset to improve network throughput
            CKAsset* ass=[CompressionUtils  compress:dataarray];
            
            [pathRec setObject:ass forKey:@"pathElementsCompressed"];
            NSNumber *size=[[NSNumber alloc] initWithUnsignedLong:[dataarray length]];
            [pathRec setObject:size forKey:@"pathElementsCompressedLength"];
        }
        */
        
        if([[self uncompressedPath] count] > 0){
            if([self compressedPath]==nil){
                [self updateCompressedData];
            }
            CKAsset* ass=[CompressionUtils convertNSdataDataToCKAsset:[self compressedPath]];
            [pathRec setObject:ass forKey:@"pathElementsCompressed"];
            [pathRec setObject:[self uncompressedLength] forKey:@"pathElementsCompressedLength"];
        }
        
        // create the elements to return
        CKToCDMap * ret= [[CKToCDMap alloc] init];
        [ret setCdRef:self];
        [ret setCkRef:pathRec];
        
        [records addObject:ret];
        
   }
    return records;
}

-(void)saveAllRecordsToCloud:(NSArray*) array{
  /*  CKModifyRecordsOperation * op=[[CKModifyRecordsOperation alloc] initWithRecordsToSave:records recordIDsToDelete:nil];
    [op setSavePolicy:CKRecordSaveIfServerRecordUnchanged];
    [op setModifyRecordsCompletionBlock:^(NSArray *savedRecords, NSArray *deletedRecords, NSError *error) {
        if(error!=nil)
            NSLog(@"%@",error.description);
        else
            NSLog(@"Save to cloud completed %d",savedRecords.count );
    }];
    [op setPerRecordCompletionBlock:^(CKRecord *recod, NSError *err) {
        if(err!=nil)
            NSLog(@"%@",err.description);
        else
            NSLog(@"Save to cloud completed %@",recod.creatorUserRecordID.description);
    }];
    
    [publicDatabase addOperation:op];*/
}

- (void) didSave{
    NSLog(@"%@",@"THIS OBJECT DID SAVE");
}

-(NSArray*)generateScaleDetails{
    // this method saves the information to the scale maps
    // the scale maps are approximate grids over the world map that count the number of routes in a specifc area.
    // the scales are 1lat long unit, .5lat long unit, .25 lat long unit, etc devided by 2 each time until you hit 6 itterations
    // and are there just to give an very approximate number of routes in a specific area
    
    // each resolution scale_(1, 2, 3, 4, 5, 6 and 7) table contains points which has a root location (the base of the rectangle that contains the points) a count - the number of points in that location - and a CCLocation which is the last point that was created in that 'box' - this is the one that will be displayed.
    
    NSMutableArray* retVals=[[NSMutableArray alloc] init];
    // loop over the scales storing a value at each one
    for (int i=0;i<sizeOfScaleArray;i++){
        ScaleSaver* toAdd = nil;
        double val=scaleArray[i];
        toAdd=[self saveCLLocationAtScale:val];
        [retVals addObject:toAdd];
    }
    
    return retVals;
    
}

-(ScaleSaver*)saveCLLocationAtScale:(double)scale{

    ScaleSaver * ss=[[ScaleSaver alloc] init];
    ss.location = [[CLLocation alloc] initWithLatitude:[self startLat].doubleValue longitude:[self startLon].doubleValue];

    
    // very approximate but hey
    ss.gridX=floor(([self startLat].doubleValue*111.1)/scale);
    ss.gridY=floor(([self startLon].doubleValue*111.1)/scale);

    ss.scale=scale;
    return ss;
}

-(float) round:(float)num toSignificantFigures:(int)n {
    if(num == 0) {
        return 0;
    }
    
    double d = ceil(log10(num < 0 ? -num: num));
    int power = n - (int) d;
    
    double magnitude = pow(10, power);
    long shifted = round(num*magnitude);
    return shifted/magnitude;
}

@end
