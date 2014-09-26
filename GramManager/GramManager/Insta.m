//
//  Insta.m
//  GramManager
//
//  Created by Oliver Rodden on 26/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "Insta.h"

#define CLIENTID @"c4b88ed082c246b0bb4d12a0c1b8d59d"
#define CLIENTSECRET @"6710fd780b504f9eb627eaf337d39759"
#define REDIRECTURI @"gManager://"

@implementation Insta

static Insta *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (Insta *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        sharedInstance = [[Insta alloc] init];
    });
    return sharedInstance;
}

+(NSString*)requestTokenIn:(UIWebView*)webview{
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token&display=touch&scope=likes+relationships",CLIENTID, REDIRECTURI]]];
    [webview loadRequest:requestObj];
    
    NSString *token;
    return token;
}

-(void)getJsonForHashtag:(NSString*)hashtag{
    NSString *tokenString = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    
    NSString *urlForTag = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=%@&access_token=%@",hashtag, CLIENTID, tokenString];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlForTag]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error");
        } else {//  
            NSLog(@"got the JSON");
            NSDictionary *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            [self.delegate JSONReceived:jsonDictionary];
            //            NSLog(@"%@",[[jsonDictionary objectForKey:@"data"]objectAtIndex:0]);//first post object
            //            NSLog(@"%@",[[[jsonDictionary objectForKey:@"data"]objectAtIndex:0] objectForKey:@"id"]);//first post id
            
            //            NSLog(@"%@",[[[jsonDictionary objectForKey:@"data"]objectAtIndex:0]objectForKey:@"images"]);//all image object for first post
            //            NSLog(@"%@",[[[[jsonDictionary objectForKey:@"data"]objectAtIndex:0]objectForKey:@"images"]objectForKey:@"thumbnail"]);//thumbnail image object for first post
            //            NSLog(@"%@",[[[[[jsonDictionary objectForKey:@"data"]objectAtIndex:0]objectForKey:@"images"]objectForKey:@"thumbnail"] objectForKey:@"url"]);//thumbnail image url for first post
            //
//            postId = [[[jsonDictionary objectForKey:@"data"]objectAtIndex:0] objectForKey:@"id"];
            
//            NSURL *thumbnailURL = [NSURL URLWithString:[[[[[jsonDictionary objectForKey:@"data"]objectAtIndex:0]objectForKey:@"images"]objectForKey:@"thumbnail"] objectForKey:@"url"]];
            }
    }];
}

@end
