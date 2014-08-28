//
//  XMLParser.m
//  InstaSave
//
//  Created by Oliver Rodden on 02/02/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "XMLParser.h"
#import "PictureBlockViewController.h"
#import "FirstViewController.h"

@implementation XMLParser
@synthesize pictureBlocks;

-(id)initWithViewController:(FirstViewController*)vc{
    if (self=[super init]) {
        viewController=vc;
        pictureBlocks = [NSMutableArray new];
    }
    return self;
}

- (void) parseXML:(NSURL*) xmlUrl{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:xmlUrl];
    parser.delegate = self;
    [parser parse];
    
    NSString *er = [NSString stringWithFormat:@"%@",[parser parserError]];
    if (![er isEqualToString:@"(null)"]) {
        NSLog(@"%@",er);
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    currentElement = elementName;
    if ([elementName isEqualToString:@"item"]) {
        itemNode=YES;
    }
    if (itemNode) {
        if ([pictureBlocks count]<=10) {
            if ([currentElement isEqualToString:@"title"]||[currentElement isEqualToString:@"pubDate"]||[currentElement isEqualToString:@"media:credit"]||[currentElement isEqualToString:@"link"]){
                if ([currentElement isEqualToString:@"title"]) {
                    PictureBlockViewController *block = [PictureBlockViewController new];
                    [pictureBlocks addObject:block];
                }
                currentString=@"";
            }
        }
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if (itemNode==YES) {
        if ([pictureBlocks count]<=10) {
            if ([currentElement isEqualToString:@"title"]||[currentElement isEqualToString:@"pubDate"]||[currentElement isEqualToString:@"media:credit"]||[currentElement isEqualToString:@"link"]){
                currentString=[currentString stringByAppendingString:string];
            }
        }
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([elementName isEqualToString:@"item"]) {
        itemNode=NO;
    }
    if (itemNode){
        if ([pictureBlocks count]<=10) {
            if ([currentElement isEqualToString:@"title"]){
                [[pictureBlocks objectAtIndex:articleCount] setPicTitle:currentString];
//                NSLog(@"title %@",currentString);
            }
            else if ([currentElement isEqualToString:@"pubDate"]){
                [[pictureBlocks objectAtIndex:articleCount] setPicPubDate:currentString];
//                NSLog(@"pubDate %@",currentString);
            }
            else if ([currentElement isEqualToString:@"media:credit"]){
                [[pictureBlocks objectAtIndex:articleCount] setPicMediaCredit:currentString];
//                NSLog(@"media:credit %@",currentString);
                articleCount++;
                if (articleCount==10) {
                    [viewController performSelectorOnMainThread:@selector(updateCells) withObject:nil waitUntilDone:NO];
                }
//                NSLog(@"count %d",articleCount);
            }
            else if ([currentElement isEqualToString:@"link"]){
                [[pictureBlocks objectAtIndex:articleCount] setPicLink:currentString];
//                NSLog(@"link %@",currentString);
            }
        }
    }
}

@end
