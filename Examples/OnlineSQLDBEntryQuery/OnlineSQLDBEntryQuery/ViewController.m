//
//  ViewController.m
//  OnlineSQLDBEntryQuery
//
//  Created by Oliver Rodden on 15/01/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.21.210/github/web/grammanager/select2.php"]];

//    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://xpand.editionthree.com"]];
//    [self.webView loadRequest:requestObj];
    
    
    
    NSString *urlForPostData = [NSString stringWithFormat:@"http://192.168.21.210/github/web/grammanager/select2.php"];

//    NSString *urlForPostData = [NSString stringWithFormat:@"http://xpand.editionthree.com"];
//    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlForPostData]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error 1 %@", error);
        } else {
            NSLog(@"%@", data);
            
            NSDictionary *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
           NSLog(@"#### %@", jsonDictionary);
        }
    }];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString* urlString = [[request URL] absoluteString];
    
    NSLog(@"%@", urlString);
    
//    NSRange equalRange = [urlString rangeOfString:@"/" options:NSBackwardsSearch];
//    NSString* stringToCheck = [urlString substringFromIndex:equalRange.location + equalRange.length];
//    NSLog(@"%@", stringToCheck);
//
////    equalRange = [stringToCheck rangeOfString:@"." options:NSBackwardsSearch];
////    stringToCheck = [stringToCheck substringToIndex:equalRange.location + equalRange.length - 1];
////    NSLog(@"%@", stringToCheck);
    
//    if ([urlString isEqualToString:@"http://xpand.editionthree.com/json.php"]) {
    
        NSString *str = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"];
        NSLog(@"_%@",str);
        

//        NSLog(@"%@", requesmamt.);
        
//        NSLog(@"%@",[(NSHTTPURLResponse*)resp.response allHeaderFields]);
        //        NSError *jsonError;
        //        NSData *objectData = [@"{\"2\":\"3\"}" dataUsingEncoding:NSUTF8StringEncoding];
        //        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
        //                                                             options:NSJSONReadingMutableContainers
        //                                                               error:&jsonError];
//    }
    
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *str = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"];
    NSLog(@"%@",str);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
