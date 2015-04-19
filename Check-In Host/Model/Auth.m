//
//  Auth.m
//  Check-In Host
//
//  Created by Kaelin D. Hooper on 4/4/15.
//  Copyright (c) 2015 CS378. All rights reserved.
//

#import "Auth.h"
#import "PFFacebookUtils.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#define PERMISSIONS @[@"public_profile", @"email"]

@implementation Auth

+ (NSArray *)permissions {
    return PERMISSIONS;
}


+ (void)submitUserIDAsColumnEntryIntoUserClass {
    PFUser *user = [PFUser currentUser];
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             user[@"fbUserID"] = [result[@"id"] description];
             [user saveInBackground];
         }
     }];
}

@end
