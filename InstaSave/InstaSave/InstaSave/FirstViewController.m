//
//  FirstViewController.m
//  tabbed
//
//  Created by Oliver Rodden on 02/02/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "FirstViewController.h"
#import "PictureBlockViewController.h"
#import "CoreDataManager.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    searchTerm=@"corrado";
    
    titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 20.0, 320.0, 40.0)];
    titleLbl.backgroundColor = [UIColor whiteColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont systemFontOfSize:34.0];
    titleLbl.text=searchTerm;
    [self.view addSubview:titleLbl];
   
    //GESTURE RECOGNISER
    /*UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchTermTappped)];
    tap.numberOfTapsRequired=2;
    [titleLbl addGestureRecognizer:tap];
    titleLbl.userInteractionEnabled = YES;*/
    
    picBlocks = [NSMutableArray new];
    
    UIScrollView *picScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 60.0, 320.0, 498.0)];
    UIView *scrollSubView = [UIView new];
    picScrollView.delaysContentTouches = NO;
    

    [picScrollView addSubview:scrollSubView];
    
    for (int i=0; i<10; i++) {
        PictureBlockViewController *pictureBlock = [[PictureBlockViewController alloc]initWithNibName:nil bundle:nil andParentViewController:self];
        pictureBlock.view.frame=CGRectMake(0.0, 390.0*i+20, 320.0, 356.0);
        [pictureBlock setIdNo:i];
        [scrollSubView addSubview:pictureBlock.view];
        [picBlocks addObject:pictureBlock];
    }
    
    picScrollView.contentSize=CGSizeMake(320.0, 3960.0);
    scrollSubView.frame=CGRectMake(0.0, 0.0, 320.0, 3960.0);
    [self.view addSubview:picScrollView];
    
    [self getTenPictures];
}

-(void)searchTermTappped{
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0.0, 20.0, 320.0, 40.0)];
    textField.backgroundColor = [UIColor whiteColor];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.font = [UIFont systemFontOfSize:34.0];
    textField.returnKeyType = UIReturnKeyGo;
    textField.delegate=self;
    [self.view addSubview:textField];
    [textField becomeFirstResponder];
}

-(void)pictureBlockTapped:(PictureBlockViewController*)picBlock{
    toSave=picBlock;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save for later",@"Save to device", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%d",buttonIndex);
    if (buttonIndex==1) {//save for later
//        CoreDataManager *CDManager = [CoreDataManager new];
        [CoreDataManager addNewData:toSave.picData withMediaCredit:toSave.picMediaCredit title:toSave.picTitle andPubDate:toSave.picPubDate];
    }else if (buttonIndex==2){//save to device
        UIImage *tmp = [UIImage imageWithData:toSave.picData];
        UIImageWriteToSavedPhotosAlbum(tmp, nil, nil, nil);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text!=nil) {
        searchTerm = textField.text;
        titleLbl.text=searchTerm;
        [textField resignFirstResponder];
        [textField removeFromSuperview];
        [self getTenPictures];
        return NO;
    }
    return NO;
}

-(void)getTenPictures{
    parser = [[XMLParser alloc]initWithViewController:self];
    [parser performSelectorInBackground:@selector(parseXML:) withObject:[NSURL URLWithString:[NSString stringWithFormat:@"http://instagram.com/tags/%@/feed/recent.rss",searchTerm]]];
}

-(void)updateCells{
    for (int i=0; i<10; i++) {
        PictureBlockViewController *picBlock = [picBlocks objectAtIndex:i];
//        PictureBlockViewController *tmp = [[parser pictureBlocks]objectAtIndex:i];
//        NSLog(@"%@",[[[parser pictureBlocks]objectAtIndex:i] picTitle]);
        [picBlock updateWithName:[[[parser pictureBlocks]objectAtIndex:i] picMediaCredit] title:[[[parser pictureBlocks]objectAtIndex:i] picTitle] andUrl:[[[parser pictureBlocks]objectAtIndex:i] picLink]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
