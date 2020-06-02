//
//  STPCustomerContext.h
//  Stripe
//
//  Created by Ben Guo on 5/2/17.
//  Copyright © 2017 Stripe, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STPBackendAPIAdapter.h"

NS_ASSUME_NONNULL_BEGIN

@protocol STPCustomerEphemeralKeyProvider;
@class STPEphemeralKey, STPEphemeralKeyManager, STPAPIClient;

/**
 An `STPCustomerContext` retrieves and updates a Stripe customer and their attached
 payment methods using an ephemeral key, a short-lived API key scoped to a specific
 customer object. If your current user logs out of your app and a new user logs in,
 be sure to either create a new instance of `STPCustomerContext` or clear the current
 instance's cache. On your backend, be sure to create and return a
 new ephemeral key for the Customer object associated with the new user.
 */
@interface STPCustomerContext : NSObject <STPBackendAPIAdapter>

/**
 Initializes a new `STPCustomerContext` with the specified key provider.
 Upon initialization, a CustomerContext will fetch a new ephemeral key from
 your backend and use it to prefetch the customer object specified in the key.
 Subsequent customer and payment method retrievals (e.g. by `STPPaymentContext`)
 will return the prefetched customer / attached payment methods immediately if
 its age does not exceed 60 seconds.

 @param keyProvider   The key provider the customer context will use.
 @return the newly-instantiated customer context.
 */
- (instancetype)initWithKeyProvider:(id<STPCustomerEphemeralKeyProvider>)keyProvider;

/**
Initializes a new `STPCustomerContext` with the specified key provider.
Upon initialization, a CustomerContext will fetch a new ephemeral key from
your backend and use it to prefetch the customer object specified in the key.
Subsequent customer and payment method retrievals (e.g. by `STPPaymentContext`)
will return the prefetched customer / attached payment methods immediately if
its age does not exceed 60 seconds.

@param keyProvider   The key provider the customer context will use.
@param apiClient       The API Client to use to make requests.
@return the newly-instantiated customer context.
*/
- (instancetype)initWithKeyProvider:(id<STPCustomerEphemeralKeyProvider>)keyProvider apiClient:(STPAPIClient *)apiClient;


/**
 `STPCustomerContext` will cache its customer object and associated payment methods
 for up to 60 seconds. If your current user logs out of your app and a new user logs
 in, be sure to either call this method or create a new instance of `STPCustomerContext`.
 On your backend, be sure to create and return a new ephemeral key for the
 customer object associated with the new user.
 */
- (void)clearCache;

/**
 By default, `STPCustomerContext` will filter Apple Pay when it retrieves
 Payment Methods. Apple Pay payment methods should generally not be re-used and
 shouldn't be offered to customers as a new payment method (Apple Pay payment
 methods may only be re-used for subscriptions).

 If you are using `STPCustomerContext` to back your own UI and would like to
 disable Apple Pay filtering, set this property to YES.

 Note: If you are using `STPPaymentContext`, you should not change this property.
 */
@property (nonatomic, assign) BOOL includeApplePayPaymentMethods;

@end

NS_ASSUME_NONNULL_END
