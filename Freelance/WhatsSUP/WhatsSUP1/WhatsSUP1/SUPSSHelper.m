//
//  SUPSSHelper.m
//
//  Created by Tamas Lustyik on 2012.01.09..
//  Copyright (c) 2012 LKXF. All rights reserved.
//

#import "SUPSSHelper.h"


static const CGRect kDefaultViewRect = {{0,0},{160,30}};
static const CGFloat kMinimumWidth = 100.0f;
static const UIEdgeInsets kDefaultPadding = {10,10,10,10};


@interface SUPSSHelper ()
{
    MKMapView* mapView;
    UILabel* zeroLabel;
    UILabel* maxLabel;
    UILabel* unitLabel;
    CGFloat scaleWidth;
}

- (id)initWithMapView:(MKMapView*)aMapView;
- (void)constructLabels;

@end



@implementation SUPSSHelper

@synthesize metric;
@synthesize padding;
@synthesize maxWidth;


// -----------------------------------------------------------------------------
// SUPSSHelper::mapScaleForMapView:
// -----------------------------------------------------------------------------
+ (SUPSSHelper*)mapScaleForMapView:(MKMapView*)aMapView
{
    if ( !aMapView )
    {
        return nil;
    }
    
    for ( UIView* subview in aMapView.subviews )
    {
        if ( [subview isKindOfClass:[SUPSSHelper class]] )
        {
            return (SUPSSHelper*)subview;
        }
    }
    
    return [[SUPSSHelper alloc] initWithMapView:aMapView];
}


// -----------------------------------------------------------------------------
// SUPSSHelper::initWithMapView:
// -----------------------------------------------------------------------------
- (id)initWithMapView:(MKMapView*)aMapView
{
    if ( (self = [super initWithFrame:kDefaultViewRect]) )
    {
        self.opaque = NO;
        self.clipsToBounds = YES;
        self.userInteractionEnabled = NO;
        
        mapView = aMapView;
        metric = 0; // 0=km, 1=mile, 2=nmile
        padding = kDefaultPadding;
        maxWidth = kDefaultViewRect.size.width;
        
        [self constructLabels];
        
        [aMapView addSubview:self];
    }
    
    return self;
}


// -----------------------------------------------------------------------------
// SUPSSHelper::constructLabels
// -----------------------------------------------------------------------------
- (void)constructLabels
{
    UIFont* font = [UIFont systemFontOfSize:12.0f];
    zeroLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 8, 10)];
    zeroLabel.backgroundColor = [UIColor clearColor];
    zeroLabel.textColor = [UIColor whiteColor];
    zeroLabel.shadowColor = [UIColor blackColor];
    zeroLabel.shadowOffset = CGSizeMake(1, 1);
    zeroLabel.text = @"0";
    zeroLabel.font = font;
    [self addSubview:zeroLabel];
    //[zeroLabel release];
    
    maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 10, 10)];
    maxLabel.backgroundColor = [UIColor clearColor];
    maxLabel.textColor = [UIColor whiteColor];
    maxLabel.shadowColor = [UIColor blackColor];
    maxLabel.shadowOffset = CGSizeMake(1, 1);
    maxLabel.text = @"1";
    maxLabel.font = font;
    maxLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:maxLabel];
    //[maxLabel release];
    
    unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 18, 10)];
    unitLabel.backgroundColor = [UIColor clearColor];
    unitLabel.textColor = [UIColor whiteColor];
    unitLabel.shadowColor = [UIColor blackColor];
    unitLabel.shadowOffset = CGSizeMake(1, 1);
    unitLabel.text = @"m";
    unitLabel.font = font;
    [self addSubview:unitLabel];
    //[unitLabel release];
}


// -----------------------------------------------------------------------------
// SUPSSHelper::update
// -----------------------------------------------------------------------------
- (int)update
{
    if ( !mapView || !mapView.bounds.size.width )
    {
        return -1;
    }
    
    int retVal=-1;
    
    CLLocationDistance horizontalDistance = MKMetersPerMapPointAtLatitude(mapView.centerCoordinate.latitude);
    float metersPerPixel = mapView.visibleMapRect.size.width * horizontalDistance / mapView.bounds.size.width;
    
    CGFloat maxScaleWidth = maxWidth-40;
    
    NSUInteger maxValue = 0;
    NSString* unit = @"";
    
   
    float meters = maxScaleWidth*metersPerPixel;
    
    if ( meters > 2000.0f )
    {
        // use kilometer scale
        unit = @"km";
        static const NSUInteger kKilometerScale[] = {1,2,5,10,20,50,100,200,500,1000,2000,5000,10000,20000,50000};
        float kilometers = meters / 1000.0f;
        int i=0;
        for ( ; i < 15; ++i )
        {
            if ( kilometers < kKilometerScale[i] )
            {
                scaleWidth = maxScaleWidth * kKilometerScale[i-1]/kilometers;
                maxValue = kKilometerScale[i-1];
                break;
            }
        }
        retVal=i*1000;
    }
    else
    {
        // use meter scale
        unit = @"m";
        static const NSUInteger kMeterScale[11] = {1,2,5,10,20,50,100,200,500,1000,2000};
        int i = 0;
        for ( ; i < 11; ++i )
        {
            if ( meters < kMeterScale[i] )
            {
                scaleWidth = maxScaleWidth * kMeterScale[i-1]/meters;
                maxValue = kMeterScale[i-1];
                break;
            }
        }
        retVal=i;
    }
    NSLog(@"Meters Per Pixel %f Scale Level %d",meters, retVal);

    
    return retVal;
}


// -----------------------------------------------------------------------------
// SUPSSHelper::setFrame:
// -----------------------------------------------------------------------------
- (void)setFrame:(CGRect)aFrame
{
    [self setMaxWidth:aFrame.size.width];
}


// -----------------------------------------------------------------------------
// SUPSSHelper::setBounds:
// -----------------------------------------------------------------------------
- (void)setBounds:(CGRect)aBounds
{
    [self setMaxWidth:aBounds.size.width];
}


// -----------------------------------------------------------------------------
// SUPSSHelper::setMaxWidth:
// -----------------------------------------------------------------------------
- (void)setMaxWidth:(CGFloat)aMaxWidth
{
    if ( maxWidth != aMaxWidth && aMaxWidth >= kMinimumWidth )
    {
        maxWidth = aMaxWidth;
        
        [self setNeedsLayout];
    }
}


// -----------------------------------------------------------------------------
// SUPSSHelper::setAlpha:
// -----------------------------------------------------------------------------
- (void)setAlpha:(CGFloat)aAlpha
{
    [super setAlpha:aAlpha];
    zeroLabel.alpha = aAlpha;
    maxLabel.alpha = aAlpha;
    unitLabel.alpha = aAlpha;
}



// -----------------------------------------------------------------------------
// SUPSSHelper::setMetric:
// -----------------------------------------------------------------------------
- (void)setMetric:(int)aIsMetric
{
    if ( metric != aIsMetric )
    {
        metric = aIsMetric;
        
        [self update];
    }
}





@end
