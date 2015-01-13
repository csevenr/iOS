//
//  ViewController.m
//  AppSketch
//
//  Created by Oliver Rodden on 12/01/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "ViewController.h"
//#import "DetailsMenu.h"
//#import "EditableView.h"
#import "TouchDownTapGestureRecognizer.h"

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

@interface ViewController (){
    UIView *newView;
    
    EditableView *currentView;
    
    CGPoint oldLocation1;
    CGPoint oldLocation2;
    
    BOOL isPlacingNewView;
    
    DetailsMenu* detailsMenu;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *editSelf = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editSelf)];
    editSelf.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:editSelf];
    
    //Toolbar
    newView = [[UIView alloc]initWithFrame:CGRectMake(6.0, self.view.frame.size.height - 30.0, 60.0, 60.0)];
    newView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    newView.layer.borderWidth = 3.0;
    newView.layer.cornerRadius = 10.0;
    [self.view addSubview:newView];
        
    isPlacingNewView = NO;
}

-(void)editSelf{
    currentView = (EditableView*)self.view;
    [self showDetailsMenu];
}

-(EditableView *)createNewViewWithLocation:(CGPoint)location{
    currentView.editable = NO;
    
    EditableView *testView = [[EditableView alloc]initWithFrame:CGRectMake(0.0, 0.0, 100.0, 100.0)];
    testView.delegate = self;
    testView.center = CGPointMake(location.x, location.y);
    testView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    testView.layer.borderWidth = 3.0;
    testView.layer.cornerRadius = 10.0;
    testView.transform = CGAffineTransformMakeRotation(DegreesToRadians(10));
    [self.view addSubview:testView];
    
    return testView;
}

-(void)showDetailsMenu{
    if (detailsMenu == nil) {
        NSArray * allTheViewsInMyNIB = [[NSBundle mainBundle] loadNibNamed:@"DetailsMenu" owner:self options:nil]; // loading nib (might contain more than one view)
        detailsMenu = allTheViewsInMyNIB[0]; // getting desired view
        detailsMenu.delegate = self;
        detailsMenu.frame = CGRectMake(self.view.frame.size.width, 10.0, self.view.frame.size.width ,self.view.frame.size.height - 20.0); //setting the frame
        [self.view addSubview:detailsMenu];
    }
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         detailsMenu.frame = CGRectMake(10.0, 10.0, self.view.frame.size.width ,self.view.frame.size.height - 20.0);
                     }
                     completion:^(BOOL finished){
                     }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self.view];
    
    if (CGRectContainsPoint(newView.frame, location)) {
        currentView = [self createNewViewWithLocation:location];
        isPlacingNewView = YES;
    }
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
        currentView.transform = CGAffineTransformMakeRotation(DegreesToRadians(0));
        isPlacingNewView = NO;
    }
}

#pragma mark EditableView Delegate Methods

-(void)editableViewDeleteBtnPressed{
    [currentView removeFromSuperview];
    currentView = nil;
}

-(void)editableViewDetailsBtnPressed{
    [self showDetailsMenu];
}

-(void)editableViewShouldBecomeEditable:(EditableView*)v{
    currentView.editable = NO;
    currentView = v;
//    currentView.delegate = self;//+++ should do something about this
}

-(void)editableViewShouldBecomeUneditable{
//    currentView.delegate = nil;
    currentView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark DetailsMenu Delegate Methods

-(void)hideDetailsMenu{
    if (currentView == self.view) {
        currentView = nil;
    }
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         detailsMenu.frame = CGRectMake(self.view.frame.size.width, 10.0, self.view.frame.size.width ,self.view.frame.size.height - 20.0);
                     }
                     completion:^(BOOL finished){
                     }];
}

-(void)setCurrentViewBackgroundColour:(UIColor*)colour{
    currentView.backgroundColor = colour;
}

-(void)setCurrentViewTitleLabel:(NSString*)string{
    currentView.titleLabel.text = string;
}

@end
