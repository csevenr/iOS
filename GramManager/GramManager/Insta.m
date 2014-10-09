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
#import "UserProfile+Helper.h"
#import "LikedPost+Helper.h"
#import "ModelHelper.h"

@implementation Insta

-(void)getJsonForHashtag:(NSString*)hashtag{
    NSString *urlForTag = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=%@&access_token=%@",hashtag, [[ClientController sharedInstance] getCurrentClientId], [[ClientController sharedInstance] getCurrentToken]];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlForTag]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error");
        } else {
            NSDictionary *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

//            NSLog(@"%@", jsonDictionary);

            if ([[[jsonDictionary objectForKey:@"meta"]objectForKey:@"code"] intValue]==200) {
                [self.delegate JSONReceived:jsonDictionary];
            }else{
                [self non200Received];
            }
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
            
//            NSLog(@"%@", jsonDictionary);
            
            if ([[[jsonDictionary objectForKey:@"meta"]objectForKey:@"code"] intValue] == 200) {
                NSLog(@"200 successful like");
                [self performSelectorOnMainThread:@selector(savePostInCoreData:) withObject:post waitUntilDone:NO];
            }else{
                NSLog(@"%d %@",[[[jsonDictionary objectForKey:@"meta"]objectForKey:@"code"] intValue] , [[jsonDictionary objectForKey:@"meta"]objectForKey:@"error_message"]);
                [self non200Received];
            }
        }
    }];
}

-(void)savePostInCoreData:(Post*)post{
    LikedPost *likedPost = [LikedPost createWithPost:post];
    [[UserProfile getActiveUserProfile] addLikedPostsObject:likedPost];
    [ModelHelper saveManagedObjectContext];
}

-(void)getUserInfo{
    NSString *urlForTag = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/self?access_token=%@", [[ClientController sharedInstance] getCurrentToken]];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlForTag]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error");
        } else {
            NSDictionary *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
//            NSLog(@"%@", jsonDictionary);
            
            if ([[[jsonDictionary objectForKey:@"meta"]objectForKey:@"code"] intValue]==200) {
                [UserProfile getActiveUserProfile].userName = [[jsonDictionary objectForKey:@"data"]objectForKey:@"username"];
                [UserProfile getActiveUserProfile].userId = [[jsonDictionary objectForKey:@"data"]objectForKey:@"id"];
                [UserProfile getActiveUserProfile].followerCount = [NSNumber numberWithInt:[[[[jsonDictionary objectForKey:@"data"]objectForKey:@"counts"] objectForKey:@"followed_by"] intValue]];
                [self.delegate userInfoFinished];
                [self getUserMedia];
            }else{
                [self non200Received];
            }
        }
    }];
}

-(void)getUserMedia{
    NSLog(@"%@", [UserProfile getActiveUserProfile].userId);
    
    NSString *urlForTag = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/media/recent/?access_token=%@",[UserProfile getActiveUserProfile].userId , [[ClientController sharedInstance] getCurrentToken]];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlForTag]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error");
        } else {
            NSDictionary *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            //check for at least 10 posts if not alter count
            int countToUse=10;
            if ([[jsonDictionary objectForKey:@"data"] count]<10) {
                countToUse=[[jsonDictionary objectForKey:@"data"] count];
            }
            
            
            int totalLikes=0;
            for (int i=0; i<countToUse; i++) {
                totalLikes+=[[[[[jsonDictionary objectForKey:@"data"] objectAtIndex:i]objectForKey:@"likes"]objectForKey:@"count" ] intValue];
            }
        }
    }];
}

-(void)non200Received{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Something went wrong" message:@"We're not sure what, but something went wrong. Chances are if you leave it an hour itll fix itself" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end