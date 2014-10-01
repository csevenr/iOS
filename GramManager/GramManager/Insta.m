//
//  Insta.m
//  GramManager
//
//  Created by Oliver Rodden on 26/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "Insta.h"
#import "ClientController.h"
#import "Post.h"

@implementation Insta

-(void)getJsonForHashtag:(NSString*)hashtag{
    NSString *urlForTag = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=%@&access_token=%@",hashtag, [[ClientController sharedInstance] getCurrentClientId], [[ClientController sharedInstance] getCurrentToken]];
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

- (void)likePost:(Post*)post {
    NSString *urlForLike = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/likes?access_token=%@", post.postId, [[ClientController sharedInstance] getCurrentToken]];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlForLike]];
    [req setHTTPMethod:@"POST"];
    [NSURLConnection sendAsynchronousRequest:req queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error");
        } else {
            NSDictionary *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if ([[[jsonDictionary objectForKey:@"meta"]objectForKey:@"code"] intValue] == 200) {
                NSLog(@"200 successful like");
            }else{
                NSLog(@"%d %@",[[[jsonDictionary objectForKey:@"meta"]objectForKey:@"code"] intValue] , [[jsonDictionary objectForKey:@"meta"]objectForKey:@"error_message"]);
            }
        }
    }]; 
}

//-(void)getFollowersOfUser:(NSString*)userId{
////    NSLog(@"attempting follower get");
//    NSString *tokenString = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
//    NSString *urlForFollowers = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/followed-by?access_token=%@", userId, tokenString];
//    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlForFollowers]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        if (error) {
//            NSLog(@"Error");
//        } else {
//            NSDictionary *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
////            NSLog(@"!!! %d", [[jsonDictionary objectForKey:@"data" ] count]);
////            NSLog(@"!!! %@", jsonDictionary);
//            [self.delegate userJSON:jsonDictionary];
//        }
//    }];
//}

@end