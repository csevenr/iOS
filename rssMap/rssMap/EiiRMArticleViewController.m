//
//  EiiRMArticleViewController.m
//  rssMap
//
//  Created by Oliver Rodden on 18/10/2013.
//  Copyright (c) 2013 Oliver Rodden. All rights reserved.
//

#import "EiiRMArticleViewController.h"
#import "EiiRMArticle.h"

@class EiiRMArticle;

@interface EiiRMArticleViewController ()

@end

@implementation EiiRMArticleViewController
@synthesize titleLbl,mediaCreditLbl,pubDateLbl,article;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withArticle:(EiiRMArticle*)art
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        article=art;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImageView *mainImgFrame = [[UIImageView alloc]initWithFrame:CGRectMake(10.0, 70.0, 300.0, 300.0)];
    mainImgFrame.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:mainImgFrame];
    
    NSString* tmp=article.link;
    UIImageView *mainImg = [[UIImageView alloc]initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tmp]]]];
    mainImg.frame=CGRectMake(20.0, 80.0, 280.0, 280.0);
    [self.view addSubview:mainImg];
    
    titleLbl = [[UILabel alloc]init];
    titleLbl.frame=CGRectMake(10.0, 380.0, 320.0, 36.0);
    titleLbl.text=[NSString stringWithFormat:@"%@",article.title];
    titleLbl.font = [UIFont systemFontOfSize:30];
    [self.view addSubview:titleLbl];
    
    mediaCreditLbl = [[UILabel alloc]init];
    mediaCreditLbl.frame=CGRectMake(10.0, 440.0, 320.0, 20.0);
    mediaCreditLbl.text=[NSString stringWithFormat:@"%@",article.mediacredit];
    [self.view addSubview:mediaCreditLbl];
    
    pubDateLbl = [[UILabel alloc]init];
    pubDateLbl.frame=CGRectMake(10.0, 460.0, 320.0, 20.0);
    pubDateLbl.text=[NSString stringWithFormat:@"%@",article.pubDate];
    [self.view addSubview:pubDateLbl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
