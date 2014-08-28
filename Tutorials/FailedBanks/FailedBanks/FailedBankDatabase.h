//
//  FailedBankDatabase.h
//  FailedBanks
//
//  Created by Oliver Rodden on 27/01/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface FailedBankDatabase : NSObject {
    sqlite3 *_database;
}

+ (FailedBankDatabase*)database;
- (NSArray *)failedBankInfos;

@end