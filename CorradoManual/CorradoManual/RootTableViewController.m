//
//  RootTableViewController.m
//  CorradoManual
//
//  Created by Oliver Rodden on 26/02/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "RootTableViewController.h"

@interface RootTableViewController ()

@property NSMutableArray *currentSectionDict;
@property NSMutableArray *currentSectionSubSections;

@end

@implementation RootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Standard Cell"];
    
    if (self.currentSectionDict == nil) {
        NSString* path = [[NSBundle mainBundle] pathForResource:@"JSON" ofType:@"txt"];//Create file path
        NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];//Get content of file
        NSData* data = [content dataUsingEncoding:NSUTF8StringEncoding];//Encode to data
        NSDictionary *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];//Put data in dictionary
        //NSLog(@"JSON DICTIONARY: %@", jsonDictionary);
        
        self.currentSectionDict = [jsonDictionary objectForKey:[jsonDictionary objectForKey:@"AASection"]];
        //NSLog(@"CURRENT SECTION DICTIONARY: %@", self.currentSectionDict);
    }
        
    self.currentSectionSubSections = [NSMutableArray new];
    for (NSDictionary *dict in self.currentSectionDict) {
        [self.currentSectionSubSections addObject:[dict objectForKey:@"AASection"]];
        //NSLog(@"HIGH LEVEL SECTION: %@", [dict objectForKey:@"AASection"]);
    }
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
    //NSLog(@"%lu",(unsigned long)[self.currentSectionSubSections count]);
    return [self.currentSectionSubSections count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Standard Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self.currentSectionSubSections objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RootTableViewController *newTVC = [RootTableViewController new];
    NSLog(@"!!%@", self.currentSectionDict);
    [newTVC setCurrentSectionDict:[[self.currentSectionDict objectAtIndex:indexPath.row] objectForKey:(UITableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath].textLabel.text]];
    [self.navigationController pushViewController:newTVC animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
