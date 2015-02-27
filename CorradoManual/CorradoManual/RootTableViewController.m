//
//  RootTableViewController.m
//  CorradoManual
//
//  Created by Oliver Rodden on 26/02/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "RootTableViewController.h"
#import "ViewController.h"

@interface RootTableViewController ()

@property NSDictionary *currentSectionDict;
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
        
        self.currentSectionDict = jsonDictionary;
        //NSLog(@"CURRENT SECTION DICTIONARY: %@", self.currentSectionDict);
    }
    //NSLog(@"CURRENT SECTION DICTIONARY: %@", self.currentSectionDict);
    
    [self setTitle:[self.currentSectionDict objectForKey:@"AASection"]];
    
    self.currentSectionSubSections = [NSMutableArray new];
    for (NSDictionary *dict in [self.currentSectionDict objectForKey:[self.currentSectionDict objectForKey:@"AASection"]]) {
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    //NSLog(@"%lu",(unsigned long)[self.currentSectionSubSections count]);
    if (section == 0) {
        return 1;
    }else{
        return [self.currentSectionSubSections count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor lightGrayColor];
        self.tableView.rowHeight = 200;
    }else if (indexPath.section == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Standard Cell" forIndexPath:indexPath];
        
        // Configure the cell...
        cell.textLabel.text = [self.currentSectionSubSections objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.tableView.rowHeight = 44;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"!!%@", self.currentSectionDict);
    NSDictionary *dictToSend = [[self.currentSectionDict objectForKey:[self.currentSectionDict objectForKey:@"AASection"]]objectAtIndex:indexPath.row];
    //NSLog(@"DICT TO SEND: %@", dictToSend);
    if ([dictToSend objectForKey:[dictToSend objectForKey:@"AASection"]] == nil) {
        ViewController *newVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
        [newVC setCurrentSectionDict:dictToSend];
        [self.navigationController pushViewController:newVC animated:YES];
    }else{
        RootTableViewController *newTVC = [RootTableViewController new];
        [newTVC setCurrentSectionDict:dictToSend];
        [self.navigationController pushViewController:newTVC animated:YES];
    }
}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 100.0, 100.0)];
//    headerView.backgroundColor = [UIColor yellowColor];
//    headerView.clipsToBounds = YES;
//    self.tableView.contentOffset = CGPointMake(0.0, 450.0);
//
//    return headerView;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    
//    return 400.0;
//}

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
