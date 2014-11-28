//
//  ViewController.m
//  collviewtest
//
//  Created by Oliver Rodden on 28/11/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "ViewController.h"
#import "FloatingHeaderViewFlowLayout.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UICollectionView *collView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:[[FloatingHeaderViewFlowLayout alloc] init]];
    collView.delegate = self;
    collView.dataSource = self;
    collView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collView];
    
    [collView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"postCell"];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    PostCollectionViewCell *cell = nil;
    
//    NSUInteger nodeCount = [posts count];
    
    static NSString *MyIdentifier = @"postCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MyIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor redColor];
    
    return cell;
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
        return 10;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(200.0, 200.0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(200.0, 20.0);
    }else{
        return CGSizeMake(200.0, 120.0);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%d", indexPath.section);
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)];
        v.backgroundColor = [UIColor blackColor];
        [headerView addSubview:v];
        
        headerView.backgroundColor = [UIColor greenColor];
        
        reusableview = headerView;
    }
    return reusableview;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end