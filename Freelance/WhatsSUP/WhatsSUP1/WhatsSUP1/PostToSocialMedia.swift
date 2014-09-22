//
//  PostToSocialMedia.swift
//  WhatsSUP1
//
//  Created by Tim Teece on 12/09/2014.
//  Copyright (c) 2014 Tim Teece. All rights reserved.
//

import Foundation
import Accounts
import Social

class PostToSocialMedia:NSObject{
    
    var accountStore:ACAccountStore = ACAccountStore()
    var accountTypeTwitter:ACAccountType?=nil
    var accountTypeFacebook:ACAccountType?=nil
    
    override init () {
        //+++ need to add the old paths from the system - whereever we store them - ideally the  cloud
        super.init()
        accountTypeTwitter=accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountTypeFacebook=accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierFacebook)
        accountStore.requestAccessToAccountsWithType(accountTypeTwitter!, options: nil) { (granted:Bool, error:NSError!) -> Void in
            if var err=error {
                println("Error connecting to twitter \(error.description)")
            }else{
                if(granted == true){
                    if var arrayOfAccounts:NSArray=self.accountStore.accountsWithAccountType(self.accountTypeTwitter){
                        if arrayOfAccounts.count > 0{
                            // pick the last one to use
                            if var account:ACAccount=arrayOfAccounts.lastObject as? ACAccount{
                                var message:NSMutableDictionary = NSMutableDictionary()
                                message.setValue("A post from ios7", forKey: "status")
                                
                                var requestURL:NSURL = NSURL.URLWithString("https://api.twitter.com/1.1/statuses/update.json")
                                var postRequest:SLRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.POST, URL: requestURL, parameters: message)
                                
                                postRequest.account = account;
                                
                                postRequest.performRequestWithHandler({ (data:NSData!, response:NSHTTPURLResponse!, error:NSError!) -> Void in
                                    if var err=error{
                                        println("Error posting to twitter \(error.description)")
                                    }else{
                                        if var resp=response {
                                            println("Twitter HTTP response \(resp.statusCode)")
                                        }
                                    }
                                })
                            }
                        }
                    }
                }else{
                    println("Could not log into twitter")
                }
            }
        }
        
        
        // first time facebook
/*        var options:NSMutableDictionary = NSMutableDictionary()
        options.setValue("1502241743355198", forKey: ACFacebookAppIdKey)
        var optionArray = ["email","basic_info"]
        options.setValue(optionArray, forKey:ACFacebookPermissionsKey)
        options.setValue(ACFacebookAudienceFriends, forKey:ACFacebookAudienceKey)
        
        
        accountStore.requestAccessToAccountsWithType(accountTypeFacebook!, options: options) { (granted:Bool, error:NSError!) -> Void in
            if var err=error {
                println("Error connecting to facebook \(error.description)")
            }else{
                if(granted == true){
                    // we have access to facebook
                    if var arrayOfAccounts:NSArray=self.accountStore.accountsWithAccountType(self.accountTypeFacebook){
                        if arrayOfAccounts.count > 0{
                            // pick the last one to use
                            if var account:ACAccount=arrayOfAccounts.lastObject as? ACAccount{
                                println("done")
                            }
                        }
                    }
                }else{
                    println("Could not log into facebook")
                }
            }
        }
        
*/
        
        var optionsRead:NSMutableDictionary = NSMutableDictionary()
        optionsRead.setValue("1502241743355198", forKey: ACFacebookAppIdKey)
        var optionArrayRead = ["email","basic_info"]
        optionsRead.setValue(optionArrayRead, forKey:ACFacebookPermissionsKey)
        optionsRead.setValue(ACFacebookAudienceEveryone, forKey:ACFacebookAudienceKey)
        
        
        accountStore.requestAccessToAccountsWithType(accountTypeFacebook!, options: optionsRead) { (granted:Bool, error:NSError!) -> Void in
            if var err=error {
                println("Error connecting to facebook \(error.description)")
            }else{
                if(granted == true){
                    
                    var options:NSMutableDictionary = NSMutableDictionary()
                    options.setValue("1502241743355198", forKey: ACFacebookAppIdKey)
                    var optionArray = ["publish_actions"]
                    options.setValue(optionArray, forKey:ACFacebookPermissionsKey)
                    options.setValue(ACFacebookAudienceEveryone, forKey:ACFacebookAudienceKey)
                    
                    
                    self.accountStore.requestAccessToAccountsWithType(self.accountTypeFacebook!, options: options) { (granted:Bool, error:NSError!) -> Void in
                        if var err=error {
                            println("Error connecting to facebook \(error.description)")
                        }else{
                            if(granted == true){
                                // we have access to facebook
                                if var arrayOfAccounts:NSArray=self.accountStore.accountsWithAccountType(self.accountTypeFacebook){
                                    if arrayOfAccounts.count > 0{
                                        // pick the last one to use
                                        if var account:ACAccount=arrayOfAccounts.lastObject as? ACAccount{
                                            
                                            var message:NSMutableDictionary = NSMutableDictionary()
                                            message.setValue("A post from ios7", forKey: "message")
                                            message.setValue(account.credential.oauthToken, forKey: "access_token")
                                            
                                            var requestURL:NSURL = NSURL.URLWithString("https://graph.facebook.com/me/feed")
                                            var postRequest:SLRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.POST, URL: requestURL, parameters: message)
                                            
                                            //postRequest.account = account;
                                            /*[facebookRequest addMultipartData: myImageData
                                                withName:@"source"
                                            type:@"multipart/form-data"
                                            filename:@"TestImage"];
                                            */
                                            postRequest.performRequestWithHandler({ (data:NSData!, response:NSHTTPURLResponse!, error:NSError!) -> Void in
                                                if var err=error{
                                                    println("Error posting to facebook \(error.description)")
                                                }else{
                                                    if var resp=response {
                                                        println("Facebook HTTP response \(resp.statusCode)")
                                                    }
                                                }
                                            })
                                        }
                                    }
                                }
                            }else{
                                println("Could not log into facebook pubish")
                            }
                        }
                    }
                }else{
                    println("Could not log into facebook read")
                }
            }
        }

        // ok facebook:
        
    }
    
    
/*- (IBAction)postMessage:(id)sender {

ACAccountStore *accountStore = [[ACAccountStore alloc] init];

ACAccountType *accountTypeFacebook = [accountStore accountTypeWithAccountTypeIdentifier: ACAccountTypeIdentifierFacebook];

NSDictionary *options = @{ ACFacebookAppIdKey: @"<YOUR FACEBOOK APP ID KEY HERE>", ACFacebookPermissionsKey: @[@"publish_stream", @"publish_actions"],ACFacebookAudienceKey: ACFacebookAudienceFriends
};

[accountStore requestAccessToAccountsWithType:accountTypeFacebook options:options completion:^(BOOL granted, NSError *error) {

if(granted) {
    NSArray *accounts = [accountStore accountsWithAccountType:accountTypeFacebook];
    _facebookAccount = [accounts lastObject];

    NSDictionary *parameters = @{@"access_token":_facebookAccount.credential.oauthToken,@"message": @"My first iOS 7 Facebook posting"};

    NSURL *feedURL = [NSURL
    URLWithString:@"https://graph.facebook.com/me/feed"];

    SLRequest *feedRequest = [SLRequest
        requestForServiceType:SLServiceTypeFacebook
        requestMethod:SLRequestMethodPOST
        URL:feedURL
        parameters:parameters];

    [feedRequest performRequestWithHandler:^(NSData *responseData,NSHTTPURLResponse *urlResponse, NSError *error)
        {
            NSLog(@"Request failed, %@",
            [urlResponse description]);
            
        }];
} else {
    NSLog(@"Access Denied");
    NSLog(@"[%@]",[error localizedDescription]);
}

}];
}
*/

    /*
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:
    ACAccountTypeIdentifierTwitter];

    [account requestAccessToAccountsWithType:accountType
    options:nil
    completion:^(BOOL granted, NSError *error)
    {
    if (granted == YES)
    {
    // Get account and communicate with Twitter API
    }
    }];
*/
}

