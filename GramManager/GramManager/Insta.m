//
//  Insta.m
//  GramManager
//
//  Created by Oliver Rodden on 26/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "Insta.h"

#define CLIENTID1 @"c4b88ed082c246b0bb4d12a0c1b8d59d"
#define CLIENTSECRET1 @"6710fd780b504f9eb627eaf337d39759"
#define REDIRECTURI @"gManager://"

#define CLIENTID2 @"8888ac39268049d5947fd0440f23ebbd"
#define CLIENTSECRET2 @"61ee59e4e92e48b3898263c2933b6d66"

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

+(void)requestTokenIn:(UIWebView*)webview{
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token&display=touch&scope=likes+relationships",CLIENTID1, REDIRECTURI]]];
    [webview loadRequest:requestObj];
}

-(void)getJsonForHashtag:(NSString*)hashtag{
    NSString *tokenString = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    
    NSString *urlForTag = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=%@&access_token=%@",hashtag, CLIENTID1, tokenString];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlForTag]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error");
        } else { 
            NSDictionary *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
//            NSLog(@"# %@", [[jsonDictionary objectForKey:@"data"]objectAtIndex:0]);
//            NSLog(@"## %@", [[[[[jsonDictionary objectForKey:@"data"]objectAtIndex:0] objectForKey:@"images"] objectForKey:@"thumbnail"] objectForKey:@"url"]);

            [self.delegate JSONReceived:jsonDictionary];
        }
    }];
}

+ (void)likePost:(NSString*)postId withToken:(NSString*)token {
    NSString *urlForLike = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/likes?access_token=%@", postId, token];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlForLike]];
    [req setHTTPMethod:@"POST"];
    [req addValue:@"" forHTTPHeaderField:@"X-Insta-Forwarded-For"];
    [NSURLConnection sendAsynchronousRequest:req queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error");
        } else {
            NSDictionary *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"## %@", jsonDictionary);
            
//            NSLog(@"post with id: %@ liked",postId);
        }
    }]; 
}

-(void)getFollowersOfUser:(NSString*)userId{
    NSLog(@"attempting follower get");
    NSString *tokenString = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *urlForFollowers = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/followed-by?access_token=%@", userId, tokenString];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlForFollowers]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error");
        } else {
            NSDictionary *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"!!! %d", [[jsonDictionary objectForKey:@"data" ] count]);
            NSLog(@"!!! %@", jsonDictionary);
            [self.delegate userJSON:jsonDictionary];
        }
    }];
}

@end