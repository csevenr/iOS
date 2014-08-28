//
//  CanvasViewController.m
//  PixelArt
//
//  Created by Oliver Rodden on 26/02/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "CanvasViewController.h"
#import "Pixel.h"

@interface CanvasViewController (){
//    UIView *scrollSubView;
}

@end

@implementation CanvasViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _currentColour = [UIColor redColor];
    
    [_pixelScrollView addSubview:_scrollSubView];
    _pixelScrollView.contentSize = _scrollSubView.frame.size;
    _pixelScrollView.delegate=self;
    _pixelScrollView.minimumZoomScale=1.0;
    _pixelScrollView.maximumZoomScale=3.0;
    
    pixels = [NSMutableArray new];
    
    for (int i=0; i<700; i++) {
        Pixel *pixel = [[Pixel alloc]initWithCanvas:self];
        CGRect frame;
        frame = CGRectMake(((i+20)%20)*16.0, (i/20)*16.0, 16.0, 16.0);
        pixel.frame=frame;
        [_scrollSubView addSubview:pixel];
        [pixels addObject:pixel];
    }
    
    _colourPickerView.clipsToBounds=YES;
    _colourPickerView.layer.cornerRadius=10.0;
//    _colourPickerView.layer.shadowOffset = CGSizeMake(0.0, -9.0);
//    _colourPickerView.layer.shadowRadius = 1.0;
//    _colourPickerView.layer.shadowColor = [UIColor blackColor].CGColor;
//    _colourPickerView.layer.shadowOpacity = 1.0;
    _colourPickerView.layer.borderColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7].CGColor;
    _colourPickerView.layer.borderWidth = 2.0;
    _colourView.clipsToBounds=YES;
    _colourView.layer.cornerRadius=8.0;
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipedUp)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    swipeUp.numberOfTouchesRequired=2;
    [self.view addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipedLeft)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeLeft.numberOfTouchesRequired=2;
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipedDown)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    swipeDown.numberOfTouchesRequired=2;
    [self.view addGestureRecognizer:swipeDown];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipedRight)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRight.numberOfTouchesRequired=2;
    [self.view addGestureRecognizer:swipeRight];
}

#pragma mark colourPicker methods

-(IBAction)sliderMoved:(id)sender{
    _currentColour=[UIColor colorWithRed:_redSlider.value green:_greenSlider.value blue:_blueSlider.value alpha:_alphaSlider.value];
    [_colourView setBackgroundColor:_currentColour];
}

-(void)swipedUp{
    /*if (_colourPickerView.frame.origin.y==self.view.frame.size.height) {
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             _colourPickerView.frame=CGRectMake(5.0, 248.0, _colourPickerView.frame.size.width, _colourPickerView.frame.size.height);
                         }
                         completion:^(BOOL finished){
                         }];
    }*/
    _colourPickerView.frame=CGRectMake(5.0, 248.0, _colourPickerView.frame.size.width, _colourPickerView.frame.size.height);
    
}

-(void)swipedDown{
    if (_colourPickerView.frame.origin.y!=self.view.frame.size.height) {
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             _colourPickerView.frame=CGRectMake(5.0, self.view.frame.size.height, _colourPickerView.frame.size.width, _colourPickerView.frame.size.height);
                         }
                         completion:^(BOOL finished){
                         }];
    }
}

#pragma mark menu methods

-(void)swipedLeft{
    
}

-(void)swipedRight{
    
}


-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _scrollSubView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
