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
#import "ImageDownloader.h"

@interface ManualGridViewController (){
    NSMutableArray *posts;
    NSTimer *likeStatusTimer;
    NSMutableDictionary *imageDownloadsInProgress;
}

@end

@implementation ManualGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Likes" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    self.searchActivityIndcator.hidden=YES;//set this in code, because it didnt work on storyboard for some reason??
    posts = [NSMutableArray new];
    likeStatusTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateLikeStatusLbl) userInfo:nil repeats:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateLikeStatusLbl];
}

- (IBAction)searchBtnPressed {
    if ([posts count]>0) [posts removeAllObjects];

    if (![self.hashtagTextField.text isEqualToString:@""]) {
        [self searchingUi];
        [self getJSON];
    }else{
        NSLog(@"no hashtag");
    }
}

-(void)JSONReceived:(NSDictionary *)JSONDictionary{
   [self performSelectorOnMainThread:@selector(searchingUi) withObject:nil waitUntilDone:NO];
    if (JSONDictionary!=nil) {
        if ([[JSONDictionary objectForKey:@"data"] count]==0) {//Invalid hashtag, no data in JSON
            [self performSelectorOnMainThread:@selector(showAlertView) withObject:nil waitUntilDone:NO];//call ui on main thread
        }else{//Valid hashtag, Create a post object for each entry
            for (int i=0; i<[[JSONDictionary objectForKey:@"data"] count]; i++) {
                Post *post = [[Post alloc]initWithDictionary:[[JSONDictionary objectForKey:@"data"] objectAtIndex:i]];
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
//        userProfile.likesInHour = [NSNumber numberWithInt:0];
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
    return UIEdgeInsetsMake(0, 10.0, 0, 10.0);
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
    PostCollectionViewCell *cell = nil;
    
    NSUInteger nodeCount = [posts count];
    
    static NSString *MyIdentifier = @"postCell";
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:MyIdentifier forIndexPath:indexPath];
    
    // Leave cells empty if there's no data yet
    if (nodeCount > 0){
        // Set up the cell representing the app
        Post *post = (posts)[indexPath.row];
        
        // Only load cached images; defer new downloads until scrolling ends
        if (!post.thumbnailImg){
            if (collectionView.dragging == NO && collectionView.decelerating == NO){
                [self startImageDownload:post forIndexPath:indexPath];
            }
            // if a download is deferred or in progress, return a placeholder image
            cell.mainImg.image = nil;
            cell.backgroundColor = [UIColor lightGrayColor];
        }else{
            cell.mainImg.image = post.thumbnailImg;
        }
    }
    
    return cell;
}

-(void)startImageDownload:(Post*)post forIndexPath:(NSIndexPath *)indexPath{
    ImageDownloader *iconDownloader = (imageDownloadsInProgress)[indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[ImageDownloader alloc] init];
        iconDownloader.post = post;
        [iconDownloader setCompletionHandler:^{
            
            PostCollectionViewCell *cell = (PostCollectionViewCell*)[self.postCollView cellForItemAtIndexPath:indexPath];
            
            // Display the newly loaded image
            cell.mainImg.image = post.thumbnailImg;
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        (imageDownloadsInProgress)[indexPath] = iconDownloader;
        [iconDownloader startDownload];
    }
}

// -------------------------------------------------------------------------------
//	loadImagesForOnscreenRows
//  This method is used in case the user scrolled into a set of cells that don't
//  have their app icons yet.
// -------------------------------------------------------------------------------
- (void)loadImagesForOnscreenRows
{
    if ([posts count] > 0)
    {
        NSArray *visiblePaths = [self.postCollView indexPathsForVisibleItems];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            Post *post = (posts)[indexPath.row];
            
            if (!post.thumbnailImg)
                // Avoid the app icon download if the app already has an icon
            {
                [self startImageDownload:post forIndexPath:indexPath];
            }
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //got to the bottom. Paginate
    if (scrollView.contentOffset.y+scrollView.frame.size.height == scrollView.contentSize.height) {
        if ([posts count]<81) {
            [self getJSON];
        }
    }
}

// -------------------------------------------------------------------------------
//	scrollViewDidEndDragging:willDecelerate:
//  Load images for all onscreen rows when scrolling is finished.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadImagesForOnscreenRows];
    }
}

// -------------------------------------------------------------------------------
//	scrollViewDidEndDecelerating:scrollView
//  When scrolling stops, proceed to load the app icons that are on screen.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [super textFieldDidBeginEditing:textField];
    self.postCollView.userInteractionEnabled=NO;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [super textFieldShouldReturn:textField];
    self.postCollView.userInteractionEnabled=YES;
    return YES;
}

#pragma Mark adBanner methods
- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
//    NSLog(@"%@", self.view.constraints);
    [super bannerViewDidLoadAd:banner];
    [self replaceConstraintOnView:self.postCollView withConstant:self.postCollView.frame.size.height-50 andAttribute:NSLayoutAttributeHeight onSelf:NO];
    [self animateConstraints];
}

//- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
//    [super bannerView:banner didFailToReceiveAdWithError:error];
//    [self replaceConstraintOnView:self.postCollView withConstant:self.postCollView.frame.size.height+50 andAttribute:NSLayoutAttributeHeight onSelf:YES];
//    [self animateConstraints];
//}

@end