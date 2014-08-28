//
//  Pixel.h
//  PixelArt
//
//  Created by Oliver Rodden on 26/02/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CanvasViewController;

@interface Pixel : UIButton{
    CanvasViewController *canvas;
}

- (id)initWithCanvas:(CanvasViewController*)viewController;

@end
