//
//  ProfileViewController.m
//  GramManager
//
//  Created by Oliver Rodden on 09/10/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "ProfileViewController.h"
#import "Insta.h"
#import "UserProfile+Helper.h"
#import "ModelHelper.h"
#import "STPAPIClient.h"
#import "STPCard.h"

@interface ProfileViewController () {
    BOOL updated;
    Insta *insta;
}

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_async(dispatch_get_main_queue(), ^{
        insta = [Insta new];
        insta.delegate = self;
        [self setUpView];
    });
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    insta.delegate = nil;
    self.loginVc.delegate = nil;
}

-(void)setUpView{
    userProfile = [UserProfile getActiveUserProfile];
    self.usernameLbl.text = userProfile.userName;
    if (userProfile.profilePicture!=nil) {
        self.profilePicImg.image = [UIImage imageWithData:userProfile.profilePicture];
    }

    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:userProfile.profilePictureURL]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error c");
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.profilePicImg.image = [UIImage imageWithData:data];
                userProfile.profilePicture = data;
                [ModelHelper saveManagedObjectContext];
            });
        }
    }];
    self.profilePicImg.layer.cornerRadius=self.profilePicImg.frame.size.width/2;
    self.profilePicImg.clipsToBounds=YES;
    self.followersLbl.text = [NSString stringWithFormat:@"%d",[userProfile.followers intValue]];
    self.followingLbl.text = [NSString stringWithFormat:@"%d",[userProfile.follows intValue]];
    if ([userProfile.recentCount intValue]==1) {//+++ check on 1 and less then 10 posts
        self.lastTenPostsLbl.text = @"Post stats";
    }else if ([userProfile.recentCount intValue]>=10){
        self.lastTenPostsLbl.text = [NSString stringWithFormat:@"Last %d posts",[userProfile.recentCount intValue]];
    }/*else{
      self.lastTenPostsLbl.text = @"Last 10 posts";
      }*/
    self.averageLikesLbl.text = [NSString stringWithFormat:@"%d",[userProfile.recentLikes intValue]/[userProfile.recentCount intValue]];
    self.mostLikesLbl.text = [NSString stringWithFormat:@"%d",[userProfile.recentMostLikes intValue]];
    self.leastLikesLbl.text = [NSString stringWithFormat:@"%d",[userProfile.recentLeastLikes intValue]];
    
    if (!updated) {
        [insta getUserInfo];
    }
}

-(void)userInfoFinished{
    updated = YES;
    [self setUpView];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSNumber*)sender{
    if ([segue.identifier isEqualToString:@"login"]){
        userProfile.isActive=[NSNumber numberWithBool:NO];
        
        self.loginVc = (LoginViewController*)segue.destinationViewController;
        self.loginVc.delegate = self;
    }
}

- (IBAction)xpandPlusBtnPressed:(id)sender {
    [self showXpandPlusView];
}

- (IBAction)logoutBtnPressed{
    [insta logout];
    [self.logoutBtn setTitle:@"Logging Out" forState:UIControlStateNormal];
}

- (IBAction)unsubscribeBtnPressed{
    [insta unsubscribeCustomer];
}

- (IBAction)changeCardBtnPressed{
    STPCard *currentCard = [[STPCard alloc] init];
    currentCard.number = @"4012888888881881";
    currentCard.expMonth = 1;
    currentCard.expYear = 2017;
    currentCard.cvc = @"001";
    
    [[STPAPIClient sharedClient] createTokenWithCard:currentCard
                                          completion:^(STPToken *token, NSError *error) {
                                              if (error) {
                                                  NSLog(@"Error 124 %@", error);
                                              } else {
                                                  NSLog(@"Card token %@", token);
                                              }
                                              
                                              NSString *tokenString = [NSString stringWithFormat:@"%@", token];
                                              
                                              
                                              NSRange range = [tokenString rangeOfString:@" "];
                                              
                                              NSString *newString = [tokenString substringWithRange:NSMakeRange(0, range.location)];
                                              NSLog(@" new card string: %@",newString);
                                              
                                              [insta changeCustomerCardDeatils:newString];
                                          }];

}

-(void)logoutFinished{
    [self popSelf];
}

-(void)loginFinished{
    [self setUpView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
