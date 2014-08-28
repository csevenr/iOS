//
//  ViewController.h
//  PictureAMinute
//
//  Created by Oliver Rodden on 16/12/2013.
//  Copyright (c) 2013 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVCaptureSession.h>
#import "AppDelegate.h"

@interface ViewController : UIViewController{
    AppDelegate *appDel;
    AVCaptureStillImageOutput *stillImageOutput;
    AVCaptureSession *session;
    NSMutableArray *pictures;
}

@property (weak, nonatomic) IBOutlet UIImageView *photoView;

-(IBAction)buttonPressed:(id)sender;
-(void)savePic:(id)sender;

@end
