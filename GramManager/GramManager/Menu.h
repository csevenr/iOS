//
//  Menu.h
//  GramManager
//
//  Created by Oliver Rodden on 02/10/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuDelegate <NSObject>

-(void)swicthButtonPressed;

@end

@interface Menu : UIView

@property (nonatomic, weak) id<MenuDelegate> delegate;

@end
