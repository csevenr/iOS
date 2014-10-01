//
//  TokenController.m
//  GramManager
//
//  Created by Oliver Rodden on 30/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "ClientController.h"

#define REDIRECTURI @"gManager://"

#define CLIENTID1 @"c4b88ed082c246b0bb4d12a0c1b8d59d"
#define CLIENTSECRET1 @"6710fd780b504f9eb627eaf337d39759"

#define CLIENTID2 @"8888ac39268049d5947fd0440f23ebbd"
#define CLIENTSECRET2 @"61ee59e4e92e48b3898263c2933b6d66"

#define CLIENTID3 @"85334a705483466aa8a02bf911129bb1"
#define CLIENTSECRET3 @"813ae28ecdf94a7e9398ea5434284c03"

#define CLIENTID4 @"a669ac6881a54fbeacb6f964926aa2db"
#define CLIENTSECRET4 @"7afafb4790d14cfaa7e1ed1bd1cf8ec4"

@interface ClientController (){
    NSInteger count;
}

@end

@implementation ClientController

static ClientController *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (ClientController *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        sharedInstance = [[ClientController alloc] init];
    });
    return sharedInstance;
}

-(id)init{
    if (self==[super init]) {
        self.tokens = [NSMutableArray new];
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"tokens"]!=nil) {
            self.tokens = [[NSUserDefaults standardUserDefaults]objectForKey:@"tokens"];
        }
    }
    return self;
}

-(void)setupTokensInWebView:(UIWebView*)webview{
    NSURLRequest *requestObj;
    if ([self.tokens count] == 0) {
        requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token&display=touch&scope=likes+relationships",CLIENTID1, REDIRECTURI]]];
        [webview loadRequest:requestObj];
    }else if ([self.tokens count] == 1){
        requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token&display=touch&scope=likes+relationships",CLIENTID2, REDIRECTURI]]];
        [webview loadRequest:requestObj];
    }else if ([self.tokens count] == 2){
        requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token&display=touch&scope=likes+relationships",CLIENTID3, REDIRECTURI]]];
        [webview loadRequest:requestObj];
    }else if ([self.tokens count] == 3){
        requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token&display=touch&scope=likes+relationships",CLIENTID4, REDIRECTURI]]];
        [webview loadRequest:requestObj];
    }
}

-(NSString*)getCurrentToken{
    count++;
    if (count==100) count=0;
    
    if (count>=0&&count<25) return [self.tokens objectAtIndex:0];
    else if (count>=25&&count<50) return [self.tokens objectAtIndex:1];
    else if (count>=50&&count<75) return [self.tokens objectAtIndex:2];
    else if (count>=75&&count<100) return [self.tokens objectAtIndex:3];
    else return [self.tokens objectAtIndex:0];
}

-(NSString*)getCurrentClientId{
    if (count==100) count=0;
    
    if (count>=0&&count<25) return CLIENTID1;
    else if (count>=25&&count<50) return CLIENTID2;
    else if (count>=50&&count<75) return CLIENTID3;
    else if (count>=75&&count<100) return CLIENTID4;
    else return CLIENTID1;
}

@end
