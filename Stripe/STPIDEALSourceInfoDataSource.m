//
//  STPIDEALSourceInfoDataSource.m
//  Stripe
//
//  Created by Ben Guo on 3/2/17.
//  Copyright © 2017 Stripe, Inc. All rights reserved.
//

#import "STPIDEALSourceInfoDataSource.h"

#import "NSArray+Stripe_BoundSafe.h"
#import "STPIDEALBankSelectorDataSource.h"
#import "STPLocalizationUtils.h"
#import "STPTextFieldTableViewCell.h"

@implementation STPIDEALSourceInfoDataSource

- (instancetype)initWithSourceParams:(STPSourceParams *)sourceParams {
    self = [super initWithSourceParams:sourceParams];
    if (self) {
        self.title = STPLocalizedString(@"Pay with iDEAL", @"Title for form to collect iDEAL account info");
        STPTextFieldTableViewCell *nameCell = [[STPTextFieldTableViewCell alloc] init];
        nameCell.placeholder = STPLocalizedString(@"Name", @"Caption for Name field on bank info form");
        if (self.sourceParams.owner) {
            nameCell.contents = self.sourceParams.owner[@"name"];
        }
        self.cells = @[nameCell];
        self.selectorDataSource = [STPIDEALBankSelectorDataSource new];
        NSDictionary *idealDict = self.sourceParams.additionalAPIParameters[@"ideal"];
        if (idealDict) {
            [self.selectorDataSource selectRowWithValue:idealDict[@"bank"]];
        }
    }
    return self;
}

- (STPSourceParams *)completeSourceParams {
    STPSourceParams *params = [self.sourceParams copy];
    NSMutableDictionary *owner = [NSMutableDictionary new];
    if (params.owner) {
        owner = [params.owner mutableCopy];
    }
    NSMutableDictionary *additionalParams = [NSMutableDictionary new];
    if (params.additionalAPIParameters) {
        additionalParams = [params.additionalAPIParameters mutableCopy];
    }
    STPTextFieldTableViewCell *nameCell = [self.cells stp_boundSafeObjectAtIndex:0];
    owner[@"name"] = nameCell.contents;
    params.owner = owner;
    NSMutableDictionary *idealDict = [NSMutableDictionary new];
    if (additionalParams[@"ideal"]) {
        idealDict = additionalParams[@"ideal"];
    }
    STPTextFieldTableViewCell *bankCell = [self.cells stp_boundSafeObjectAtIndex:1];
    idealDict[@"bank"] = bankCell.contents;
    additionalParams[@"ideal"] = idealDict;
    params.additionalAPIParameters = additionalParams;

    NSString *name = params.owner[@"name"];
    NSString *bank = params.additionalAPIParameters[@"ideal"][@"bank"];
    if (name.length > 0 && bank.length > 0) {
        return params;
    }
    return nil;
}

@end
