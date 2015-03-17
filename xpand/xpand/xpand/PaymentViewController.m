//
//  PaymentViewController.m
//  xpand
//
//  Created by Oli Rodden on 10/03/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "PaymentViewController.h"
#import "Insta.h"
#import "PTKView.h"
#import "STPAPIClient.h"
#import "STPCard.h"

@interface PaymentViewController () <PTKViewDelegate> {
    BOOL nameValid;
    BOOL emailValid;
    BOOL cardValid;
    
    NSString *emailString;
    
    Insta *insta;
    
    STPCard *currentCard;
}

@property (weak, nonatomic) IBOutlet PTKView *paymentView;

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.paymentView.delegate = self;
    self.subscribeBtn.enabled = NO;
    
    insta = [Insta new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)paymentView:(PTKView *)view withCard:(PTKCard *)card isValid:(BOOL)valid
{
    NSLog(@"Valid card");
    cardValid = YES;
    
    if (nameValid && emailValid && cardValid) {
        self.subscribeBtn.enabled = YES;        
    }
    
    currentCard = [[STPCard alloc] init];
    currentCard.number = card.number;
    currentCard.expMonth = card.expMonth;
    currentCard.expYear = card.expYear;
    currentCard.cvc = card.cvc;
    
    // Toggle navigation, for example
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)subscribeBtnPressed:(id)sender {
    [[STPAPIClient sharedClient] createTokenWithCard:currentCard
                                          completion:^(STPToken *token, NSError *error) {
                                              if (error) {
                                                  NSLog(@"Error 224 %@", error);
                                              } else {
                                                  NSLog(@"Card token %@", token);
                                              }
                                              
                                              NSString *tokenString = [NSString stringWithFormat:@"%@", token];

                                              
                                              NSRange range = [tokenString rangeOfString:@" "];
                                              
                                              NSString *newString = [tokenString substringWithRange:NSMakeRange(0, range.location)];
                                              NSLog(@"newstring: %@",newString);

                                              [insta setUpCustomerWithCardToken:newString email:emailString];
                                          }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField.tag == 0) {
        //name
        nameValid = YES;
    }else{
        //email
        emailValid = [self validateEmailWithString:newString];
        emailString = newString;
    }
    
    if (nameValid && emailValid && cardValid) {
        self.subscribeBtn.enabled = YES;
    }
    
    return YES;
}

- (BOOL)validateEmailWithString:(NSString*)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

@end
