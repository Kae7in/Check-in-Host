//
//  EventRepo.m
//  Check-In Host
//
//  Created by Kaelin D. Hooper on 4/16/15.
//  Copyright (c) 2015 CS378. All rights reserved.
//

#import "EventRepo.h"
#import "PFFacebookUtils.h"
#import <Parse/Parse.h>
#import "Event.h"
#import <GoogleMaps/GoogleMaps.h>

@interface EventRepo()
@property NSUserDefaults *defaults;
@property (strong, nonatomic) NSMutableArray *currentUserEvents;
@end

@implementation EventRepo

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.defaults = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}


- (NSMutableArray *)currentUserEvents {
    if (!_currentUserEvents) _currentUserEvents = [[NSMutableArray alloc] init];
    return _currentUserEvents;
}


- (NSUInteger)countOfCurrentUserEvents {
    return [self.currentUserEvents count];
}


- (void)addCurrentUserEvent:(Event *)event {
    NSLog(@"here");
    [self.currentUserEvents addObject:event];
    NSLog(@"added: %lu", self.currentUserEvents.count);
}


- (void)loadCurrentUserEvents {
    
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" equalTo:user.objectId];
    query.limit = 1;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0) {
                PFObject *_user = [objects objectAtIndex:0];
                //                _nameLabel.text = [_user objectForKey:@"displayName"];
                PFRelation *_relation = _user[@"events"];
                PFQuery *_query = [_relation query];
                
                [_query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        if (objects.count > 0) {
//                            self.currentUserEvents = [self NativeEventObjectsFromParseEventObjects:objects];
                            NSLog(@"USER: %@", objects);
#warning: Finish implementing
                        }
                    }
                }];
            }
        }
    }];
    
}


- (NSMutableArray *)NativeEventObjectsFromParseEventObjects:(NSArray *)events {
#warning: finish implementing this
//    for (PFUser *user in events)
    return 0;
}


- (Event *)eventForMarker:(GMSMarker *)marker {
    for (Event *e in self.currentUserEvents) {
        if (marker == e.marker) {
            return e;
        }
    }
    
    NSLog(@"Error: event for selected marker not found");

    return NULL;
}

@end
