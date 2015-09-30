//
//  CardSet+Helper.m
//  flashcards
//
//  Created by Oliver Rodden on 13/05/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "CardSet+Helper.h"
#import "ModelHelper.h"

@implementation CardSet (Helper)

+ (CardSet *)create
{
    // Create a company
    CardSet *newEntity = (CardSet *)[ModelHelper createNewObjectForEntityName:@"CardSet"];
    
    [ModelHelper saveManagedObjectContext];
    
    return newEntity;
}

+ (NSArray *)getCardSets
{
    NSError *error;
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"CardSet"];
    
    // Run the query
    NSArray *results = [MOC executeFetchRequest: request error:&error];
    
    return results;
}

+ (CardSet *)getCardSetWithName:(NSString *)name
{
    NSError *error;
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"CardSet"];
    
    // Run the query
    NSArray *results = [MOC executeFetchRequest: request error:&error];
    for (CardSet *set in results) {
        if ([set.name isEqualToString:name]) {
            return set;
        }
    }
    return nil;
}


+ (NSArray *)getCardSetTitles
{
    NSError *error;
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"CardSet"];
    
    // Run the query
    NSArray *sets = [MOC executeFetchRequest: request error:&error];
    
    NSMutableArray *titles = [NSMutableArray new];
    for (CardSet *set in sets) {
        [titles addObject:set.name];
    }
    
    return titles;
}

+ (NSArray *)getCardsFromSetWithName:(NSString *)name
{
    CardSet *currentSet = [CardSet getCardSetWithName:name];
    
    NSArray *arrayOfCards = [NSArray arrayWithArray:[[currentSet cards] allObjects]];
    
    return arrayOfCards;
}

@end
