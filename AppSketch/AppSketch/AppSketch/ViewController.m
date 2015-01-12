//
//  ViewController.m
//  AppSketch
//
//  Created by Oliver Rodden on 12/01/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "ViewController.h"
#import "EditableView.h"
#import "TouchDownTapGestureRecognizer.h"

@interface ViewController (){
    EditableView *currentView;
    
    CGPoint oldLocation1;
    CGPoint oldLocation2;
    
    BOOL isPlacingNewView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    TouchDownTapGestureRecognizer *newView = [[TouchDownTapGestureRecognizer alloc]initWithTarget:self action:@selector(createNewView:) secondeAction:@selector(createNewView:)];//pass another selector
    newView.numberOfTapsRequired = 3;
    [self.view addGestureRecognizer:newView];
    
    isPlacingNewView = NO;
}

-(void)createNewView:(TouchDownTapGestureRecognizer*)gest{
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
//    NSLog(@"BEGAN");
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self.view];
}

//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSArray *touchArray = [[event allTouches] allObjects];
//    
//    UITouch *touch1 = [touchArray objectAtIndex:[touchArray count]-1];// [[event allTouches] anyObject];
//    CGPoint location1 = [touch1 locationInView:self.view];
//
//    
//    UITouch *touch2;
//    CGPoint location2;
//    CGFloat distance;
//    if ([touchArray count] > 1) {
//        touch2 = [touchArray objectAtIndex:0];
//        location2 = [touch2 locationInView:self.view];
//        
//        CGFloat xDist = ((location2.x - oldLocation2.x) - (location1.x - oldLocation1.x));
//        CGFloat yDist = ((location2.y - oldLocation2.y) - (location1.y - oldLocation1.y));
//        distance = sqrt((xDist * xDist) + (yDist * yDist));
//        
//        currentView.frame = CGRectMake(currentView.frame.origin.x, currentView.frame.origin.y, currentView.frame.size.width - xDist, currentView.frame.size.height - yDist);
//        NSLog(@"%f, %f", currentView.frame.origin.x, currentView.frame.origin.y);
////        NSLog(@"%f, %f, %f, %f", location1.x ,location1.y, location2.x ,location2.y);
////        NSLog(@"%f", distance);
////        NSLog(@"%f, %f", xDist, yDist);
////        NSLog(@"%f, %f", currentView.frame.size.width, currentView.frame.size.height);
//        oldLocation1 = location1;
//        oldLocation2 = location2;
//    }
//    
//    
//    if (isPlacingNewView){
//        currentView.center = CGPointMake(location1.x, location1.y);
//    }
//}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self.view];

    if (isPlacingNewView){
        currentView.center = CGPointMake(location.x, location.y);
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (isPlacingNewView == YES) {
        currentView.editable = NO;
        currentView = nil;
    }
}

@end
