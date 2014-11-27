//
//  MasterViewController.m
//  GramManager
//
//  Created by Oliver Rodden on 30/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "LikeMasterViewController.h"
//#import "ManualGridViewController.h"
//#import "AutoViewController.h"
#import "ModelHelper.h"
#import "UserProfile+Helper.h"
#import "LoginViewController.h"
#import "AlertLabel.h"

@interface LikeMasterViewController(){
    Menu * menu;
    BOOL alertIsShowing;
}

@end

@implementation LikeMasterViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self==[super initWithCoder:aDecoder]) {
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    insta = [Insta new];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.likeCountLbl.text=[NSString stringWithFormat:@"%d",[userProfile.likedPosts count]];
}

-(void)viewDidAppear:(BOOL)animated{
    [self login];
    [super viewDidAppear:animated];
}

-(void)login{
    if ([UserProfile getActiveUserProfile]!=nil) {
        userProfile = [UserProfile getActiveUserProfile];
    }else{
        [self performSegueWithIdentifier:@"login" sender:[NSNumber numberWithBool:YES]];
    }
}



-(void)likedPost{
    self.likeCountLbl.text=[NSString stringWithFormat:@"%d",[userProfile.likedPosts count]];
}

-(void)swicthButtonPressed{
    [UserProfile deactivateCurrentUserProfile];
    userProfile = nil;
    [self login];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSNumber*)sender{
    if ([segue.identifier isEqualToString:@"login"]){
        self.loginVc = segue.destinationViewController;
        [(LoginViewController*)self.loginVc setLogin:[sender boolValue]];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    
    if (!CGRectContainsPoint(self.searchContainer.frame, location)) {
//        [self textFieldShouldReturn:self.hashtagTextField];
        [self closeTextField];
    }
}

-(void)showAlertLabelWithString:(NSString*)string{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.alertLbl.text=string;
        if (!alertIsShowing) {
            alertIsShowing = YES;
            [self replaceConstraintOnView:self.alertLbl withConstant:self.alertLbl.frame.origin.y+50 andAttribute:NSLayoutAttributeTop onSelf:NO];
            [self animateConstraintsWithDuration:0.3 delay:0.0 andCompletionHandler:nil];
            
            [self replaceConstraintOnView:self.alertLbl withConstant:self.alertLbl.frame.origin.y-50 andAttribute:NSLayoutAttributeTop onSelf:NO];
            [self animateConstraintsWithDuration:0.3 delay:2.0 andCompletionHandler:^{alertIsShowing = NO;}];        
        }
    });
}



#pragma Mark tableView delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;    //count number of row from counting array hear cataGorry is An Array
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    
    // Here we use the provided setImageWithURL: method to load the web image
    // Ensure you use a placeholder image otherwise cells will be initialized with no image
    
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:userProfile.recentHashtags];
    if (indexPath.row<=[array count]-1) {
        cell.textLabel.text = [array objectAtIndex:indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hashtagTextField.text=[tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    [self textFieldShouldReturn:self.hashtagTextField];
    [self searchBtnPressed];
}

#pragma Mark textField delegate methods

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.hashtagTableView reloadData];
    [self replaceConstraintOnView:self.searchContainer withConstant:182.0 andAttribute:NSLayoutAttributeHeight onSelf:YES];
    [self animateConstraintsWithDuration:0.3 delay:0.0 andCompletionHandler:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self searchBtnPressed];
    [self closeTextField];
    return YES;
}

-(void)closeTextField{ //split into this method so if you click outside you dont search
    [self.hashtagTextField resignFirstResponder];
    [self replaceConstraintOnView:self.searchContainer withConstant:50.0 andAttribute:NSLayoutAttributeHeight onSelf:YES];
    [self animateConstraintsWithDuration:0.3 delay:0.0 andCompletionHandler:nil];
}

@end