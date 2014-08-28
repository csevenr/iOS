//
//  MenuViewController.m
//  touch test
//
//  Created by Oliver Rodden on 27/08/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import "MenuViewController.h"
#import "CanvasViewController.h"

@interface MenuViewController (){
    int pixels;
    CanvasViewController *canvasVc;
}

@end

@implementation MenuViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)buttonPressed:(id)sender {
    pixels = [[sender titleLabel].text intValue];
    [self performSegueWithIdentifier:@"canvas" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    canvasVc = (CanvasViewController*)[segue destinationViewController];
    [canvasVc setDelegate:self];
    [canvasVc setPixelSize:pixels];

}

-(void)canvasExitBtnPressed{
    [canvasVc dismissViewControllerAnimated:YES completion:nil];
}

@end
