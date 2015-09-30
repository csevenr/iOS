//
//  IAPHelper.h
//  xpand
//
//  Created by Oli Rodden on 10/03/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface IAPHelper : NSObject

- (id)initWithProductIdentifiers:(NSSet *)_productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)_completionHandler;

@end
