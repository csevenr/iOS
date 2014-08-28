//
//  XMLParser.h
//  InstaSave
//
//  Created by Oliver Rodden on 02/02/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FirstViewController;

@interface XMLParser : NSObject <NSXMLParserDelegate> {
    BOOL itemNode;
    NSInteger articleCount;
    NSString *currentElement;
    NSString *currentString;
    NSMutableArray *pictureBlocks;
    
    FirstViewController *viewController;
}

@property(nonatomic)NSMutableArray *pictureBlocks;

-(id)initWithViewController:(UIViewController*)vc;
- (void) parseXML:(NSURL*) xmlUrl;

@end
