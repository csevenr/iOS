//
//  EiiRMArticle.h
//  rssMap
//
//  Created by Oliver Rodden on 19/10/2013.
//  Copyright (c) 2013 Oliver Rodden. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EiiRMArticle : NSObject{
    /*NSString *title;
    NSString *link;
    NSString *pubDate;
    NSString *geolat;
    NSString *geolong;
    NSString *mediacredit;*/
}

@property(nonatomic,assign)NSString *title;
@property(nonatomic,assign)NSString *link;
@property(nonatomic,assign)NSString *pubDate;
@property(nonatomic,assign)NSString *geolat;
@property(nonatomic,assign)NSString *geolong;
@property(nonatomic,assign)NSString *mediacredit;
/*
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *link;
@property(nonatomic,strong)NSString *pubDate;
@property(nonatomic,strong)NSString *geolat;
@property(nonatomic,strong)NSString *geolong;
@property(nonatomic,strong)NSString *mediacredit;
*/
@end
