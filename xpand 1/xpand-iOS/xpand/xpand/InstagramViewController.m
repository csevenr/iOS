//
//  InstagramViewController.m
//  xpand
//
//  Created by Oliver Rodden on 02/01/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "InstagramViewController.h"
#import "UserProfile+Helper.h"
#import "ModelHelper.h"

@interface InstagramViewController ()

@end

@implementation InstagramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.usernameLbl.text = [NSString stringWithFormat:@"@%@", [UserProfile getActiveUserProfile].userName];
    
    self.profilePicImgView.layer.cornerRadius = 70.0;
    self.profilePicImgView.backgroundColor = [UIColor lightGrayColor];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[UserProfile getActiveUserProfile].profilePictureURL]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error c");
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.profilePicImgView.image = [UIImage imageWithData:data];
                userProfile.profilePicture = data;
                self.profilePicImgView.layer.cornerRadius = 70.0;
            });
        }
    }];
}

- (IBAction)AutoBtnPressed:(id)sender {
    if ([userProfile.subscriber boolValue] == YES) {
        [self performSegueWithIdentifier:@"auto" sender:nil];
    }else{
        [self showXpandPlusView];
    }
}

-(void)subscribeBtnPressed{
    for (UIButton *btn in self.mainBtns) {
        [btn setEnabled:NO];
    }
    [self performSegueWithIdentifier:@"payment" sender:nil];
}

-(void)popUpDismissed{
    [self enableBtns];
}

-(void)enableBtns{
    for (UIButton *btn in self.mainBtns) {
        [btn setEnabled:YES];
    }
}

-(void)subscribed{
    [self performSegueWithIdentifier:@"auto" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue destinationViewController] isKindOfClass:[PaymentViewController class]]) {
        self.paymentVC = (PaymentViewController*)[segue destinationViewController];
        self.paymentVC.delegate = self;
    }
}

-(void)paymentVCFinsihed{
    userProfile.subscriber = [NSNumber numberWithBool:YES];
    [ModelHelper saveManagedObjectContext];
    [xView closeSelf];
    [self performSegueWithIdentifier:@"auto" sender:nil];
    [self enableBtns];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end