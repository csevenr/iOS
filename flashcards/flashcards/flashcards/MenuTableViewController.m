//
//  MenuTableViewController.m
//  flashcards
//
//  Created by Oliver Rodden on 05/05/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "MenuTableViewController.h"
#import "CardViewerViewController.h"

#import "ModelHelper.h"
#import "CardSet+Helper.h"

@interface MenuTableViewController (){
    NSMutableArray *cellTitles;
}

@end

@implementation MenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    cellTitles = [NSMutableArray new];
    cellTitles = [[CardSet getCardSetTitles] mutableCopy];
//    [cellTitles addObject:@"python"];//---
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [cellTitles count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CreateSetTableViewCell *cell;
    
    if ([[cellTitles objectAtIndex:[indexPath row]] isEqualToString:@"*new"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CreateSetCell" forIndexPath:indexPath];
        cell.delegate = self;
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"SetCell" forIndexPath:indexPath];
        cell.textLabel.text = [cellTitles objectAtIndex:[indexPath row]];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"showSet" sender:[cellTitles objectAtIndex:indexPath.row]];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[CardViewerViewController class]]) {
        [(CardViewerViewController *)[segue destinationViewController] setCurrentCardSet:[CardSet getCardSetWithName:sender]];
    }
}


- (IBAction)addBtnPressed:(id)sender {
    if (![[cellTitles firstObject] isEqualToString:@"*new"] ) {
        [cellTitles insertObject:@"*new" atIndex:0];
        [self.tableView reloadData];
    }
}

-(void)cellIsFinishedWithTitle:(NSString *)title{
    if ([[cellTitles firstObject] isEqualToString:@"*new"] ) {
        [cellTitles removeObjectAtIndex:0];
        [cellTitles insertObject:title atIndex:0];
        [self.tableView reloadData];
    }
    CardSet *newSet = [CardSet create];
    newSet.name = title;
    newSet.position = [NSNumber numberWithInt:(int)[cellTitles count]];
    
    [ModelHelper saveManagedObjectContext];
    
    [self performSegueWithIdentifier:@"showSet" sender:title];
}

@end
