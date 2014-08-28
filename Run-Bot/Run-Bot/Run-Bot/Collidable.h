//
//  Colliable.h
//  Run-Bot
//
//  Created by Oliver Rodden on 19/02/2014.
//  Copyright (c) 2014 Oliver Rodden. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameViewController;

@protocol collidableDelegate <NSObject>

-(void)robotCollidedWith:(id)collider;
//-(void)collid

@end

@interface Collidable : UIImageView

@property(nonatomic)id<collidableDelegate>delegate;
@property(nonatomic)NSInteger location;

- (id)initWithViewController:(GameViewController*)viewController;
-(void)collided;
-(void)offScreen;

@end
