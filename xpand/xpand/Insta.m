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
    
    UserProfile *userProfile;
}

@end

@implementation Insta

-(id)init{
    if (self==[super init]) {
        userProfile = [UserProfile getActiveUserProfile];
    }
    return self;
}

-(void)getJsonForHashtag:(NSString*)hashtag{
    if ([self checkForConnection]) {
        NSString *urlForPostData;
        if (paginationURL!=nil&&currentHashtag!=nil&&[currentHashtag isEqualToString:hashtag]){
            urlForPostData = paginationURL;
        }else{
            urlForPostData = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=%@&access_token=%@",hashtag, [[ClientController sharedInstance] getCurrentClientId], [[ClientController sharedInstance] getCurrentTokenForLike:NO]];
            currentHashtag=hashtag;
        }
        
        [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlForPostData]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (error) {
                NSLog(@"Error 1 %@", error);
            } else {
                NSDictionary *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

//                NSLog(@"# %@", jsonDictionary);
                
                paginationURL = [[jsonDictionary objectForKey:@"pagination"]objectForKey:@"next_url"];

                if ([[[jsonDictionary objectForKey:@"meta"]objectForKey:@"code"] intValue]==200) {
                    [self.delegate JSONReceived:jsonDictionary];
                }else if([[[jsonDictionary objectForKey:@"meta"]objectForKey:@"code"] intValue]==400) {//chances are media is private
                    [self.delegate instaError:@"Couldnt like that post"];//+++ Add one back to likes allowed
                    NSLog(@"%d %@", [[[jsonDictionary objectForKey:@"meta"]objectForKey:@"code"] intValue] , [[jsonDictionary objectForKey:@"meta"]objectForKey:@"error_message"]);
                }else if ([[[jsonDictionary objectForKey:@"meta"]objectForKey:@"code"] intValue]==429) {
                    [self performSelectorOnMainThread:@selector(non200ReceivedWithString:) withObject:@"0" waitUntilDone:NO];
                }
            }
        }];
    }
}

- (void)likePost:(Post*)post {
    if ([self checkForConnection]) {
        NSString *urlForLike = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/likes?access_token=%@", post.postId, [[ClientController sharedInstance] getCurrentTokenForLike:YES]];
        NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlForLike]];
        [req setHTTPMethod:@"POST"];
        [NSURLConnection sendAsynchronousRequest:req queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (error) {
                NSLog(@"Error 2");
            } else {
                NSDictionary *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                NSLog(@"## %@", jsonDictionary);
                
                if ([[[jsonDictionary objectForKey:@"meta"]objectForKey:@"code"] intValue] == 200) {
                    NSLog(@"200 successful like");
                    [self.delegate likedPost];
                    [self performSelectorOnMainThread:@selector(savePostInCoreData:) withObject:post waitUntilDone:NO];
                }else if ([[[jsonDictionary objectForKey:@"meta"]objectForKey:@"code"] intValue] == 400) {
                    NSLog(@"%d %@",[[[jsonDictionary objectForKey:@"meta"]objectForKey:@"code"] intValue] , [[jsonDictionary objectForKey:@"meta"]objectForKey:@"error_message"]);
                }else if ([[[jsonDictionary objectForKey:@"meta"]objectForKey:@"code"] intValue] == 429) {
                    NSLog(@"%d %@",[[[jsonDictionary objectForKey:@"meta"]objectForKey:@"code"] intValue] , [[jsonDictionary objectForKey:@"meta"]objectForKey:@"error_message"]);
                    [self performSelectorOnMainThread:@selector(non200ReceivedWithString:) withObject:@"1" waitUntilDone:NO];
                }
            }
        }];
    }
}

-(void)savePostInCoreData:(Post*)post{
    LikedPost *likedPost = [LikedPost createWithPost:post];
    [[UserProfile getActiveUserProfile] addLikedPostsObject:likedPost];
    [ModelHelper saveManagedObjectContext];
}

-(void)getUserInfoWithToken:(NSString*)tok{
    if (tok==nil) {
        tok=[[ClientController sharedInstance] getCurrentTokenForLike:NO];
    }
    
    NSString *urlForTag = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/self?access_token=%@", tok];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlForTag]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error 3");
        } else {
            NSDictionary *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
//            NSLog(@"### %@", jsonDictionary);
            
            if ([[[jsonDictionary objectForKey:@"meta"]objectForKey:@"code"] intValue]==200) {
                userProfile = [UserProfile getUserProfileWithUserName:[[jsonDictionary objectForKey:@"data"]objectForKey:@"username"]];
                if (userProfile==nil){
                    userProfile = [UserProfile create];
                    
                    userProfile.userName = [[jsonDictionary objectForKey:@"data"]objectForKey:@"username"];
                    userProfile.userId = [[jsonDictionary objectForKey:@"data"]objectForKey:@"id"];
                }
                userProfile.bio = [[jsonDictionary objectForKey:@"data"] objectForKey:@"bio"];
                userProfile.followers = [NSNumber numberWithInt:[[[[jsonDictionary objectForKey:@"data"]objectForKey:@"counts"] objectForKey:@"followed_by"] intValue]];
                userProfile.follows = [NSNumber numberWithInt:[[[[jsonDictionary objectForKey:@"data"]objectForKey:@"counts"] objectForKey:@"follows"] intValue]];
                userProfile.mediaCount = [NSNumber numberWithInt:[[[[jsonDictionary objectForKey:@"data"]objectForKey:@"counts"] objectForKey:@"media"] intValue]];
                userProfile.fullName = [[jsonDictionary objectForKey:@"data"] objectForKey:@"full_name"];
                userProfile.profilePictureURL = [[jsonDictionary objectForKey:@"data"] objectForKey:@"profile_picture"];
                userProfile.website = [[jsonDictionary objectForKey:@"data"] objectForKey:@"website"];
                
                userProfile.isActive=[NSNumber numberWithBool:YES];

                dispatch_async(dispatch_get_main_queue(), ^{
                    [ModelHelper saveManagedObjectContext];
                });
                [self performSelectorOnMainThread:@selector(getUserMediaWithToken:) withObject:tok waitUntilDone:NO];
            }else{
                [self performSelectorOnMainThread:@selector(non200ReceivedWithString:) withObject:@"2" waitUntilDone:NO];
            }
        }
    }];
}

-(void)getUserMediaWithToken:(NSString*)tok{
    if (tok==nil) {
        tok=[[ClientController sharedInstance] getCurrentTokenForLike:NO];
    }
    NSString *urlForTag = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/media/recent/?access_token=%@",userProfile.userId , tok];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlForTag]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error 4");
        } else {
            NSDictionary *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
//           NSLog(@"#### %@", jsonDictionary);
            
            //check for at least 10 posts if not alter count
            int countToUse=10;
            if ([[jsonDictionary objectForKey:@"data"] count]<10) {
                countToUse=[[jsonDictionary objectForKey:@"data"] count];
            }

            int totalLikes=0;
            for (int i=0; i<countToUse; i++) {
                int likes = [[[[[jsonDictionary objectForKey:@"data"] objectAtIndex:i]objectForKey:@"likes"]objectForKey:@"count" ] intValue];
                totalLikes+=likes;
                if (likes>[userProfile.recentMostLikes intValue]||[userProfile.recentMostLikes intValue]==-1){
                    userProfile.recentMostLikes=[NSNumber numberWithInt:likes];
                }
                if (likes<[userProfile.recentLeastLikes intValue]||[userProfile.recentLeastLikes intValue]==-1) {
                    userProfile.recentLeastLikes=[NSNumber numberWithInt:likes];
                }
            }
            userProfile.recentCount=[NSNumber numberWithInt:countToUse];
            userProfile.recentLikes=[NSNumber numberWithInt:totalLikes];
            dispatch_async(dispatch_get_main_queue(), ^{
                [ModelHelper saveManagedObjectContext];
            });
            [self.delegate userInfoFinished];
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

-(BOOL)checkForConnection{
    NSURL *scriptUrl = [NSURL URLWithString:@"http://www.google.com"];
    NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
    if (data)
        return YES;
    else
        [self.delegate instaError:@"No internet connection"];
        return NO;
}

@end