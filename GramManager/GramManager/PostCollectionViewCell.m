//
//  PostCollectionViewCell.m
//  GramManager
//
//  Created by Oliver Rodden on 29/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "PostCollectionViewCell.h"

@implementation PostCollectionViewCell

-(void)setPost:(Post *)post{
    self->_post = post;
    [self setUpCell];
}

-(void)setUpCell{
//    self.textLabel.text = [self.post userName];
    self.mainImg.backgroundColor=[UIColor lightGrayColor];
    
    [self downloadImage];
}

-(void)downloadImage{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.post.thumbnailURL]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (error){
                                   NSLog(@"error");
                               }else{
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   self.mainImg.image = image;
                                   [self bringSubviewToFront:self.mainImg];
                               }
                           }];
}

- (void)awakeFromNib {
    // Initialization code
}

@end
