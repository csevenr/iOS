//
//  ManualViewController.m
//  GramManager
//
//  Created by Oli Rodden on 26/09/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "ManualViewController.h"
#import "Post.h"
#import "PostTableViewCell.h"

@interface ManualViewController (){
    NSMutableArray *posts;
}

@end

@implementation ManualViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipedRight)];//check if already there
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:right];
    
    posts = [NSMutableArray new];
}

- (IBAction)searchBtnPressed:(id)sender {
    [self getJSON];
}

-(void)swipedRight{
    [self.delegate getRidMan];
}

-(void)getJSON{
    if (![self.hashtagTextField.text isEqualToString:@""]) {
        [[Insta sharedInstance] getJsonForHashtag:self.hashtagTextField.text];
        [[Insta sharedInstance] setDelegate:self];
    }
}

-(void)JSONReceived:(NSDictionary *)JSONDictionary{
//    NSLog(@"%@",JSONDictionary);
    for (NSDictionary *postDict in [JSONDictionary objectForKey:@"data"]) {
        Post *post = [[Post alloc]initWithDictionary:postDict];
        [posts addObject:post];
    }
    [self.postTableView reloadData];
}



#pragma Mark tableView methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil){
        cell = [[PostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }

    cell.post = [posts objectAtIndex:indexPath.row];

//    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[posts objectAtIndex:indexPath.row] userName]];
    return cell;
}

@end
