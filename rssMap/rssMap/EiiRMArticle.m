//
//  EiiRMArticle.m
//  rssMap
//
//  Created by Oliver Rodden on 19/10/2013.
//  Copyright (c) 2013 Oliver Rodden. All rights reserved.
//

#import "EiiRMArticle.h"

@implementation EiiRMArticle
@synthesize title,link,pubDate,geolat,geolong,mediacredit;

-(id)init{
    self=[super init];
    if (self) {
    }
    return self;
}

@end
