//
//  CoreDataManager.m
//  InstaSave
//
//  Created by Oliver Rodden on 04/02/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "CoreDataManager.h"
#import "AppDelegate.h"
#import "Picture.h"
#import "PictureInfo.h"
#import "PictureBlockViewController.h"

@implementation CoreDataManager

+(void)addNewData:(NSData*)picData withMediaCredit:(NSString*)mediaCred title:(NSString*)titl andPubDate:(NSString*)pDate{
    AppDelegate *appDel = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDel managedObjectContext];
    Picture *picture = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"Picture"
                                      inManagedObjectContext:context];
    picture.pictureData = picData;

    PictureInfo *pictureInfo = [NSEntityDescription
                                            insertNewObjectForEntityForName:@"PictureInfo"
                                            inManagedObjectContext:context];
    pictureInfo.mediaCredit = mediaCred;
    pictureInfo.title = titl;
    pictureInfo.pubDate= pDate;
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

+(NSMutableArray*)getArrayOfPicBlocks{
    AppDelegate *appDel = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDel managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Picture"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    NSMutableArray *retVal = [NSMutableArray new];
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (Picture *pic in fetchedObjects) {
        PictureBlockViewController *picBlock = [[PictureBlockViewController alloc]initWithNibName:nil bundle:nil andParentViewController:nil];
        [picBlock setPicData:pic.pictureData];
        
        PictureInfo *infoa = pic.info;
        [picBlock setPicMediaCredit:infoa.mediaCredit];
        [picBlock setPicTitle:infoa.title];
        [retVal addObject:picBlock];
    }
    return retVal;
}
@end
