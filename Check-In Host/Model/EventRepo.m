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
@property (strong, nonatomic) NSMutableArray *eventsInvitedTo;
@end

@implementation EventRepo

- (instancetype)init {
    self = [super init];
    
    if (self) {
//        self.defaults = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}


- (NSMutableArray *)currentUserEvents {
    if (!_currentUserEvents) _currentUserEvents = [[NSMutableArray alloc] init];
    return _currentUserEvents;
}


- (NSMutableArray *)eventsInvitedTo {
    if (!_eventsInvitedTo) _eventsInvitedTo = [[NSMutableArray alloc] init];
    return _eventsInvitedTo;
}


- (NSUInteger)countOfCurrentUserEvents {
    return [self.currentUserEvents count];
}


- (NSUInteger)countOfEventsInvitedTo {
    return [self.eventsInvitedTo count];
}


- (void)addCurrentUserEvent:(Event *)event {
    [self.currentUserEvents addObject:event];
    NSLog(@"EVENTS ADDED: %lu", self.currentUserEvents.count);
}


- (void)addEventInvitedTo:(Event *)event {
    [self.eventsInvitedTo addObject:event];
}


- (void)loadCurrentUserEventsWithMapView:(GMSMapView *)mapView {
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" equalTo:user.objectId];
    query.limit = 1;
    
    __weak EventRepo *weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0) {
                PFObject *_user = [objects objectAtIndex:0];
                PFRelation *_relation = _user[@"events"];
                PFQuery *_query = [_relation query];
                [_query includeKey:@"hostUser"];
                
                [_query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        if (objects.count > 0) {
                            weakSelf.currentUserEvents = [weakSelf NativeEventObjectsFromParseEventObjects:objects withMapView:mapView usingWeakSelf:weakSelf];
                        }
                    }
                }];
            }
        }
    }];
    
}


- (NSMutableArray *)NativeEventObjectsFromParseEventObjects:(NSArray *)parseEvents withMapView:(GMSMapView *)mapView usingWeakSelf:(EventRepo *)weakSelf {
    NSMutableArray *nativeEvents = [[NSMutableArray alloc] init];
    for (PFObject *event in parseEvents) {
        /* Get the rest of the info from the Parse event object */
        Event *nativeEvent = [weakSelf NativeEventObjectFromParseEventObject:event withMapView:mapView];
        if (nativeEvent) {
            [nativeEvents addObject:nativeEvent];
        }
    }
    
    return nativeEvents;
}


- (Event *)NativeEventObjectFromParseEventObject:(PFObject *)parseEvent withMapView:(GMSMapView *)mapView {
    NSString *title = parseEvent[@"title"];
    PFUser *hostUser = [[PFUser alloc] init];
    hostUser = [parseEvent objectForKey:@"hostUser"];
    NSString *hostUsername = hostUser[@"CHUserID"];
    PFGeoPoint *geoPoint = parseEvent[@"location"];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:geoPoint.latitude longitude:geoPoint.longitude];
    NSDate *date = parseEvent[@"date"];
#warning: implement grabbing attendees
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    [marker setTitle:title];
    [marker setPosition:location.coordinate];
    if (hostUsername) {
        [marker setSnippet:hostUsername];
    } else {
        [marker setSnippet:@"Unknown"];
    }
    marker.map = mapView;
    
    Event *nativeEvent = [[Event alloc] initEventWithTitle:title location:location date:date attendees:nil invitees:nil marker:marker];
    if ([hostUsername isEqualToString:[[PFUser currentUser] objectForKey:@"CHUserID"]]) {
        nativeEvent.currentUserIsHost = true;
    }
    
    
    return nativeEvent;
}


/* Get host username from user relation on parse event */
//- (NSString *)getHostUsername:(PFRelation *)userRelation {
//    
//    __block NSString *username;
//    PFQuery *_query = [userRelation query];
//    
//    [_query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            if (objects.count > 0) {
//                PFUser *hostUser = [objects firstObject];
//                if (hostUser) {
//                    username = hostUser[@"CHUserID"];
//                }
//            }
//        }
//    }];
//    
//    return username;
//}


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
