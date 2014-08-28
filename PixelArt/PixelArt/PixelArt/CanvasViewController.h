//
//  ViewController.h
//  touch test
//
//  Created by Oliver Rodden on 26/08/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CanvasDelegate <NSObject>

-(void)canvasExitBtnPressed;

@end

@interface CanvasViewController : UIViewController

@property id delegate;

@property UIColor *currentColour;
@property int pixelSize;

@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *colourPickerView;

@property (weak, nonatomic) IBOutlet UIView *currentColourView;

@property (weak, nonatomic) IBOutlet UISlider *rSlider;
@property (weak, nonatomic) IBOutlet UISlider *gSlider;
@property (weak, nonatomic) IBOutlet UISlider *bSlider;
@property (weak, nonatomic) IBOutlet UISlider *aSlider;

@property (weak, nonatomic) IBOutlet UIButton *blackBtn;
@property (weak, nonatomic) IBOutlet UIButton *blueBtn;
@property (weak, nonatomic) IBOutlet UIButton *redBtn;
@property (weak, nonatomic) IBOutlet UIButton *yellowBtn;
@property (weak, nonatomic) IBOutlet UIButton *greenBtn;

- (IBAction)menuBtnPressed:(UIButton*)sender;
- (IBAction)colourBtnPressed:(UIButton*)sender;
- (IBAction)colourSliderValueChanged:(UISlider *)sender;

@end
