//
//  ManualGridViewController.m
//  GramManager
//
//  Created by Oliver Rodden on 29/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "ManualGridViewController.h"
#import "Post.h"
#import "PostCollectionViewCell.h"
#import "UserProfile+Helper.h"
#import "ModelHelper.h"

@interface ManualGridViewController (){
    NSMutableArray *posts;
    NSTimer *likeStatusTimer;
}

@end

@implementation ManualGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchActivityIndcator.hidden=YES;//set this in code, because it didnt work on storyboard for some reason??
    posts = [NSMutableArray new];
    likeStatusTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateLikeStatusLbl) userInfo:nil repeats:YES];
    [self updateLikeStatusLbl];
}

-(void)viewDidAppear:(BOOL)animated{
    [self performSegueWithIdentifier:@"auto" sender:nil];
}

- (IBAction)searchBtnPressed:(id)sender {
    if ([posts count]>0) [posts removeAllObjects];
    
    [self searchingUi];
    [self getJSON];
}

-(void)getJSON{
    if (![self.hashtagTextField.text isEqualToString:@""]) {
        [insta getJsonForHashtag:self.hashtagTextField.text];
        [insta setDelegate:self];
    }
}

-(void)JSONReceived:(NSDictionary *)JSONDictionary{
    [self performSelectorOnMainThread:@selector(searchingUi) withObject:nil waitUntilDone:NO];
    for (NSDictionary *postDict in [JSONDictionary objectForKey:@"data"]) {
        Post *post = [[Post alloc]initWithDictionary:postDict];
        [posts addObject:post];
    }
    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:NO];//call ui on main thread
}

-(void)reload{
    [self.postCollView reloadData];
}

-(void)searchingUi{
    self.searchBtn.hidden=!self.searchBtn.hidden;
    self.searchActivityIndcator.hidden=!self.searchActivityIndcator.hidden;
    
    if ([self.searchActivityIndcator isAnimating])[self.searchActivityIndcator stopAnimating];
    else [self.searchActivityIndcator startAnimating];
}

-(void)updateLikeStatusLbl{
    if ([UserProfile getActiveUserProfile].likeTime == nil||[[NSDate date] timeIntervalSinceDate:[UserProfile getActiveUserProfile].likeTime]>=3600.000001) {
        self.likeStatusLbl.text=@"30 likes remaining";
    }else if ([[NSDate date] timeIntervalSinceDate:[UserProfile getActiveUserProfile].likeTime]<3600.000001){
        if ([[UserProfile getActiveUserProfile].likesInHour integerValue]<30) {
            self.likeStatusLbl.text=[NSString stringWithFormat:@"%d likes remaining", 30-[[UserProfile getActiveUserProfile].likesInHour integerValue]];
        }else if ([[UserProfile getActiveUserProfile].likesInHour integerValue]>=30){
            int mins = (int)ceilf([[NSDate date] timeIntervalSinceDate:[UserProfile getActiveUserProfile].likeTime]/30);
            self.likeStatusLbl.text=[NSString stringWithFormat:@"%dm until likes are restored", 60-mins];
        }
    }
}

#pragma Mark collView methods

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([UserProfile getActiveUserProfile].likeTime == nil) {
        [UserProfile getActiveUserProfile].likeTime = [NSDate date];
    }
    NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:[UserProfile getActiveUserProfile].likeTime];
    NSLog(@"%f", secondsBetween);
    if (secondsBetween >= 3600.000001) {
        [UserProfile getActiveUserProfile].likeTime = [NSDate date];
        [UserProfile getActiveUserProfile].likesInHour = [NSNumber numberWithInt:0];
    }else{
        if ([[UserProfile getActiveUserProfile].likesInHour integerValue]<30) {
            Post *selectedPost = [posts objectAtIndex:indexPath.row];
            [insta likePost:selectedPost];
            
            [posts removeObject:selectedPost];
            [self.postCollView reloadData];
            
            [UserProfile getActiveUserProfile].likesInHour = [NSNumber numberWithInt:[[UserProfile getActiveUserProfile].likesInHour integerValue]+1];
            [ModelHelper saveManagedObjectContext];
            [self updateLikeStatusLbl];
//            NSLog(@"## %d", [[UserProfile getActiveUserProfile].likesInHour integerValue]);
//        }else if ([[UserProfile getActiveUserProfile].likesInHour integerValue]==30){
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Like limit reached" message:@"You are only allow 30 likes an hour" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 20.0, 0, 10.0);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [posts count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"postCell";
    
    PostCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MyIdentifier forIndexPath:indexPath];
    
    if (cell == nil){
        cell = [PostCollectionViewCell new];
    }
    cell.post = [posts objectAtIndex:indexPath.row];

    return cell;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self searchBtnPressed:nil];
    [textField resignFirstResponder];
    return YES;
}

@end