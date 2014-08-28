//
//  ViewController.m
//  mindSphere
//
//  Created by Oliver Rodden on 22/11/2013.
//  Copyright (c) 2013 Oliver Rodden. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "EasyScene.h"
#import "MediumScene.h"
#import "HardScene.h"

@interface ViewController(){
    SKView *skView;
    SKScene *scene;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

-(IBAction)buttonPressed:(id)sender{
    if ([sender tag]>=1&&[sender tag]<=3) {
        if (skView==nil){
            skView = [[SKView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
        }
        [self.view addSubview:skView];
        if ([sender tag]==1){
            scene = [[EasyScene alloc]initWithSize:skView.bounds.size viewController:self];
        }else if ([sender tag]==2){
            scene = [[MediumScene alloc]initWithSize:skView.bounds.size];
        }else if ([sender tag]==3){
            scene = [[HardScene alloc]initWithSize:skView.bounds.size];
        }
        [skView presentScene:scene];
    }
}

-(void)removeCurrentScene{
    [skView removeFromSuperview];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
