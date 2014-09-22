//
//  LXMapScaleView.m
//
//  Created by Tamas Lustyik on 2012.01.09..
//  Copyright (c) 2012 LKXF. All rights reserved.
//

#import "LXMapScaleView.h"


static const CGRect kDefaultViewRect = {{0,0},{160,30}};
static const CGFloat kMinimumWidth = 100.0f;
static const UIEdgeInsets kDefaultPadding = {10,10,10,10};

static const double kFeetPerMeter = 1.0/0.3048;
static const double kFeetPerMile = 5280.0;
static const double kFeetPerNMile = 6080.0;


@interface LXMapScaleView ()
{
    MKMapView* mapView;
    UILabel* zeroLabel;
    UILabel* maxLabel;
    UILabel* unitLabel;
    UILabel* spzeroLabel;
    UILabel* spmaxLabel;
    UILabel* spunitLabel;

    CGFloat scaleWidth;
}

- (id)initWithMapView:(MKMapView*)aMapView;
- (void)constructLabels;

@end



@implementation LXMapScaleView

@synthesize style;
@synthesize metric;
@synthesize position;
@synthesize padding;
@synthesize maxWidth,showSpeedScale,speedColours,topSpeedString,topSpeedUnits,distanceUnits,minorDistanceUnits;


// -----------------------------------------------------------------------------
// LXMapScaleView::mapScaleForMapView:
// -----------------------------------------------------------------------------
+ (LXMapScaleView*)mapScaleForMapView:(MKMapView*)aMapView
{
    if ( !aMapView )
    {
        return nil;
    }
    
    for ( UIView* subview in aMapView.subviews )
    {
        if ( [subview isKindOfClass:[LXMapScaleView class]] )
        {
            return (LXMapScaleView*)subview;
        }
    }
    
    return [[LXMapScaleView alloc] initWithMapView:aMapView];
}


// -----------------------------------------------------------------------------
// LXMapScaleView::initWithMapView:
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
        style = kLXMapScaleStyleBar;
        position = kLXMapScalePositionBottomLeft;
        padding = kDefaultPadding;
        maxWidth = kDefaultViewRect.size.width;
        
        showSpeedScale=false;
        
        speedColours = [[NSMutableArray alloc] initWithObjects:
        [UIColor colorWithRed: 142.0/255.0 green: 1.0/255.0 blue: 82.0/255.0 alpha: 0.8],
        [UIColor colorWithRed: 197.0/255.0 green: 27.0/255.0 blue: 125.0/255.0 alpha: 0.8],
        [UIColor colorWithRed: 222.0/255.0 green: 119.0/255.0 blue: 174.0/255.0 alpha: 0.8],
        [UIColor colorWithRed: 241.0/255.0 green: 182.0/255.0 blue: 218.0/255.0 alpha: 0.8],
        [UIColor colorWithRed: 253.0/255.0 green: 224.0/255.0 blue: 239.0/255.0 alpha: 0.8],
        [UIColor colorWithRed: 230.0/255.0 green: 245.0/255.0 blue: 208.0/255.0 alpha: 1.0],
        [UIColor colorWithRed: 184.0/255.0 green: 225.0/255.0 blue: 134.0/255.0 alpha: 1.0],
        [UIColor colorWithRed: 127.0/255.0 green: 188.0/255.0 blue: 65.0/255.0 alpha: 1.0],
        [UIColor colorWithRed: 77.0/255.0 green: 146.0/255.0 blue: 33.0/255.0 alpha: 1.0],
        [UIColor colorWithRed: 39.0/255.0 green: 100.0/255.0 blue: 25.0/255.0 alpha: 1.0],nil];
            

        [self constructLabels];
        
        [aMapView addSubview:self];
    }
    
    return self;
}


// -----------------------------------------------------------------------------
// LXMapScaleView::constructLabels
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
    
    unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 18*2, 10)];
    unitLabel.backgroundColor = [UIColor clearColor];
    unitLabel.textColor = [UIColor whiteColor];
    unitLabel.shadowColor = [UIColor blackColor];
    unitLabel.shadowOffset = CGSizeMake(1, 1);
    unitLabel.text = @"m";
    unitLabel.font = font;
    [self addSubview:unitLabel];
    //[unitLabel release];
    
    spzeroLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 8, 10)];
    spzeroLabel.backgroundColor = [UIColor clearColor];
    spzeroLabel.textColor = [UIColor whiteColor];
    spzeroLabel.shadowColor = [UIColor blackColor];
    spzeroLabel.shadowOffset = CGSizeMake(1, 1);
    spzeroLabel.text = @"0";
    spzeroLabel.font = font;
    [self addSubview:spzeroLabel];
    //[zeroLabel release];
    
    spmaxLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 10, 10)];
    spmaxLabel.backgroundColor = [UIColor clearColor];
    spmaxLabel.textColor = [UIColor whiteColor];
    spmaxLabel.shadowColor = [UIColor blackColor];
    spmaxLabel.shadowOffset = CGSizeMake(1, 1);
    spmaxLabel.text = @"1";
    spmaxLabel.font = font;
    spmaxLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:spmaxLabel];
    //[maxLabel release];
    
    spunitLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 18*3, 15)];
    spunitLabel.backgroundColor = [UIColor clearColor];
    spunitLabel.textColor = [UIColor whiteColor];
    spunitLabel.shadowColor = [UIColor blackColor];
    spunitLabel.shadowOffset = CGSizeMake(1, 1);
    spunitLabel.text = @"mmm";
    spunitLabel.font = font;
    [self addSubview:spunitLabel];
    
}


// -----------------------------------------------------------------------------
// LXMapScaleView::update
// -----------------------------------------------------------------------------
- (void)update
{
    if ( !mapView || !mapView.bounds.size.width )
    {
        return;
    }
    
    CLLocationDistance horizontalDistance = MKMetersPerMapPointAtLatitude(mapView.centerCoordinate.latitude);
    float metersPerPixel = mapView.visibleMapRect.size.width * horizontalDistance / mapView.bounds.size.width;
    
    CGFloat maxScaleWidth = maxWidth-40;
    
    NSUInteger maxValue = 0;
    NSString* unit = @"";
    NSString* spunit = @"";
    
    if ( metric == 0 )
    {
        float meters = maxScaleWidth*metersPerPixel;
        
        if ( meters > 2000.0f )
        {
            // use kilometer scale
            unit = distanceUnits;
            spunit = topSpeedUnits;
            static const NSUInteger kKilometerScale[] = {1,2,5,10,20,50,100,200,500,1000,2000,5000,10000,20000,50000};
            float kilometers = meters / 1000.0f;
            
            for ( int i = 0; i < 15; ++i )
            {
                if ( kilometers < kKilometerScale[i] )
                {
                    scaleWidth = maxScaleWidth * kKilometerScale[i-1]/kilometers;
                    maxValue = kKilometerScale[i-1];
                    break;
                }
            }
        }
        else
        {
            // use meter scale
            unit = minorDistanceUnits;
            spunit = topSpeedUnits;
            static const NSUInteger kMeterScale[11] = {1,2,5,10,20,50,100,200,500,1000,2000};
            
            for ( int i = 0; i < 11; ++i )
            {
                if ( meters < kMeterScale[i] )
                {
                    scaleWidth = maxScaleWidth * kMeterScale[i-1]/meters;
                    maxValue = kMeterScale[i-1];
                    break;
                }
            }
        }
    }
    else if (metric==1)
    {
        float feet = maxScaleWidth*metersPerPixel*kFeetPerMeter;
        
        if ( feet > kFeetPerMile )
        {
            // user mile scale
            unit = distanceUnits;
            spunit = topSpeedUnits;
            static const double kMileScale[] = {1,2,5,10,20,50,100,200,500,1000,2000,5000,10000,20000,50000};
            float miles = feet / kFeetPerMile;
            
            for ( int i = 0; i < 15; ++i )
            {
                if ( miles < kMileScale[i] )
                {
                    scaleWidth = maxScaleWidth * kMileScale[i-1]/miles;
                    maxValue = kMileScale[i-1];
                    break;
                }
            }
        }
        else
        {
            // use foot scale
            unit = minorDistanceUnits;
            spunit = topSpeedUnits;
           static const double kFootScale[] = {1,2,5,10,20,50,100,200,500,1000,2000,5000,10000};
            
            for ( int i = 0; i < 13; ++i )
            {
                if ( feet < kFootScale[i] )
                {
                    scaleWidth = maxScaleWidth * kFootScale[i-1]/feet;
                    maxValue = kFootScale[i-1];
                    break;
                }
            }
        }
    }
    else
    {
        float feet = maxScaleWidth*metersPerPixel*kFeetPerMeter;
        
        if ( feet > kFeetPerNMile )
        {
            // user mile scale
            unit = distanceUnits;
            spunit = topSpeedUnits;

            static const double kMileScale[] = {1,2,5,10,20,50,100,200,500,1000,2000,5000,10000,20000,50000};
            float miles = feet / kFeetPerNMile;
            
            for ( int i = 0; i < 15; ++i )
            {
                if ( miles < kMileScale[i] )
                {
                    scaleWidth = maxScaleWidth * kMileScale[i-1]/miles;
                    maxValue = kMileScale[i-1];
                    break;
                }
            }
        }
        else
        {
            // use foot scale
            unit = minorDistanceUnits;
            spunit = topSpeedUnits;
            static const double kFootScale[] = {1,2,5,10,20,50,100,200,500,1000,2000,5000,10000};
            
            for ( int i = 0; i < 13; ++i )
            {
                if ( feet < kFootScale[i] )
                {
                    scaleWidth = maxScaleWidth * kFootScale[i-1]/feet;
                    maxValue = kFootScale[i-1];
                    break;
                }
            }
        }
    }

    
    maxLabel.text = [NSString stringWithFormat:@"%d",maxValue];
    unitLabel.text = unit;
    spunitLabel.text = topSpeedUnits;
    spmaxLabel.text = topSpeedString;
    
    [self layoutSubviews];
}




// -----------------------------------------------------------------------------
// LXMapScaleView::setFrame:
// -----------------------------------------------------------------------------
- (void)setFrame:(CGRect)aFrame
{
    [self setMaxWidth:aFrame.size.width];
}


// -----------------------------------------------------------------------------
// LXMapScaleView::setBounds:
// -----------------------------------------------------------------------------
- (void)setBounds:(CGRect)aBounds
{
    [self setMaxWidth:aBounds.size.width];
}


// -----------------------------------------------------------------------------
// LXMapScaleView::setMaxWidth:
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
// LXMapScaleView::setAlpha:
// -----------------------------------------------------------------------------
- (void)setAlpha:(CGFloat)aAlpha
{
    [super setAlpha:aAlpha];
    zeroLabel.alpha = aAlpha;
    maxLabel.alpha = aAlpha;
    unitLabel.alpha = aAlpha;
    spzeroLabel.alpha = aAlpha;
    spmaxLabel.alpha = aAlpha;
    spunitLabel.alpha = aAlpha;
}


// -----------------------------------------------------------------------------
// LXMapScaleView::setStyle:
// -----------------------------------------------------------------------------
- (void)setStyle:(LXMapScaleStyle)aStyle
{
    if ( style != aStyle )
    {
        style = aStyle;
        
        [self setNeedsDisplay];
    }
}


// -----------------------------------------------------------------------------
// LXMapScaleView::setPosition:
// -----------------------------------------------------------------------------
- (void)setPosition:(LXMapScalePosition)aPosition
{
    if ( position != aPosition )
    {
        position = aPosition;
        
        [self setNeedsLayout];
    }
}


// -----------------------------------------------------------------------------
// LXMapScaleView::setMetric:
// -----------------------------------------------------------------------------
- (void)setMetric:(int)aIsMetric
{
    if ( metric != aIsMetric )
    {
        metric = aIsMetric;
        
        [self update];
    }
}


// -----------------------------------------------------------------------------
// LXMapScaleView::layoutSubviews
// -----------------------------------------------------------------------------
- (void)layoutSubviews
{
    CGSize maxLabelSize = [maxLabel.text sizeWithFont:maxLabel.font];
    maxLabel.frame = CGRectMake(zeroLabel.frame.size.width/2.0f+1+scaleWidth+1 - (maxLabelSize.width+1)/2.0f,
                                0,
                                maxLabelSize.width+1,
                                maxLabel.frame.size.height);
    
    CGSize unitLabelSize = unitLabel.frame.size;
    unitLabel.frame = CGRectMake(CGRectGetMaxX(maxLabel.frame),
                                 0,
                                 unitLabelSize.width,
                                 unitLabelSize.height);
    
    CGSize spmaxLabelSize = [spmaxLabel.text sizeWithFont:spmaxLabel.font];
    spmaxLabel.frame = CGRectMake(spzeroLabel.frame.size.width/2.0f+1+scaleWidth+1 - (spmaxLabelSize.width+1)/2.0f,
                                15,
                                spmaxLabelSize.width+1,
                                spmaxLabel.frame.size.height);
    
    CGSize spunitLabelSize = spunitLabel.frame.size;
    spunitLabel.frame = CGRectMake(CGRectGetMaxX(spmaxLabel.frame),
                                 15,
                                 spunitLabelSize.width,
                                 spunitLabelSize.height);
    
    CGSize mapSize = mapView.bounds.size;
    CGRect frame = self.bounds;
    float maxX=CGRectGetMaxX(unitLabel.frame);
    if(CGRectGetMaxX(spunitLabel.frame) > maxX)
        maxX=CGRectGetMaxX(spunitLabel.frame);
    frame.size.width = maxX - CGRectGetMinX(zeroLabel.frame);
    
    switch (position)
    {
        case kLXMapScalePositionTopLeft:
        {
            frame.origin = CGPointMake(padding.left,
                                       padding.top);
            self.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
            break;
        }
            
        case kLXMapScalePositionTop:
        {
            frame.origin = CGPointMake((mapSize.width - frame.size.width) / 2.0f,
                                       padding.top);
            self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
            break;
        }
            
        case kLXMapScalePositionTopRight:
        {
            frame.origin = CGPointMake(mapSize.width - padding.right - frame.size.width,
                                       padding.top);
            self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
            break;
        }
            
        default:
        case kLXMapScalePositionBottomLeft:
        {
            frame.origin = CGPointMake(padding.left,
                                       mapSize.height - padding.bottom - frame.size.height);
            self.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
            break;
        }
            
        case kLXMapScalePositionBottom:
        {
            frame.origin = CGPointMake((mapSize.width - frame.size.width) / 2.0f,
                                       mapSize.height - padding.bottom - frame.size.height);
            self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
            break;
        }
            
        case kLXMapScalePositionBottomRight:
        {
            frame.origin = CGPointMake(mapSize.width - padding.right - frame.size.width,
                                       mapSize.height - padding.bottom - frame.size.height);
            self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
            break;
        }
    }
    
    super.frame = frame;
    
    [self setNeedsDisplay];
}


// -----------------------------------------------------------------------------
// LXMapScaleView::drawRect:
// -----------------------------------------------------------------------------
- (void)drawRect:(CGRect)aRect
{
    if ( !mapView )
    {
        return;
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    if ( style == kLXMapScaleStyleTapeMeasure )
    {
        CGRect baseRect = CGRectZero;
        UIColor* strokeColor = [UIColor whiteColor];
        UIColor* fillColor = [UIColor blackColor];
        
        baseRect = CGRectMake(3, 24, scaleWidth+2, 3);
        [strokeColor setFill];
        CGContextFillRect(ctx, baseRect);
        
        baseRect = CGRectInset(baseRect, 1, 1);
        [fillColor setFill];
        CGContextFillRect(ctx, baseRect);
        
        baseRect = CGRectMake(3, 12, 3, 12);
        for ( int i = 0; i <= 5; ++i )
        {
            CGRect rodRect = baseRect;
            rodRect.origin.x += i*(scaleWidth-1)/5.0f;
            [strokeColor setFill];
            CGContextFillRect(ctx, rodRect);
            
            rodRect = CGRectInset(rodRect, 1, 1);
            rodRect.size.height += 2;
            [fillColor setFill];
            CGContextFillRect(ctx, rodRect);
        }
        
        baseRect = CGRectMake(3+(scaleWidth-1)/10.0f, 16, 3, 8);
        for ( int i = 0; i < 5; ++i )
        {
            CGRect rodRect = baseRect;
            rodRect.origin.x += i*(scaleWidth-1)/5.0f;
            [strokeColor setFill];
            CGContextFillRect(ctx, rodRect);
            
            rodRect = CGRectInset(rodRect, 1, 1);
            rodRect.size.height += 2;
            [fillColor setFill];
            CGContextFillRect(ctx, rodRect);
        }
    }
    else if ( style == kLXMapScaleStyleBar )
    {
        CGRect scaleRect = CGRectMake(4, 12, scaleWidth, 3);
        
        [[UIColor blackColor] setFill];
        CGContextFillRect(ctx, CGRectInset(scaleRect, -1, -1));
        
        [[UIColor whiteColor] setFill];
        CGRect unitRect = scaleRect;
        unitRect.size.width = scaleWidth/5.0f;
        
        for ( int i = 0; i < 5; i+=2 )
        {
            unitRect.origin.x = scaleRect.origin.x + unitRect.size.width*i;
            CGContextFillRect(ctx, unitRect);
        }
        
        if(showSpeedScale){
            CGRect scaleRect2 = CGRectMake(4, 26, scaleWidth, 3);
            
            // fill the background
            [[UIColor blackColor] setFill];
            CGContextFillRect(ctx, CGRectInset(scaleRect2, -1, -1));
            
            // fill in the segments
            for ( int i = 0; i < 10; i++ )
            {
                [[speedColours objectAtIndex:i] setFill];
//                [[UIColor redColor] setFill];
                CGRect unitRect = scaleRect2;
                unitRect.size.width = scaleWidth/10.0f;
                unitRect.origin.x = scaleRect2.origin.x + unitRect.size.width*i;
                CGContextFillRect(ctx, unitRect);
            }
            
        }
    }
    else if ( style == kLXMapScaleStyleAlternatingBar )
    {
        CGRect scaleRect = CGRectMake(4, 12, scaleWidth, 6);
        
        [[UIColor blackColor] setFill];
        CGContextFillRect(ctx, CGRectInset(scaleRect, -1, -1));
        
        [[UIColor whiteColor] setFill];
        CGRect unitRect = scaleRect;
        unitRect.size.width = scaleWidth/5.0f;
        unitRect.size.height = scaleRect.size.height/2.0f;
        
        for ( int i = 0; i < 5; ++i )
        {
            unitRect.origin.x = scaleRect.origin.x + unitRect.size.width*i;
            unitRect.origin.y = scaleRect.origin.y + unitRect.size.height*(i%2);
            CGContextFillRect(ctx, unitRect);
        }
    }
}


@end
