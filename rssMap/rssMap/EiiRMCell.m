//
//  EiiRMCell.m
//  rssMap
//
//  Created by Oliver Rodden on 18/10/2013.
//  Copyright (c) 2013 Oliver Rodden. All rights reserved.
//

#import "EiiRMCell.h"
#import "EiiRMArticle.h"

@implementation EiiRMCell
@synthesize thumbNail,titleLbl,mediaCreditLbl,pubDateLbl,receivedData;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withArticle:(EiiRMArticle*)art
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        // Create the request.
        NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:art.link]
                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval:60.0];
        // create the connection with the request
        // and start loading the data
        NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        if (theConnection) {
            // Create the NSMutableData to hold the received data.
            // receivedData is an instance variable declared elsewhere.
            receivedData = [[NSMutableData alloc]init];
        } else {
            // Inform the user that the connection failed.
        }
        
        
        NSString* tmp=art.link;
        thumbNail = [[UIImageView alloc]initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tmp]]]];
//        thumbNail = [[UIImageView alloc]initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:art.link]]]];
//        thumbNail = [[UIImageView alloc]init];
        thumbNail.frame=CGRectMake(0.0, 0.0, 50.0, 50.0);
        [self.contentView addSubview:thumbNail];
        
        titleLbl = [[UILabel alloc]init];
        titleLbl.frame=CGRectMake(50.0, 1.0, 270.0, 20.0);
        titleLbl.text=[NSString stringWithFormat:@"%@",art.title];
        [self.contentView addSubview:titleLbl];
        
        mediaCreditLbl = [[UILabel alloc]init];
        mediaCreditLbl.frame=CGRectMake(50.0, 26.0, 136.0, 20.0);
        mediaCreditLbl.text=[NSString stringWithFormat:@"%@",art.mediacredit];
        [self.contentView addSubview:mediaCreditLbl];
        
        pubDateLbl = [[UILabel alloc]init];
        pubDateLbl.frame=CGRectMake(185.0, 26.0, 280.0, 20.0);
        pubDateLbl.text=[NSString stringWithFormat:@"%@",art.pubDate];
        [self.contentView addSubview:pubDateLbl];
    }
    return self;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    receivedData = [receivedData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [thumbNail setImage:[UIImage imageWithData:receivedData]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
