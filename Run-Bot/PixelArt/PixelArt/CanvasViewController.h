//
//  CanvasViewController.h
//  PixelArt
//
//  Created by Oliver Rodden on 26/02/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CanvasViewController : UIViewController <UIScrollViewDelegate>{
    NSMutableArray *pixels;
}

@property (weak, nonatomic) IBOutlet UIScrollView *pixelScrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollSubView;
@property (nonatomic) UIColor *currentColour;

@property (weak, nonatomic) IBOutlet UIView *colourPickerView;
@property (weak, nonatomic) IBOutlet UIView *colourView;
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UISlider *alphaSlider;
@property (weak, nonatomic) IBOutlet UILabel *redLbl;
@property (weak, nonatomic) IBOutlet UILabel *greenLbl;
@property (weak, nonatomic) IBOutlet UILabel *blueLbl;
@property (weak, nonatomic) IBOutlet UILabel *alphaLbl;

-(IBAction)sliderMoved:(id)sender;

@end
