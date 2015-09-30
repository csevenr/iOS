//
//  Card+Helper.h
//  flashcards
//
//  Created by Oliver Rodden on 13/05/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "Card.h"

@interface Card (Helper)

+ (Card *)create;
+ (Card *)getCardSetWithCardId:(NSString *)cardId;

@end
