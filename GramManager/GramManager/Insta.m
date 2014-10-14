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

@interface Insta (){
    NSString *currentHashtag;
    NSString *paginationURL;
    
    UIAlertView *non200Alert;
}

@end

@implementation Insta

-(void)getJsonForHashtag:(NSString*)hashtag{
    NSString *urlForPostData;
    if (paginationURL!=nil&&currentHashtag!=nil&&[currentHashtag isEqualToString:hashtag]){
        urlForPostData = paginationURL;
    }else{
        urlForPostData = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=%@&access_token=%@",hashtag, [[ClientController sharedInstance] getCurrentClientId], [[ClientController sharedInstance] getCurrentTokenForLike:NO]];
        currentHashtag=hashtag;
    }
    NSLog(@"#### %@",[[ClientController sharedInstance] getCurrentTokenForLike:NO]);
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlForPostData]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error 1 %@", error);
        } else {
            NSDictionary *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

            NSLog(@"# %@", jsonDictionary);
            
            paginationURL = [[jsonDictionary objectForKey:@"pagination"]objectForKey:@"next_url"];
            NSLog(@"## %@", paginationURL);

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
            
            NSLog(@"#¡#¡ %@", jsonDictionary);
            
            if ([[[jsonDictionary objectForKey:@"meta"]objectForKey:@"code"] intValue]==200) {
                UserProfile *userProfile = [UserProfile getUserProfileWithUserName:[[jsonDictionary objectForKey:@"data"]objectForKey:@"username"]];
                if (userProfile==nil){
                    userProfile = [UserProfile create];
                    [ModelHelper saveManagedObjectContext];
                    
                    userProfile.userName = [[jsonDictionary objectForKey:@"data"]objectForKey:@"username"];
                    userProfile.userId = [[jsonDictionary objectForKey:@"data"]objectForKey:@"id"];
                }
                userProfile.followerCount = [NSNumber numberWithInt:[[[[jsonDictionary objectForKey:@"data"]objectForKey:@"counts"] objectForKey:@"followed_by"] intValue]];
                userProfile.profilePictureURL = [[jsonDictionary objectForKey:@"data"] objectForKey:@"profile_picture"];
                userProfile.isActive=[NSNumber numberWithBool:YES];
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
    if (!non200Alert.visible){
        non200Alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@ %@",@"Something went wrong", str] message:@"We're not sure what, but something went wrong. Chances are if you leave it an hour itll fix itself" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [non200Alert show];
    }
    [self.delegate JSONReceived:nil];
}

@end