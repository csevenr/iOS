//
//  EiiRMMapViewController.h
//  rssMap
//
//  Created by Oliver Rodden on 20/10/2013.
//  Copyright (c) 2013 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "EiiRMRootViewController.h"


@interface EiiRMMapViewController : EiiRMRootViewController <MKMapViewDelegate>

@property (nonatomic,assign)MKMapView *map;

@end
