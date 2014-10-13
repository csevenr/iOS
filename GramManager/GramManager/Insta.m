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
    NSString *urlForTag = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=%@&access_token=%@",hashtag, [[ClientController sharedInstance] getCurrentClientId], [[ClientController sharedInstance] getCurrentTokenForLike:NO]];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlForTag]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error 1");
        } else {
            NSDictionary *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

            NSLog(@"# %@", jsonDictionary);
            
            NSString *paginationURL = [[jsonDictionary objectForKey:@"pagination"]objectForKey:@"next_url"];
            NSLog(@"%@", paginationURL);

            if ([[[jsonDictionary objectForKey:@"meta"]objectForKey:@"code"] intValue]==200) {
                [self.delegate JSONReceived:jsonDictionary];
            }else{
                [self performSelectorOnMainThread:@selector(non200ReceivedWithString:) withObject:@"0" waitUntilDone:NO];
            }
        }
    }];
}



- (void)likePost:(Post*)post {
    NSString *urlForLike = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/likes?access_token=%@", post.postId, [[ClientController sharedInstance] getCurrentTokenForLike:YES]];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlForLike]];
    [req setHTTPMethod:@"POST"];
    [NSURLConnection sendAsynchronousRequest:req queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error 2");
        } else {
            NSDictionary *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
//            NSLog(@"## %@", jsonDictionary);
            
            if ([[[jsonDictionary objectForKey:@"meta"]objectForKey:@"code"] intValue] == 200) {
                NSLog(@"200 successful like");
                [self performSelectorOnMainThread:@selector(savePostInCoreData:) withObject:post waitUntilDone:NO];
            }else{
                NSLog(@"%d %@",[[[jsonDictionary objectForKey:@"meta"]objectForKey:@"code"] intValue] , [[jsonDictionary objectForKey:@"meta"]objectForKey:@"error_message"]);
                [self performSelectorOnMainThread:@selector(non200ReceivedWithString:) withObject:@"1" waitUntilDone:NO];
            }
        }
    }];
}

-(void)savePostInCoreData:(Post*)post{
    LikedPost *likedPost = [LikedPost createWithPost:post];
    [[UserProfile getActiveUserProfile] addLikedPostsObject:likedPost];
    [ModelHelper saveManagedObjectContext];
}

-(void)getUserInfoWithToken:(NSString*)tok{
    NSString *urlForTag = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/self?access_token=%@", tok];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlForTag]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error 3");
        } else {
            NSDictionary *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
//            NSLog(@"%@", jsonDictionary);
            
            if ([[[jsonDictionary objectForKey:@"meta"]objectForKey:@"code"] intValue]==200) {
                UserProfile *userToCheck = [UserProfile getUserProfileWithUserName:[[jsonDictionary objectForKey:@"data"]objectForKey:@"username"]];
                if (userToCheck!=nil){
                    userToCheck.isActive=[NSNumber numberWithBool:YES];
                }else{
                    UserProfile *userProfile = [UserProfile create];
                    userProfile.isActive=[NSNumber numberWithBool:YES];
                    [ModelHelper saveManagedObjectContext];
                    
                    userProfile.userName = [[jsonDictionary objectForKey:@"data"]objectForKey:@"username"];
                    userProfile.userId = [[jsonDictionary objectForKey:@"data"]objectForKey:@"id"];
                    userProfile.followerCount = [NSNumber numberWithInt:[[[[jsonDictionary objectForKey:@"data"]objectForKey:@"counts"] objectForKey:@"followed_by"] intValue]];
                    userProfile.profilePictureURL = [[jsonDictionary objectForKey:@"data"] objectForKey:@"profile_picture"];
                }
                [self.delegate userInfoFinished];
                [self getUserMedia];
            }else{
                [self performSelectorOnMainThread:@selector(non200ReceivedWithString:) withObject:@"2" waitUntilDone:NO];
            }
        }
    }];
}

-(void)getUserMedia{
    NSString *urlForTag = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/media/recent/?access_token=%@",[UserProfile getActiveUserProfile].userId , [[ClientController sharedInstance] getCurrentTokenForLike:NO]];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlForTag]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error 4");
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
            
            [UserProfile getActiveUserProfile].recentCount=[NSNumber numberWithInt:countToUse];
            [UserProfile getActiveUserProfile].recentLikes=[NSNumber numberWithInt:totalLikes];
            [ModelHelper saveManagedObjectContext];
        }
    }];
}

-(void)logout{
    NSString *urlForTag = @"https://instagram.com/accounts/logout/";
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlForTag]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error 5");
        } else {
            
        }
    }];
}

-(void)non200ReceivedWithString:(NSString*)str{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@ %@",@"Something went wrong", str] message:@"We're not sure what, but something went wrong. Chances are if you leave it an hour itll fix itself" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
}

@end