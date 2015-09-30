//
//  Card.h
//  flashcards
//
//  Created by Oliver Rodden on 13/05/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CardSet;

@interface Card : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * cardId;
@property (nonatomic, retain) CardSet *set;

@end
