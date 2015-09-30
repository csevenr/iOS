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
            urlForPostData = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=%@&access_token=%@",hashtag, [[ClientController sharedInstance] getCurrentClientId], userProfile.token];
            currentHashtag=hashtag;
        }
        
        NSLog(@"_## %@", urlForPostData);
        
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
//        NSString *urlForLike = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/likes?access_token=%@", post.postId, [[ClientController sharedInstance] getCurrentTokenForLike:YES]];
//        NSString *urlForLike = [NSString stringWithFormat:@"http://xpand.editionthree.com/like.php?user_id=%@&image_id=%@", userProfile.userId, post.postId];
        NSString *urlForLike = [NSString stringWithFormat:@"https://xpand.today/api/manual-like.php?user_id=%@&image_id=%@", userProfile.userId, post.postId];
//        NSLog(@"POSTID: %@", post.postId);

        NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlForLike]];
        [NSURLConnection sendAsynchronousRequest:req queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (error) {
                NSLog(@"%@", error);
                NSLog(@"Error 2");
            } else {

                NSString* returnString= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                NSLog(@"__ %@", returnString);

                NSDictionary *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                NSArray *aJ = [NSArray arrayWithObjects:[NSJSONSerialization JSONObjectWithData:data options:0 error:nil], nil];
                
                NSLog(@"## %@", aJ);
                
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

-(void)getUserInfo{
    NSString *urlForTag = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/self?access_token=%@", userProfile.token];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlForTag]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error 3");
        } else {
            NSDictionary *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"### %@", jsonDictionary);
            
            if ([[[jsonDictionary objectForKey:@"meta"]objectForKey:@"code"] intValue]==200) {
               if (userProfile.userName == nil){
                    userProfile.userName = [[jsonDictionary objectForKey:@"data"]objectForKey:@"username"];
                    userProfile.instaUserId = [[jsonDictionary objectForKey:@"data"]objectForKey:@"id"];
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
                [self performSelectorOnMainThread:@selector(getUserMedia) withObject:nil waitUntilDone:NO];
            }else{
                [self performSelectorOnMainThread:@selector(non200ReceivedWithString:) withObject:@"2" waitUntilDone:NO];//+++ crashes becuase of this
            }
        }
    }];
}

-(void)getUserMedia{
    NSString *urlForTag = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/media/recent/?access_token=%@",userProfile.userId , userProfile.token];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlForTag]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error 4");
        } else {
            NSDictionary *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
//           NSLog(@"#### %@", jsonDictionary);
            
            //check for at least 10 posts if not alter count
            int countToUse = 10;
            if ([[jsonDictionary objectForKey:@"data"] count]<10) {
                countToUse = [[jsonDictionary objectForKey:@"data"] count];
            }
            
            int totalLikes=0;
            userProfile.recentMostLikes = [NSNumber numberWithInt:-1];
            userProfile.recentLeastLikes = [NSNumber numberWithInt:-1];
            
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
                [self.delegate userInfoFinished];
            });
        }
    }];
}

-(void)setUpAutoWithHashtag:(NSString*)hastag{
    NSString *urlForTag = [NSString stringWithFormat:@"https://xpand.today/api/update-hashtag.php?user_id=%@&hashtag=%@",userProfile.userId , hastag];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlForTag]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error 4");
        } else {
            NSDictionary *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
           NSLog(@"!!!! %@", jsonDictionary);
        }
    }];
}

-(void)setUpCustomerWithCardToken:(NSString*)tok email:(NSString*)email{
    NSString *urlForTag = [NSString stringWithFormat:@"https://xpand.today/stripe/index.php?token=%@", tok];
//    NSString *urlForTag = [NSString stringWithFormat:@"http://192.168.21.210/github/web/php/xpand/stripe/index.php?token=%@", tok];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlForTag]];
    NSString *str = email;
    req.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];
    [req setHTTPMethod:@"POST"];
    [NSURLConnection sendAsynchronousRequest:req queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error 119: %@", error);
        } else {
            NSLog(@"NEW CUSTOMER");
        }
    }];
}

-(void)logout{
    NSString *urlForTag = @"https://instagram.com/accounts/logout/";
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlForTag]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error 5");
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UserProfile deactivateCurrentUserProfile];
                [ModelHelper saveManagedObjectContext];
                [self.delegate logoutFinished];
            });
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
    if (data){
        return YES;
    }else{
        [self.delegate instaError:@"No internet connection"];
        return NO;
    }
}

@end