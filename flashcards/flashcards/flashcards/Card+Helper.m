//
//  Card+Helper.m
//  flashcards
//
//  Created by Oliver Rodden on 13/05/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "Card+Helper.h"
#import "ModelHelper.h"

@implementation Card (Helper)

+ (Card *)create
{
    // Create a company
    Card *newEntity = (Card *)[ModelHelper createNewObjectForEntityName:@"Card"];
    
    [ModelHelper saveManagedObjectContext];
    
    return newEntity;
}

+ (Card *)getCardSetWithCardId:(NSString *)cardId
{
    NSError *error;
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Card"];
    
    // Run the query
    NSArray *cards = [MOC executeFetchRequest: request error:&error];
    for (Card *card in cards) {
        if ([card.cardId isEqualToString:cardId]) {
            return card;
        }
    }
    
    return nil;
}

@end
