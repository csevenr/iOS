//
//  PaymentViewController.m
//  xpand
//
//  Created by Oli Rodden on 10/03/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "PaymentViewController.h"
#import "PTKView.h"

@interface PaymentViewController () <PTKViewDelegate> {
    BOOL nameValid;
    BOOL emailValid;
    BOOL cardValid;
}

@property (weak, nonatomic) IBOutlet PTKView *paymentView;

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.paymentView.delegate = self;
    self.subscribeBtn.enabled = NO;
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
//    NSString *urlForTag = [NSString stringWithFormat:@"https://api.stripe.com/v1/customers/sk_test_BQokikJOvBiI2HlWgH4olfQ2:",userProfile.userId , hastag];
//    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlForTag]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        if (error) {
//            NSLog(@"Error 4");
//        } else {
//            NSDictionary *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//            
//            NSLog(@"!!!! %@", jsonDictionary);
//        }
//    }];
    /*
     https://api.stripe.com/v1/customers \
     -u sk_test_BQokikJOvBiI2HlWgH4olfQ2: \
     -d "description=Customer for test@example.com" \
     -d card=tok_14d5c12eZvKYlo2CIrrKegI5
     -d plan=gold
    */
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
