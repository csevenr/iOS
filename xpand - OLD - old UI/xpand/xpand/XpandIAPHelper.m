//
//  XpandIAPHelper.m
//  xpand
//
//  Created by Oli Rodden on 10/03/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "XpandIAPHelper.h"

@implementation XpandIAPHelper

+ (XpandIAPHelper*)sharedInstance {
    static dispatch_once_t once;
    static XpandIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      //Subscription Identifiers
                                      @"com.oliverrodden.xpand.xpandplus1month",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
