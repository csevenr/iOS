//
//  TouchDownTapGestureRecognizer.h
//  AppSketch
//
//  Created by Oliver Rodden on 12/01/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouchDownTapGestureRecognizer : UITapGestureRecognizer

//@property NSInteger numberOfTapsRequired;

-(id)initWithTarget:(id)target action:(SEL)action secondeAction:(SEL)secondAction;

@end
