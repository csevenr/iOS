//
//  EiiRMMapViewController.m
//  rssMap
//
//  Created by Oliver Rodden on 20/10/2013.
//  Copyright (c) 2013 Oliver Rodden. All rights reserved.
//

#import "EiiRMMapViewController.h"
#import "EiiRMAnnotation.h"
#import "EiiRMArticle.h"

@interface EiiRMMapViewController ()

@end

@implementation EiiRMMapViewController
@synthesize map;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        map = [[MKMapView alloc]initWithFrame:self.view.bounds];
        map.delegate=self;
        [self.view addSubview:map];
        
        for (int i=0; i<7; i++) {
            CLLocationCoordinate2D annotationCoord;
            
            annotationCoord.latitude = [[[[super articles]objectAtIndex:i] geolat] floatValue];
            annotationCoord.longitude = [[[[super articles]objectAtIndex:i] geolong] floatValue];
            
            MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
            annotationPoint.coordinate = annotationCoord;
            //        annotationPoint.title = @"Microsoft";
            //        annotationPoint.subtitle = @"Microsoft's headquarters";
            [map addAnnotation:annotationPoint];
        }
    }
    return self;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)vieww{
    NSLog(@"HERE");
}

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    EiiRMAnnotation *pinView = nil;
    if(annotation != map.userLocation){
        static NSString *defaultPinID = @"com.invasivecode.pin";
        pinView = (EiiRMAnnotation *)[map dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if (pinView == nil)pinView = [[EiiRMAnnotation alloc]initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        pinView.canShowCallout = YES;
        pinView.image = [UIImage imageNamed:@"annotation.png"];
        pinView.frame=CGRectMake(pinView.frame.origin.x, pinView.frame.origin.y, 54.0, 128.0);
    }else{
        [map.userLocation setTitle:@"I am here"];
    }
    return pinView;
//    return nil;
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

@end
