//
//  MenuViewController.h
//  touch test
//
//  Created by Oliver Rodden on 27/08/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CanvasViewController.h"

@interface MenuViewController : UIViewController <CanvasDelegate>

- (IBAction)buttonPressed:(UIButton*)sender;

@end
