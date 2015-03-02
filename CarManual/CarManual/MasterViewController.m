//
//  MasterViewController.m
//  CarManual
//
//  Created by Oliver Rodden on 02/03/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController (){
    UITapGestureRecognizer *doubleTap;
}

@property NSMutableArray *objects;

@property NSDictionary *currentSectionDict;
@property NSMutableArray *currentSectionSubSections;

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.  
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"StandardCell"];
    
    if (self.currentSectionDict == nil) {
        NSString* path = [[NSBundle mainBundle] pathForResource:@"CorradoJSON" ofType:@"txt"];//Create file path
        NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];//Get content of file
        NSData* data = [content dataUsingEncoding:NSUTF8StringEncoding];//Encode to data
        NSDictionary *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];//Put data in dictionary
        
        self.currentSectionDict = jsonDictionary;
        
//        [self.detailViewController setCurrentSectionDict:self.currentSectionDict];
    }
    
    [self setTitle:[self.currentSectionDict objectForKey:@"AASection"]];
    
    self.currentSectionSubSections = [NSMutableArray new];
    for (NSDictionary *dict in [self.currentSectionDict objectForKey:[self.currentSectionDict objectForKey:@"AASection"]]) {
        [self.currentSectionSubSections addObject:[dict objectForKey:@"AASection"]];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    [[(MasterViewController*)[self.navigationController.viewControllers objectAtIndex:0] detailViewController] setCurrentSectionDict:self.currentSectionDict];
    
    doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapped)];
    doubleTap.numberOfTapsRequired = 2;
    [self.navigationController.navigationBar addGestureRecognizer:doubleTap];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar removeGestureRecognizer:doubleTap];
}

-(void)doubleTapped{
    [self performSegueWithIdentifier:@"showD" sender:self.currentSectionDict];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showD"]) {
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setCurrentSectionDict:sender];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.currentSectionSubSections count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;

    if (indexPath.section == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"StandardCell" forIndexPath:indexPath];
        
        // Configure the cell...
        cell.textLabel.text = [self.currentSectionSubSections objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.tableView.rowHeight = 44;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dictToSend = [[self.currentSectionDict objectForKey:[self.currentSectionDict objectForKey:@"AASection"]]objectAtIndex:indexPath.row];

    if ([dictToSend objectForKey:[dictToSend objectForKey:@"AASection"]] == nil) {
        [self performSegueWithIdentifier:@"showD" sender:dictToSend];
    }else{
        UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MasterViewController *newMVC = [mystoryboard instantiateViewControllerWithIdentifier:@"Master"];
        [newMVC setCurrentSectionDict:dictToSend];
        newMVC.view.tag = [self.navigationController.viewControllers count];
//        [self.detailViewController setCurrentSectionDict:dictToSend];
        [self.navigationController pushViewController:newMVC animated:YES];
    }
}

@end
