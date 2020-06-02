//
//  STPPaymentIntentAction.h
//  Stripe
//
//  Created by Yuki Tokuhiro on 3/8/19.
//  Copyright © 2019 Stripe, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STPIntentAction.h"

/**
 Action details for an STPPaymentIntent. This is a container for
 the various types that are available. Check the `type` to see which one
 it is, and then use the related property for the details necessary to handle it.
 
 @deprecated Use `STPIntentAction` instead.
 */
__attribute__((deprecated("Use STPIntentAction instead", "STPIntentAction")))
typedef STPIntentAction STPPaymentIntentAction;
