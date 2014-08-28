//
//  ViewController.m
//  PictureAMinute
//
//  Created by Oliver Rodden on 16/12/2013.
//  Copyright (c) 2013 Oliver Rodden. All rights reserved.
//

#import "ViewController.h"
#import "Scratchpad.h"
#import "PictureViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <ImageIO/CGImageProperties.h>

@interface ViewController (){
    PictureViewController *pv;
    NSTimer *photoTimer;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    appDel= (AppDelegate*)[[UIApplication sharedApplication]delegate];
    pictures = [[appDel scratchPad] objectForKey:PHOTOARRAY];
    NSLog(@"%lu",(unsigned long)[pictures count]);
    
    session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetMedium;
    
    AVCaptureDevice *device = [self frontFacingCameraIfAvailable];
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        // Handle the error appropriately.
        NSLog(@"ERROR: trying to open camera: %@", error);
    }
    [session addInput:input];
    
    //stillImageOutput is a global variable in .h file: "AVCaptureStillImageOutput *stillImageOutput;"
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOutput];
    
    [session startRunning];
    
    photoTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(takePhoto) userInfo:nil repeats:YES];
}

-(AVCaptureDevice *)frontFacingCameraIfAvailable{
    
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *captureDevice = nil;
    
    for (AVCaptureDevice *device in videoDevices){
        
        if (device.position == AVCaptureDevicePositionBack/*AVCaptureDevicePositionFront*/){
            
            captureDevice = device;
            break;
        }
    }
    
    //  couldn't find one on the front, so just get the default video device.
    if (!captureDevice){
        
        captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    return captureDevice;
}

-(void)takePhoto{
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections){
        for (AVCaptureInputPort *port in [connection inputPorts]){
            
            if ([[port mediaType] isEqual:AVMediaTypeVideo]){
                
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    
    NSLog(@"about to request a capture from: %@", stillImageOutput);
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error){
        
        CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
        if (exifAttachments){
            // Do something with the attachments if you want to.
            NSLog(@"attachements: %@", exifAttachments);
        }else NSLog(@"no attachments");
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
        [pictures addObject:imageData];
        [[appDel scratchPad]setObject:pictures forKey:PHOTOARRAY];
        [appDel saveNSMutableDictionary:[appDel scratchPad] forKey:PICTURESP];

        UIImage *image = [[UIImage alloc] initWithData:imageData];
        _photoView.image = image;
        
    }];
}

-(IBAction)buttonPressed:(id)sender{
    if ([sender tag]==0) {
        [pv.view removeFromSuperview];
        photoTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(takePhoto) userInfo:nil repeats:YES];
    }else if ([sender tag]==1){
        [photoTimer invalidate];
        if (pv==nil)pv = [PictureViewController new];
        [pv setVc:self];
        pv.view.frame=CGRectMake(0.0, 44.0, 320.0, 480.0);
        [self.view addSubview:pv.view];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
