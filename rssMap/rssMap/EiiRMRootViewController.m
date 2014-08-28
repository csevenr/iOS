//
//  EiiRMRootViewController.m
//  rssMap
//
//  Created by Oliver Rodden on 18/10/2013.
//  Copyright (c) 2013 Oliver Rodden. All rights reserved.
//

#import "EiiRMRootViewController.h"
#import "EiiRMArticleViewController.h"
#import "EiiRMMapViewController.h"
#import "EiiRMCell.h"

@interface EiiRMRootViewController ()

@end

@implementation EiiRMRootViewController
@synthesize currentElement, currentString, articles, article0, article1, article2, article3, article4, article5, article6;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        itemNode=NO;
        articleCount=0;
        article0 = [[EiiRMArticle alloc]init];
        article1 = [[EiiRMArticle alloc]init];
        article2 = [[EiiRMArticle alloc]init];
        article3 = [[EiiRMArticle alloc]init];
        article4 = [[EiiRMArticle alloc]init];
        article5 = [[EiiRMArticle alloc]init];
        article6 = [[EiiRMArticle alloc]init];
        self.articles = [[NSMutableArray alloc]initWithCapacity:7];
        [self.articles addObject:article0];
        [self.articles addObject:article1];
        [self.articles addObject:article2];
        [self.articles addObject:article3];
        [self.articles addObject:article4];
        [self.articles addObject:article5];
        [self.articles addObject:article6];
        NSURL *getFeed = [NSURL URLWithString:@"http://api.flickr.com/services/feeds/geo/United+Kingdom?format=rss_200"];
        [self parseXML:getFeed];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Show" style:UIBarButtonItemStylePlain target:self action:Nil];
    self.navigationItem.rightBarButtonItem = anotherButton;
    [self.navigationController setToolbarHidden:NO];
    UIBarButtonItem *anotherButton1 = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:@selector(goToMapView)];
    anotherButton1.tag=0;
    NSArray *ar =[[NSArray alloc]initWithObjects:anotherButton1, nil];
    [self setToolbarItems:ar animated:YES];
}

#pragma mark tableView methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 2;
    }else{
        return 5;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"EiiRMCell";
    EiiRMCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
//        NSLog(@"%d",(indexPath.section)*2+indexPath.row);
        EiiRMArticle *tmp = [articles objectAtIndex:(indexPath.section)*2+indexPath.row];
//        NSLog(@"%@, %@, %@, %@, %@, %@",tmp.title,tmp.link,tmp.pubDate,tmp.geolat,tmp.geolong,tmp.mediacredit);
        cell = [[EiiRMCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withArticle:tmp];
    }

    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //push new view here
    EiiRMArticleViewController *articleController = [[EiiRMArticleViewController alloc]initWithNibName:nil bundle:nil withArticle:[articles objectAtIndex:(indexPath.section)*2+indexPath.row]];
    [self.navigationController pushViewController:articleController animated:YES];
}

#pragma mark Parsing

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
    self.currentElement = elementName;
    if ([elementName isEqualToString:@"item"]) {
        itemNode=YES;
    }
    if (itemNode) {
        if ([[articles objectAtIndex:6] mediacredit]==nil) {
            if ([self.currentElement isEqualToString:@"title"]||[self.currentElement isEqualToString:@"pubDate"]||[self.currentElement isEqualToString:@"geo:lat"]||[self.currentElement isEqualToString:@"geo:long"]||[self.currentElement isEqualToString:@"media:credit"]){
                currentString=@"";
            }else if ([self.currentElement isEqualToString:@"media:content"]){
                currentString=[attributeDict objectForKey:@"url"];
            }
        }
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if (itemNode==YES) {
        if ([[articles objectAtIndex:6] mediacredit]==nil) {
            if ([self.currentElement isEqualToString:@"title"]||[self.currentElement isEqualToString:@"pubDate"]||[self.currentElement isEqualToString:@"geo:lat"]||[self.currentElement isEqualToString:@"geo:long"]||[self.currentElement isEqualToString:@"media:credit"]){
                currentString=[currentString stringByAppendingString:string];
    //            NSLog(@"%@",currentString);
            }
        }
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([elementName isEqualToString:@"item"]) {
        itemNode=NO;
    }
    if (itemNode){
        if ([[articles objectAtIndex:6] mediacredit]==nil) {
            if ([self.currentElement isEqualToString:@"title"]){
                [[articles objectAtIndex:articleCount] setTitle:currentString];
//                NSLog(@"title %@",currentString);
            }
            else if ([self.currentElement isEqualToString:@"media:content"]){
                [[articles objectAtIndex:articleCount] setLink:currentString];
//                NSLog(@"link %@",currentString);
            }
            else if ([self.currentElement isEqualToString:@"pubDate"]){
                [[articles objectAtIndex:articleCount] setPubDate:currentString];
//                NSLog(@"pubDate %@",currentString);
            }
            else if ([self.currentElement isEqualToString:@"geo:lat"]){
                [[articles objectAtIndex:articleCount] setGeolat:currentString];
//                NSLog(@"geo:lat %@",currentString);
            }
            else if ([self.currentElement isEqualToString:@"geo:long"]){
                [[articles objectAtIndex:articleCount] setGeolong:currentString];
//                NSLog(@"geo:long %@",currentString);
            }
            else if ([self.currentElement isEqualToString:@"media:credit"]){
                [[articles objectAtIndex:articleCount] setMediacredit:currentString];
                articleCount++;
//                NSLog(@"media:credit %@",currentString);
            }
        }
    }
}

-(void)goToMapView{
        EiiRMMapViewController *mapController = [[EiiRMMapViewController alloc]initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:mapController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
