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
    _currentSectionDict = currentSectionDict;
    
    [self configureView];
}

- (void)configureView {
    NSMutableString *detailString = [NSMutableString new];
    for (NSString *key in self.currentSectionDict) {
        if (![key isEqualToString:@"AASection"] &&
            ![key isEqualToString:@"Image"] &&
            ![key isEqualToString:[self.currentSectionDict objectForKey:@"AASection"]]) {
            [detailString appendString:[NSString stringWithFormat:@"%@: %@ \n\n", key, [self.currentSectionDict objectForKey:key]]];
        }else if ([key isEqualToString:@"Image"]){
            self.mainImgView.image = [UIImage imageNamed:[self.currentSectionDict objectForKey:key]];
        }
    }
    self.detailTextView.text = detailString;
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
