//
//  STPLocalizationUtils.h
//  Stripe
//
//  Created by Brian Dorfman on 8/11/16.
//  Copyright © 2016 Stripe, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STPLocalizationUtils : NSObject

/**
 Acts like NSLocalizedString but tries to find the string in the Stripe
 bundle first if possible.
 */
+ (nonnull NSString *)localizedStripeStringForKey:(nonnull NSString *)key;

/**
 Sorts the given country codes by their display name in the current locale.
 */
+ (void)sortCountryCodesByDisplayName:(nonnull NSMutableArray<NSString *>*)countryCodes;

@end

static inline NSString * _Nonnull STPLocalizedString(NSString* _Nonnull key, NSString * _Nullable __unused comment) {
    return [STPLocalizationUtils localizedStripeStringForKey:key];
}
