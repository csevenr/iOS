//
//  ViewController.m
//  JSONValidator
//
//  Created by Oliver Rodden on 26/02/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"JSON" ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    NSLog(@"%@",path);
    NSData* data = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"__%@", jsonDictionary);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
