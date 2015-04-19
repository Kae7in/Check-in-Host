//
//  EventRepo.m
//  Check-In Host
//
//  Created by Kaelin D. Hooper on 4/16/15.
//  Copyright (c) 2015 CS378. All rights reserved.
//

#import "EventRepo.h"
#import "PFGeoPoint.h"
#import "PFRelation.h"

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


- (void)createEventWithTitle:(NSString *)title
                    location:(CLLocation *)location
                        date:(NSDate *)date
                   attendees:(PFUser *)invitees
{
    /******* CREATE EVENT OBJECT *******/
    // create event object to store in parse db
    PFObject *event = [PFObject objectWithClassName:@"Event"];
    
    // set host of the event (the current PFUser)
    PFRelation *userRelation = [event relationForKey:@"hostUser"];
    [userRelation addObject:[PFUser currentUser]];
    
    // set the title of the event
    if (title) {
        [event setObject:title forKey:@"title"];
    }
    
    // set the location
    if (location) {
        PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:location];
        [event setObject:geoPoint forKey:@"location"];
    }
    
    // set the date
    if (date) {
        [event setObject:date forKey:@"date"];
    }
    
    // set list of invitees(s)
    if (invitees) {
        [event setObject:invitees forKey:@"invitees"];
    }

    [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSInteger errCode = [error code];
        if (kPFErrorConnectionFailed == errCode
            ||  kPFErrorInternalServer == errCode)
            [event saveEventually];
    }];
    
    /******* UPDATE USER OBJECT THAT HOSTS THIS EVENT *******/
    
    // add a relation to the "events" category for this user
    PFObject *currentUser = [PFUser currentUser];
    [event save];
    [currentUser save];
    PFRelation *eventRelation = [currentUser relationForKey:@"events"];
    [eventRelation addObject:event];
    
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSInteger errCode = [error code];
        if (kPFErrorConnectionFailed == errCode
            ||  kPFErrorInternalServer == errCode)
            [event saveEventually];
    }];
}

@end
