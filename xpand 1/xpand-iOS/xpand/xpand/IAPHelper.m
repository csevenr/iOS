//
//  IAPHelper.m
//  xpand
//
//  Created by Oli Rodden on 10/03/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "IAPHelper.h"
#import <StoreKit/StoreKit.h>

@interface IAPHelper () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@end

@implementation IAPHelper{
    SKProductsRequest * productsRequest;
    RequestProductsCompletionHandler completionHandler;
    
    NSSet * productIdentifiers;

}

- (id)initWithProductIdentifiers:(NSSet *)_productIdentifiers {
    if ((self = [super init])) {
        // Store product identifiers
        productIdentifiers = _productIdentifiers;
    }
    return self;
}


- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)_completionHandler {
    completionHandler = [_completionHandler copy];
    
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSLog(@"Loaded list of products...");
    productsRequest = nil;

    NSArray * skProducts = response.products;
    for (SKProduct * skProduct in skProducts) {
        NSLog(@"Found product: %@ %@ %0.2f",
        skProduct.productIdentifier,
        skProduct.localizedTitle,
        skProduct.price.floatValue);
    }

    if (completionHandler != nil) {
        completionHandler(YES, skProducts);
        completionHandler = nil;        
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Failed to load list of products.");
    productsRequest = nil;

    completionHandler(NO, nil);
    completionHandler = nil;
}

@end
