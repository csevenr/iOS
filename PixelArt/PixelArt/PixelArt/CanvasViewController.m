//
//  ViewController.m
//  touch test
//
//  Created by Oliver Rodden on 26/08/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "CanvasViewController.h"
#import "Pixel.h"

@interface CanvasViewController (){
    NSMutableArray *pixels;
    BOOL menuIsShowing;
    
    int columns;
    int rows;
}

@end

typedef enum {
    kGridBtn, kFillBtn, kEraseBtn, kSaveBtn, kShareBtn, kExitBtn
} btnType;

@implementation CanvasViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipedUp)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    swipeUp.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipedDown)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    swipeDown.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:swipeDown];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipedRight)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRight.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:swipeRight];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipedLeft)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeLeft.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:swipeLeft];

    [self setUpView:_menuView];
    [self setUpView:_colourPickerView];
    [self setUpView:_currentColourView];
    
    [self setupPixels];
    
    [self.view bringSubviewToFront:_menuView];
    [self.view bringSubviewToFront:_colourPickerView];
    
    _currentColour=[UIColor whiteColor];
}

-(void)setupPixels{
//    pixelSize=64;//8, 10, 16, 32, 64
    columns = self.view.frame.size.width/_pixelSize;
    rows = (int)self.view.frame.size.height/_pixelSize;
    pixels = [NSMutableArray new];

    for (int a=0; a<columns*(rows+1); a++) {
        Pixel *px = [Pixel new];
        px.frame = CGRectMake(_pixelSize*(a%columns), ((int)a/columns)*_pixelSize, _pixelSize, _pixelSize);
        [self.view addSubview:px];
        [pixels addObject:px];
    }
}

-(void)setUpView:(UIView*)view{
    view.layer.borderColor=[UIColor darkGrayColor].CGColor;
    view.layer.borderWidth=1.6;
    view.layer.cornerRadius = 16.0;
    view.layer.masksToBounds = YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self handleTouches:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [self handleTouches:touches withEvent:event];
}

-(void)handleTouches:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!menuIsShowing) {
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint location = [touch locationInView:self.view];
        
        if ([[event allTouches]count]==1) {
            NSInteger column = floorf(columns * location.x / self.view.bounds.size.width);
            NSInteger row = floorf(rows * location.y / self.view.bounds.size.height);
            
            [[pixels objectAtIndex:column + columns*row] changeColor:_currentColour];
        }
    }
}

#define SPEED 0.3

-(void)swipedUp{
    if (!menuIsShowing) {
        menuIsShowing = YES;
        [UIView animateWithDuration:SPEED
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.colourPickerView.frame = CGRectMake(self.colourPickerView.frame.origin.x, self.view.frame.size.height-self.colourPickerView.frame.size.height+20, self.colourPickerView.frame.size.width, self.colourPickerView.frame.size.height);
                         }
                         completion:^(BOOL finished){
                         }];
    }
}

-(void)swipedDown{
    [UIView animateWithDuration:SPEED
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.colourPickerView.frame = CGRectMake(self.colourPickerView.frame.origin.x, self.view.frame.size.height, self.colourPickerView.frame.size.width, self.colourPickerView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         menuIsShowing = NO;
                     }];
}

-(void)swipedLeft{
    if (!menuIsShowing) {
        menuIsShowing = YES;
        [UIView animateWithDuration:SPEED
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.menuView.frame = CGRectMake(self.view.frame.size.width-self.menuView.frame.size.width+20, self.menuView.frame.origin.y, self.menuView.frame.size.width, self.menuView.frame.size.height);
                         }
                         completion:^(BOOL finished){
                         }];
    }
}

-(void)swipedRight{
    [UIView animateWithDuration:SPEED
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.menuView.frame = CGRectMake(self.view.frame.size.width, self.menuView.frame.origin.y, self.menuView.frame.size.width, self.menuView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         menuIsShowing = NO;
                     }];
}

- (IBAction)menuBtnPressed:(UIButton*)sender {
    if ([sender tag]==kGridBtn) {
        [pixels makeObjectsPerformSelector:@selector(showHideGrid)];
    }else if ([sender tag]==kFillBtn) {
        [pixels makeObjectsPerformSelector:@selector(changeColor:) withObject:_currentColour];
    }else if ([sender tag]==kEraseBtn){
        [pixels makeObjectsPerformSelector:@selector(changeColor:) withObject:[UIColor clearColor]];
    }else if ([sender tag]==kSaveBtn){
        [self swipedRight];
        
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, [[UIScreen mainScreen] scale]);
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        [[UIColor clearColor] set];
        CGContextFillRect(ctx, self.view.frame);
        
        [self.view setOpaque:NO];
        [[self.view layer] setOpaque:NO];
        [self.view setBackgroundColor:[UIColor clearColor]];
        [[self.view layer] setBackgroundColor:[UIColor clearColor].CGColor];
        
        [[self.view layer] renderInContext:ctx];
        
        UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
        UIImageWriteToSavedPhotosAlbum(image1, nil, nil, nil);
    }else if ([sender tag]==kExitBtn){
        [self.delegate canvasExitBtnPressed];
    }
}

- (IBAction)colourBtnPressed:(UIButton*)sender {
    _currentColour = sender.backgroundColor;
    _currentColourView.backgroundColor = _currentColour;
    const CGFloat* components = CGColorGetComponents(_currentColour.CGColor);
    _rSlider.value = components[0];
    _gSlider.value = components[1];
    _bSlider.value = components[2];
    _aSlider.value = CGColorGetAlpha(_currentColour.CGColor);
}

- (IBAction)colourSliderValueChanged:(UISlider *)sender {
    _currentColour = [UIColor colorWithRed:_rSlider.value green:_gSlider.value blue:_bSlider.value alpha:_aSlider.value];
    _currentColourView.backgroundColor = _currentColour;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
