//
//  ViewController.m
//  AppSketch
//
//  Created by Oliver Rodden on 12/01/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "ViewController.h"
#import "EditableView.h"

@interface ViewController (){
    EditableView *currentView;
    
    BOOL isPlacingNewView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *newView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(createNewView:)];
    newView.numberOfTapsRequired = 3;
    [self.view addGestureRecognizer:newView];
    
    isPlacingNewView = NO;
}

-(void)createNewView:(UITapGestureRecognizer*)gest{
    CGPoint location = [gest locationInView:self.view];
    EditableView *testView = [[EditableView alloc]initWithFrame:CGRectMake(0.0, 0.0, 100.0, 100.0)];
    testView.center = CGPointMake(location.x, location.y);
    testView.layer.borderWidth = 1.0;
    testView.layer.borderColor = [[UIColor blueColor] CGColor];
    [self.view addSubview:testView];
    
    currentView = testView;
    isPlacingNewView = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self.view];
    
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self.view];
    
    if (isPlacingNewView){
        currentView.center = CGPointMake(location.x, location.y);
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (isPlacingNewView == YES) {
        currentView.layer.borderColor = [[UIColor blackColor] CGColor];
        currentView = nil;
    }
}

@end
