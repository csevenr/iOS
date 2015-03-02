//
//  DetailViewController.m
//  CarManual
//
//  Created by Oliver Rodden on 02/03/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

-(void)setCurrentSectionDict:(NSDictionary *)currentSectionDict{
    NSLog(@"dictionary set");
//    if (_currentSectionDict != currentSectionDict) {
        _currentSectionDict = currentSectionDict;
        
        // Update the view.
        [self configureView];
//    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    NSLog(@"%@", [self.currentSectionDict objectForKey:@"AASection"]);
    self.detailDescriptionLabel.text = [NSString stringWithFormat:@"Data: %@", [self.currentSectionDict objectForKey:@"Data"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
