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

@interface ManualGridViewController (){
    NSMutableArray *posts;
}

@end

@implementation ManualGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchActivityIndcator.hidden=YES;//set this in code, because it didnt work on storyboard for some reason??
    posts = [NSMutableArray new];
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
//    NSLog(@"JSON recived");
//    NSLog(@"%@",JSONDictionary);
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

#pragma Mark collView methods

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Post *selectedPost = [posts objectAtIndex:indexPath.row];
    [insta likePost:selectedPost];
    
    [posts removeObject:selectedPost];
    [self.postCollView reloadData];
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

@end