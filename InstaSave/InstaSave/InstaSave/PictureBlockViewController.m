//
//  PictureBlockViewController.m
//  InstaSave
//
//  Created by Oliver Rodden on 02/02/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "PictureBlockViewController.h"
#import "FirstViewController.h"

@interface PictureBlockViewController ()

@end

@implementation PictureBlockViewController
@synthesize picTitle,picPubDate,picMediaCredit,picLink,idNo,picData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andParentViewController:(UIViewController*)viewC
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        VC=(FirstViewController*)viewC;
        
        mediaCreditLbl = [[UILabel alloc]initWithFrame:CGRectMake(2.0, 0.0, 316.0, 17.0)];
        [mediaCreditLbl setText:@"aaa"];
        [mediaCreditLbl setTextColor:[UIColor blueColor]];
        [self.view addSubview:mediaCreditLbl];
        
        img = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 17.0, 320.0, 320.0)];
        [img setBackgroundColor:[UIColor lightGrayColor]];
        [self.view addSubview:img];
        
        img2 = [UIButton buttonWithType:UIButtonTypeInfoLight];
        img2.center=CGPointMake(300.0, 0.0);
        [img2 addTarget:self action:@selector(imageTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:img2];
        
        titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(2.0, 339.0, 316.0, 17.0)];
        [titleLbl setText:@"bbb"];
        [titleLbl setTextColor:[UIColor lightGrayColor]];
        [self.view addSubview:titleLbl];
    }
    return self;
}

-(void)imageTapped{
    [VC pictureBlockTapped:self];
}

-(void)updateWithName:(NSString*)name title:(NSString*)titl andUrl:(NSString*)url{
    picMediaCredit=name;
    picTitle=titl;
    picLink=url;
    picPubDate=nil;
    
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
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
        NSLog(@"failed");
    }
    
    titleLbl.text=titl;
    mediaCreditLbl.text=name;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [receivedData appendData:(NSMutableData*)data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    picData=receivedData;
    [img setImage:[UIImage imageWithData:receivedData] /*forState:UIControlStateNormal*/];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
