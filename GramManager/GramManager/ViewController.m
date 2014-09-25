//
//  ViewController.m
//  GramManager
//
//  Created by Oliver Rodden on 25/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "ViewController.h"

#define CLIENTID @"c4b88ed082c246b0bb4d12a0c1b8d59d"
#define CLIENTSECRET @"6710fd780b504f9eb627eaf337d39759"
#define REDIRECTURI @"gManager://"

@interface ViewController (){
    NSString *token;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    //gets code, goes to safari
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=code", CLIENTID, REDIRECTURI]]];
    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token&display=touch&scope=likes+relationships",CLIENTID, REDIRECTURI]]];
    
    //gets code, in web view
//    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=code", CLIENTID, REDIRECTURI]]];
    
    //new one
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token&display=touch&scope=likes+relationships",CLIENTID, REDIRECTURI]]];
    [self.oAuthWebView loadRequest:requestObj];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString* urlString = [[request URL] absoluteString];
//    NSLog(@"!%@",urlString);
    NSRange equalRange = [urlString rangeOfString:@"=" options:NSBackwardsSearch];
    if (![[urlString substringFromIndex:equalRange.location + equalRange.length] isEqualToString:@"code"]) {
//        NSLog(@"yay %@", [urlString substringFromIndex:equalRange.location + equalRange.length]);
        [self getTokenWithCode:[urlString substringFromIndex:equalRange.location + equalRange.length]];
    }
    return YES;
}

-(void)auth{
    self.oAuthWebView.hidden=YES;
}

-(void)getTokenWithCode:(NSString *)code{
    NSString *urlForToken = [NSString stringWithFormat:@"https://api.instagram.com/oauth/access_token/?client_id=%@&client_secret=%@&code=%@&redirect_uri=%@&grant_type=authorization_code",CLIENTID, CLIENTSECRET, code, REDIRECTURI];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlForToken]];
//
//    [request setHTTPMethod:@"POST"];
//    [request setValue:CLIENTSECRET forHTTPHeaderField:@"client_secret"];
//    [request setValue:@"authorization_code" forHTTPHeaderField:@"grant_type"];
//    [request setValue:REDIRECTURI forHTTPHeaderField:@"redirect_uri"];
//    [request setValue:code forHTTPHeaderField:@"code"];
//    
//    NSString *stringData = @"{ \"Payment\": { \"TotalAmount\": 100 }, \"RedirectURL\": \"https://www.mydomain.com.au/results?order=0001\" }";
//    [request setHTTPBody:[stringData dataUsingEncoding:NSUTF8StringEncoding]];
//    
    NSURLConnection *a = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    NSLog(@"# %@",a);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (token==nil || [token isEqualToString:@"likes+relationships"]) {
        //    connection.currentRequest.HTTPBody;
        //    NSLog(@"## %@",connection.currentRequest);
        //    NSLog(@"! %@", connection.currentRequest.URL);
        //    NSLog(@"!! %@", connection.currentRequest.HTTPBody);
        
        NSString* urlString = [NSString stringWithFormat:@"%@",connection.currentRequest.URL];
        
        NSRange equalRange = [urlString rangeOfString:@"code=" options:NSBackwardsSearch];
        NSString *urlString2 =[urlString substringFromIndex:equalRange.location + equalRange.length];
        
        NSRange equalRange2 = [urlString2 rangeOfString:@"&redirect" options:NSBackwardsSearch];
        //    NSString *urlString3 =[urlString2 substringFromIndex:equalRange2.location + equalRange2.length];
        NSString *urlString3 =[urlString2 substringToIndex:equalRange2.location];
        
        NSLog(@"%@",urlString3);
        token = urlString3;
        //    if (![[urlString substringFromIndex:equalRange.location + equalRange.length] isEqualToString:@"code"]) {
        //        [self getTokenWithCode:[urlString substringFromIndex:equalRange.location + equalRange.length]];
        //    }
        
        //    NSString *urlForToken = [NSString stringWithFormat:@"https://api.instagram.com/oauth/access_token/?client_id=%@&client_secret=%@&code=%@&redirect_uri=%@&grant_type=authorization_code",CLIENTID, CLIENTSECRET, code, REDIRECTURI];
        if (![token isEqualToString:@"likes+relationships"]){
            NSString *urlForTag = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=%@&access_token=%@",@"corrado", CLIENTID, token];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlForTag]];
            NSURLConnection *a = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
    }else{
        NSLog(@"JSON %@", connection.currentRequest.HTTPBody);
        
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"data: %@",data);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
