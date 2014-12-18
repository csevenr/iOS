//
//  ViewController.m
//  xpand
//
//  Created by Oliver Rodden on 27/11/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "LikeViewController.h"
#import "Post.h"
#import "PostCollectionViewCell.h"
#import "UserProfile+Helper.h"
#import "ModelHelper.h"
#import "ImageDownloader.h"
#import "AlertLabel.h"
#import "FloatingHeaderViewFlowLayout.h"
#import "CircleProgressBar.h"

#define FONT [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0]

@interface LikeViewController () {
    UIView *hashtagTextFieldView;
    UITextField *hashtagTextField;
    UITableView *hashtagTableView;
    UICollectionView *postCollView;

    CircleProgressBar *circle;
    
    NSMutableArray *posts;
    NSTimer *likeStatusTimer;
    NSMutableDictionary *imageDownloadsInProgress;
    
    BOOL alertIsShowing;
}

@end

@implementation LikeViewController

#pragma mark view

- (void)viewDidLoad {
    [super viewDidLoad];
    insta = [Insta new];
    
    self.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Likes" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    postCollView = [[UICollectionView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:[[FloatingHeaderViewFlowLayout alloc] init]];
    postCollView.delegate = self;
    postCollView.dataSource = self;
    postCollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:postCollView];
    
    [postCollView registerClass:[PostCollectionViewCell class] forCellWithReuseIdentifier:@"postCell"];
    [postCollView registerClass:[PostCollectionViewCell class] forCellWithReuseIdentifier:@"spineyCell"];
    [postCollView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"blankHeader"];
    [postCollView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"searchHeader"];

    imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    self.searchActivityIndcator.hidden=YES;//set this in code, because it didnt work on storyboard for some reason??
    posts = [NSMutableArray new];
    likeStatusTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateLikeStatusLbl) userInfo:nil repeats:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.likeCountLbl.text=[NSString stringWithFormat:@"%d",[userProfile.likedPosts count]];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self login];
    [self updateLikeStatusLbl];
}

#pragma mark interaction

-(void)login{
    if ([UserProfile getActiveUserProfile]!=nil) {
        userProfile = [UserProfile getActiveUserProfile];
    }else{
        [self performSegueWithIdentifier:@"login" sender:[NSNumber numberWithBool:YES]];
    }
}

-(void)likedPost{
    self.likeCountLbl.text=[NSString stringWithFormat:@"%d",[userProfile.likedPosts count]];
    [self updateLikeStatusLbl];
}

//-(void)swicthButtonPressed{
//    [UserProfile deactivateCurrentUserProfile];
//    userProfile = nil;
//    [self login];
//}

- (IBAction)searchBtnPressed {
    if ([posts count]>0) [posts removeAllObjects];
    
    if (![hashtagTextField.text isEqualToString:@""]) {
        [self searchingUi];
        [self getJSON];
    }else{
        [self showAlertLabelWithString:@"No hashtag"];
    }
}

-(void)JSONReceived:(NSDictionary *)JSONDictionary{
    [self performSelectorOnMainThread:@selector(searchingUi) withObject:nil waitUntilDone:NO];
    if (JSONDictionary!=nil) {
        if ([[JSONDictionary objectForKey:@"data"] count]==0) {//Invalid hashtag, no data in JSON
            [self showAlertLabelWithString:@"No posts for that hashtag"];
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

//-(void)loginFinished{
//    [self popSelf];
//}

-(void)getJSON{
    if (![hashtagTextField.text isEqualToString:@""]) {
        if ([[hashtagTextField.text substringToIndex:1] isEqualToString:@"#"]) {
            hashtagTextField.text=[hashtagTextField.text substringFromIndex:1];
        }
        [insta getJsonForHashtag:hashtagTextField.text];
        [insta setDelegate:self];
        [self addHashtagToRecentArray:hashtagTextField.text];
    }
}

-(void)reload{
    [postCollView reloadData];
}

-(void)searchingUi{
    self.searchActivityIndcator.hidden=!self.searchActivityIndcator.hidden;
    
    if ([self.searchActivityIndcator isAnimating])[self.searchActivityIndcator stopAnimating];
    else [self.searchActivityIndcator startAnimating];
}

-(void)updateLikeStatusLbl{
    if (userProfile!=nil) {
        if (userProfile.likeTime == nil||[[NSDate date] timeIntervalSinceDate:userProfile.likeTime]>=3600.000001) {
            self.likeStatusLbl.text=@"30 likes remaining";
        }else if ([[NSDate date] timeIntervalSinceDate:userProfile.likeTime]<3600.000001){
            if ([userProfile.likesInHour integerValue]<30) {
                self.likeStatusLbl.text=[NSString stringWithFormat:@"%d likes remaining", 30-[userProfile.likesInHour integerValue]];
//                NSLog(@"%d, %f, %f", [userProfile.likesInHour integerValue], [userProfile.likesInHour integerValue]/30.0, 1.0-([userProfile.likesInHour integerValue]/30.0));
                circle.value = 1.0-([userProfile.likesInHour integerValue]/30.0);
            }else if ([userProfile.likesInHour integerValue]>=30){
                int mins = (int)floorf([[NSDate date] timeIntervalSinceDate:userProfile.likeTime]/60);
                self.likeStatusLbl.text=[NSString stringWithFormat:@"%dm until likes are restored", 60-mins];
            }
        }
    }
}

-(void)instaError:(NSString *)errorString{
    [self showAlertLabelWithString:errorString];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    
    if (!CGRectContainsPoint(hashtagTextFieldView.frame, location)) {
        //        [self textFieldShouldReturn:self.hashtagTextField];
        [self closeTextField];
    }
}

#pragma mark navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSNumber*)sender{
    if ([segue.identifier isEqualToString:@"login"]){
        self.loginVc = segue.destinationViewController;
        [(LoginViewController*)self.loginVc setLogin:[sender boolValue]];
    }
}

#pragma mark Utils

-(void)addHashtagToRecentArray:(NSString*)hashtag{
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:userProfile.recentHashtags];
    if (array==nil) {
        array=[NSMutableArray new];
    }
    
    NSArray *hashtagToRemove;
    for (NSString *hashtagInArray in array) {
        if ([hashtagInArray isEqualToString:hashtag]){
            hashtagToRemove = [NSArray arrayWithObject:hashtagInArray];//add to array and remove after loop to avoid mutating whilst enumerating
        }
    }
    [array removeObjectsInArray:hashtagToRemove];
    [array insertObject:hashtag atIndex:0];
    
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:array];
    userProfile.recentHashtags = arrayData;
    [ModelHelper saveManagedObjectContext];
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

#pragma mark collView methods

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
            [postCollView reloadData];
            
            userProfile.likesInHour = [NSNumber numberWithInt:[userProfile.likesInHour integerValue]+1];
            [ModelHelper saveManagedObjectContext];
            [self updateLikeStatusLbl];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Like limit reached" message:@"You are only allow 30 likes an hour" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PostCollectionViewCell *cell = nil;
    
    if (indexPath.section == 0){

        static NSString *MyIdentifier = @"spineyCell";
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:MyIdentifier forIndexPath:indexPath];
        
        circle = [[CircleProgressBar alloc]initWithFrame:CGRectMake(0.0, 0.0, cell.frame.size.width, cell.frame.size.height)];
        circle.value = 1.0;
        [cell addSubview:circle];
        
//        cell.backgroundColor = [UIColor redColor];
    
    }else if (indexPath.section == 1){
        static NSString *MyIdentifier = @"postCell";
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:MyIdentifier forIndexPath:indexPath];
        
        NSUInteger nodeCount = [posts count];
        //    // Leave cells empty if there's no data yet
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
//        cell.backgroundColor = [UIColor blueColor];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = nil;
    
    if (indexPath.section == 0) {
        if (kind == UICollectionElementKindSectionHeader) {
            
            headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"blankHeader" forIndexPath:indexPath];
            
//            headerView.backgroundColor = [UIColor yellowColor];
        }
    }else if (indexPath.section == 1) {
        if (kind == UICollectionElementKindSectionHeader) {
            
            headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"searchHeader" forIndexPath:indexPath];
            
            UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(16.0, 70, self.view.frame.size.width - 32.0, 50.0)];
            [searchBtn setTitle:@"Search" forState:UIControlStateNormal];
            [searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [searchBtn.titleLabel setFont:FONT];
            [headerView addSubview:searchBtn];
            
            searchBtn.layer.borderWidth=1.0;
            searchBtn.layer.borderColor=[UIColor blackColor].CGColor;
            
            hashtagTextFieldView = [[UIView alloc]initWithFrame:CGRectMake(16.0, 10, self.view.frame.size.width - 32.0, 50.0)];
            [headerView addSubview:hashtagTextFieldView];
            
            hashtagTextFieldView.layer.borderWidth=1.0;
            hashtagTextFieldView.layer.borderColor=[UIColor blackColor].CGColor;
            
            hashtagTextField = [[UITextField alloc]initWithFrame:CGRectMake(10.0, 0.0, self.view.frame.size.width - 20.0, 50.0)];
            [hashtagTextField setFont:FONT];
//            hashtagTextField.placeholder = @"#";
            hashtagTextField.delegate = self;
            
            hashtagTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, hashtagTextFieldView.frame.size.height, hashtagTextFieldView.frame.size.width, 44*3)];
            hashtagTableView.delegate = self;
            hashtagTableView.dataSource = self;
            
            [hashtagTextFieldView addSubview:hashtagTextField];
            [hashtagTextFieldView addSubview:hashtagTableView];
            hashtagTextFieldView.clipsToBounds = YES;
            
            headerView.backgroundColor = [UIColor whiteColor];
            
        }
    }
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.view.frame.size.width-30)/2, (self.view.frame.size.width-30)/2);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return UIEdgeInsetsMake(0, (self.view.frame.size.width/2)-((self.view.frame.size.width-30)/2), 0, 10.0);
    }else{
        return UIEdgeInsetsMake(0, 10.0, 0, 10.0);
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return [posts count];
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(200.0, 20.0);
    }else{
        return CGSizeMake(200.0, 130.0);
    }
}

#pragma mark image download

-(void)startImageDownload:(Post*)post forIndexPath:(NSIndexPath *)indexPath{
    ImageDownloader *iconDownloader = (imageDownloadsInProgress)[indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[ImageDownloader alloc] init];
        iconDownloader.post = post;
        [iconDownloader setCompletionHandler:^{

            PostCollectionViewCell *cell = (PostCollectionViewCell*)[postCollView cellForItemAtIndexPath:indexPath];

            // Display the newly loaded image
            cell.backgroundColor = [UIColor greenColor];
            cell.mainImg.backgroundColor = [UIColor redColor];
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
        NSArray *visiblePaths = [postCollView indexPathsForVisibleItems];
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

# pragma mark scrollView delegate methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self loadImagesForOnscreenRows];

    //got to the bottom. Paginate
    if (scrollView.contentOffset.y+scrollView.frame.size.height == scrollView.contentSize.height) {
    NSLog(@"sss");
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

#pragma mark textField delegate methods

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [hashtagTableView reloadData];
    [self replaceConstraintOnView:self.searchContainer withConstant:182.0 andAttribute:NSLayoutAttributeHeight onSelf:YES];
    [self animateConstraintsWithDuration:0.3 delay:0.0 andCompletionHandler:nil];
//    postCollView.userInteractionEnabled=NO;
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         hashtagTextFieldView.frame=CGRectMake(hashtagTextFieldView.frame.origin.x, hashtagTextFieldView.frame.origin.y, hashtagTextFieldView.frame.size.width, hashtagTextFieldView.frame.size.height+44*3);
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self searchBtnPressed];
    [self closeTextField];
//    postCollView.userInteractionEnabled=YES;
    return YES;
}

-(void)closeTextField{ //split into this method so if you click outside you dont search
    [hashtagTextField resignFirstResponder];
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         hashtagTextFieldView.frame=CGRectMake(hashtagTextFieldView.frame.origin.x, hashtagTextFieldView.frame.origin.y, hashtagTextFieldView.frame.size.width, 50.0);
                     }
                     completion:^(BOOL finished){
                         
                     }];
//    [self replaceConstraintOnView:self.searchContainer withConstant:50.0 andAttribute:NSLayoutAttributeHeight onSelf:YES];
//    [self animateConstraintsWithDuration:0.3 delay:0.0 andCompletionHandler:nil];
}

#pragma mark tableView delegate methods

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
    hashtagTextField.text=[tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    [self textFieldShouldReturn:hashtagTextField];
    [self searchBtnPressed];
}

#pragma mark - adBanner methods

- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
    //    NSLog(@"%@", self.view.constraints);
    [super bannerViewDidLoadAd:banner];
    //<<<<<<< HEAD
    //    [self replaceConstraintOnView:postCollView withConstant:postCollView.frame.size.height-50 andAttribute:NSLayoutAttributeHeight onSelf:NO];
    //    [self animateConstraints];
    //=======
    //    [self replaceConstraintOnView:self.postCollView withConstant:self.postCollView.frame.size.height-50 andAttribute:NSLayoutAttributeHeight onSelf:NO];
    //    [self animateConstraintsWithDuration:0.3 delay:0.0 andCompletionHandler:nil];
    //>>>>>>> 7a0cebd571693bf4f317ae1fd9457b6423a208f9
}

//- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
//    [super bannerView:banner didFailToReceiveAdWithError:error];
//    [self replaceConstraintOnView:self.postCollView withConstant:self.postCollView.frame.size.height+50 andAttribute:NSLayoutAttributeHeight onSelf:YES];
//    [self animateConstraints];
//}

@end