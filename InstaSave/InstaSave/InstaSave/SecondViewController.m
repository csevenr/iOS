//
//  SecondViewController.m
//  tabbed
//
//  Created by Oliver Rodden on 02/02/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "SecondViewController.h"
#import "CoreDataManager.h"
#import "PictureBlockViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *picBlockArray = [CoreDataManager getArrayOfPicBlocks];
    
    /*UIImageView *test = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 20.0, 320.0, 320.0)];
    test.image=[UIImage imageWithData:[[picBlockArray objectAtIndex:0] picData]];
    [self.view addSubview:test];*/
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, 20.0, 320.0, 498.0)];
    [scrollView setPagingEnabled:NO];
    [scrollView setDecelerationRate:UIScrollViewDecelerationRateNormal];
    UIView *scrollSubView = [UIView new];
    
    for (int i=0; i<[picBlockArray count]; i++) {
//        NSLog(@"title: %@", [[picBlockArray objectAtIndex:i]picTitle] );
        CGRect frame;
        if ((i+4)%3==1) {//xpos 1
            frame = CGRectMake(2.0, (i/3)*106.0+2.0, 104.0, 104.0);
        }else if ((i+5)%3==1){//xpos 2
            frame = CGRectMake(108.0, (i/3)*106.0+2.0, 104.0, 104.0);
        }else if ((i+6)%3==1){//xpos 3
            frame = CGRectMake(214.0, (i/3)*106.0+2.0, 104.0, 104.0);
        }
        NSLog(@"%f, %f",frame.origin.x,frame.origin.y);
        
        NSData *picData = [[picBlockArray objectAtIndex:i]picData];
        UIImage *pic = [[UIImage alloc] initWithData:picData];
        
        UIButton *picBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        picBtn.frame=frame;
        [picBtn setBackgroundImage:pic forState:UIControlStateNormal];
        [picBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [btns addObject:picBtn];
        [scrollSubView addSubview:picBtn];
    }
    
    [scrollSubView setFrame:CGRectMake(0.0, 0.0, 320.0, (106*[picBlockArray count]/3))];
    NSLog(@"%f",scrollSubView.frame.size.height);
    [scrollView setContentSize:CGSizeMake(scrollSubView.frame.size.width, scrollSubView.frame.size.height)];
    //    scrollView.delegate = self;
    [scrollView addSubview:scrollSubView];
    [self.view addSubview:scrollView];
}

-(void)buttonPressed:(id)sender{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
