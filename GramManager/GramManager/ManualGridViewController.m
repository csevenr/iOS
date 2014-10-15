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

- (IBAction)searchBtnPressed {
    [self.hashtagTextField resignFirstResponder];
    if ([posts count]>0) [posts removeAllObjects];

    if (![self.hashtagTextField.text isEqualToString:@""]) {
        [self searchingUi];
        [self getJSON];
    }else{
        NSLog(@"no hashtag");
    }
}

-(void)getJSON{
    if (![self.hashtagTextField.text isEqualToString:@""]) {
        [insta getJsonForHashtag:self.hashtagTextField.text];
        [insta setDelegate:self];
    }
}

-(void)JSONReceived:(NSDictionary *)JSONDictionary{
   [self performSelectorOnMainThread:@selector(searchingUi) withObject:nil waitUntilDone:NO];
    if (JSONDictionary!=nil) {
        if ([[JSONDictionary objectForKey:@"data"] count]==0) {//Invalid hashtag, no data in JSON
            [self performSelectorOnMainThread:@selector(showAlertView) withObject:nil waitUntilDone:NO];//call ui on main thread
        }else{//Valid hashtag, Create a post object for each entry
            for (NSDictionary *postDict in [JSONDictionary objectForKey:@"data"]) {
                Post *post = [[Post alloc]initWithDictionary:postDict];
                [posts addObject:post];
            }
            //reload the table view with new data
            [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:NO];//call ui on main thread
        }
    }
}

-(void)reload{
    [self.postCollView reloadData];
}

-(void)searchingUi{
    self.searchActivityIndcator.hidden=!self.searchActivityIndcator.hidden;
    
    if ([self.searchActivityIndcator isAnimating])[self.searchActivityIndcator stopAnimating];
    else [self.searchActivityIndcator startAnimating];
}

-(void)showAlertView{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No posts" message:@"We didn't find any posts for that hashtag" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

-(void)updateLikeStatusLbl{
    if (userProfile!=nil) {
        if (userProfile.likeTime == nil||[[NSDate date] timeIntervalSinceDate:userProfile.likeTime]>=3600.000001) {
            self.likeStatusLbl.text=@"30 likes remaining";
        }else if ([[NSDate date] timeIntervalSinceDate:userProfile.likeTime]<3600.000001){
//            NSLog(@"%d", 3600-(int)floorf([[NSDate date] timeIntervalSinceDate:userProfile.likeTime]));
            if ([userProfile.likesInHour integerValue]<30) {
                self.likeStatusLbl.text=[NSString stringWithFormat:@"%d likes remaining", 30-[userProfile.likesInHour integerValue]];
            }else if ([userProfile.likesInHour integerValue]>=30){
                int mins = (int)floorf([[NSDate date] timeIntervalSinceDate:userProfile.likeTime]/60);
                self.likeStatusLbl.text=[NSString stringWithFormat:@"%dm until likes are restored", 60-mins];
            }
        }
    }
}

#pragma Mark collView methods

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (userProfile.likeTime == nil) {
        userProfile.likeTime = [NSDate date];
    }
    NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:userProfile.likeTime];
    if (secondsBetween >= 3600.000001) {
        userProfile.likeTime = [NSDate date];
        userProfile.likesInHour = [NSNumber numberWithInt:0];
    }else{
        if ([userProfile.likesInHour integerValue]<30) {
            Post *selectedPost = [posts objectAtIndex:indexPath.row];
            [insta likePost:selectedPost];
            
            [posts removeObject:selectedPost];
            if ([posts count]==4){//only 4 left in table view, so paginate
                [self getJSON];
            }
            [self.postCollView reloadData];
            
            userProfile.likesInHour = [NSNumber numberWithInt:[userProfile.likesInHour integerValue]+1];
            [ModelHelper saveManagedObjectContext];
            [self updateLikeStatusLbl];
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
//    PostCollectionViewCell *cell;

    if (cell == nil){
        cell = [PostCollectionViewCell new];
    }
    cell.post = [posts objectAtIndex:indexPath.row];

    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //got to the bottom. Paginate
    if (scrollView.contentOffset.y+scrollView.frame.size.height == scrollView.contentSize.height) {
        [self getJSON];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self searchBtnPressed];
    return YES;
}

@end