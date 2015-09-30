//
//  ViewController.m
//  StockWatch
//
//  Created by Oliver Rodden on 22/05/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    NSTimer *reqTimer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    reqTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(req) userInfo:nil repeats:YES];
}

-(void)req{
    NSString *urlString = [NSString stringWithFormat:@"https://query.yahooapis.com/v1/public/yql?q=select%%20*%%20from%%20yahoo.finance.quotes%%20where%%20symbol%%20in%%20(%%22DAX%%22,%%22YHOO%%22,%%22AAPL%%22,%%22GOOG%%22,%%22MSFT%%22)&format=json&diagnostics=true&env=store%%3A%%2F%%2Fdatatables.org%%2Falltableswithkeys&callback="];
    
    NSURL *requestUrl = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error 1: %@", error);
        } else {
            NSDictionary *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
//            NSLog(@"%@", [jsonDictionary objectForKey:@"query" objectForKey:@"results"]);
            NSLog(@"A: %@ | B: %@",
                  [[[[[jsonDictionary objectForKey:@"query"] objectForKey:@"results"] objectForKey:@"quote"] objectAtIndex:2] objectForKey:@"Ask"],
                  [[[[[jsonDictionary objectForKey:@"query"] objectForKey:@"results"] objectForKey:@"quote"] objectAtIndex:2 ] objectForKey:@"Bid"]
                  );
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
