//
//  EventRepo.h
//  Check-In Host
//
//  Created by Kaelin D. Hooper on 4/16/15.
//  Copyright (c) 2015 CS378. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "PFFacebookUtils.h"
#import "Event.h"

@interface EventRepo : NSObject
@property (strong, nonatomic) NSMutableArray *currentUserEvents;

- (instancetype)init;
- (void)loadCurrentUserEventsWithCompletionHandler:(void(^)(void))completionHandler;
- (void)addCurrentUserEvent:(Event *)event;
- (Event *)eventForMarker:(GMSMarker *)marker;
@end
