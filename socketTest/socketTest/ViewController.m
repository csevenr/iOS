//
//  ViewController.m
//  socketTest
//
//  Created by Oliver Rodden on 06/03/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "ViewController.h"
#import "AsyncUdpSocket.h"

@interface ViewController (){
    AsyncUdpSocket *udpSocket ; // create this first part as a global variable
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    udpSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];// initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSData *data = [[NSString stringWithFormat:@"Hello Wold"] dataUsingEncoding:NSUTF8StringEncoding];
    
    [udpSocket sendData:data toHost:@"192.168.21.210" port:5005 withTimeout:-1 tag:1];

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (newString == nil) {
        newString = @"\t®";
    }
    
    NSData *data = [newString dataUsingEncoding:NSUTF8StringEncoding];
    
    [udpSocket sendData:data toHost:@"192.168.21.115" port:5005 withTimeout:-1 tag:1];
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
