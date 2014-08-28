//
//  PictureViewController.m
//  PictureAMinute
//
//  Created by Oliver Rodden on 19/12/2013.
//  Copyright (c) 2013 Oliver Rodden. All rights reserved.
//

#import "PictureViewController.h"
#import "AppDelegate.h"
#import "Scratchpad.h"
#import "ViewController.h"

@interface PictureViewController (){
    UIViewController *VC;
    BOOL selectModeEnabled;
    BOOL bigImage;
    CGRect originalFrame;
    UIImageView *bigView;
    UIScrollView *scrollView;
}

@end

@implementation PictureViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initWithParentViewController:(UIViewController*)vc{
    VC=vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 320.0, 480.0)];
    [scrollView setPagingEnabled:NO];
    [scrollView setDecelerationRate:UIScrollViewDecelerationRateNormal];
    UIView *scrollSubView = [UIView new];
    
    AppDelegate *appDel = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSMutableArray *pictures = [[appDel scratchPad] objectForKey:PHOTOARRAY];
    NSMutableArray *btns = [NSMutableArray new];
    UIButton *picBtn;
    
    for (int i=0; i<[pictures count]; i++) {
        CGRect frame;
        if ((i+4)%3==1) {//xpos 1
            frame = CGRectMake(2.0, (i/3)*106.0+2.0, 104.0, 104.0);
        }else if ((i+5)%3==1){//xpos 2
            frame = CGRectMake(108.0, (i/3)*106.0+2.0, 104.0, 104.0);
        }else if ((i+6)%3==1){//xpos 3
            frame = CGRectMake(214.0, (i/3)*106.0+2.0, 104.0, 104.0);
        }
        NSLog(@"%f, %f",frame.origin.x,frame.origin.y);
        
        NSData *picData = [pictures objectAtIndex:i];
        UIImage *pic = [[UIImage alloc] initWithData:picData];
        
        picBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        picBtn.frame=frame;
        [picBtn setBackgroundImage:pic forState:UIControlStateNormal];
        [picBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btns addObject:picBtn];
        [scrollSubView addSubview:picBtn];
    }
    
    [scrollSubView setFrame:CGRectMake(0.0, 0.0, 320.0, (106*[pictures count]/3))];
    NSLog(@"%f",scrollSubView.frame.size.height);
    [scrollView setContentSize:CGSizeMake(scrollSubView.frame.size.width, scrollSubView.frame.size.height)];
//    scrollView.delegate = self;
    [scrollView addSubview:scrollSubView];
    [self.view addSubview:scrollView];
}

-(void)buttonPressed:(UIButton*)sender{
    if (selectModeEnabled){
        
    }else{
        if (bigImage==NO) {
            NSLog(@"content offset %f",scrollView.contentOffset.y);
            NSLog(@"         frame %f",sender.frame.origin.y);
            bigView = [[UIImageView alloc]initWithFrame:CGRectMake(sender.frame.origin.x, sender.frame.origin.y-scrollView.contentOffset.y, sender.frame.size.width, sender.frame.size.height)];
            [bigView setImage:[sender backgroundImageForState:UIControlStateNormal]];
            [self.view addSubview:bigView];
            NSLog(@"     new frame %f",bigView.frame.origin.y);
            
            originalFrame=bigView.frame;
            [UIView animateWithDuration:0.3 animations:^{
                bigView.frame=CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
            } completion:nil];
            bigImage=YES;
            scrollView.scrollEnabled=NO;
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                bigView.frame=originalFrame;
            } completion:^(BOOL finished){
                if (finished) {
                    [bigView removeFromSuperview];
                }
            }];
            bigImage=NO;
            scrollView.scrollEnabled=YES;
        }
    }
}

-(void)savePic:(id)sender{
    UIImage *tmp = [sender currentBackgroundImage];
    UIImageWriteToSavedPhotosAlbum(tmp, nil, nil, nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
