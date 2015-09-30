//
//  CardSet+Helper.h
//  flashcards
//
//  Created by Oliver Rodden on 13/05/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "CardSet.h"

@interface CardSet (Helper)

+ (CardSet *)create;
+ (NSArray *)getCardSets;
+ (NSArray *)getCardSetTitles;
+ (CardSet *)getCardSetWithName:(NSString *)name;
+ (NSArray *)getCardsFromSetWithName:(NSString *)name;

@end
