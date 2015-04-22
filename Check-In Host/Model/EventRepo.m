//
//  EventRepo.m
//  Check-In Host
//
//  Created by Kaelin D. Hooper on 4/16/15.
//  Copyright (c) 2015 CS378. All rights reserved.
//

#import "EventRepo.h"
#import "PFFacebookUtils.h"
#import "Event.h"

@interface EventRepo()
@property NSUserDefaults *defaults;
@end

@implementation EventRepo

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.defaults = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}


- (void)saveEvent:(Event *)event {
    // attach event to
}

@end
