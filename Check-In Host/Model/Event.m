//
//  Event.m
//  Check-In Host
//
//  Created by Kaelin D. Hooper on 4/20/15.
//  Copyright (c) 2015 CS378. All rights reserved.
//

#import "Event.h"
#import "PFGeoPoint.h"
#import "PFRelation.h"

@interface Event()
#warning Maybe save some event as private properties (in NSUserDefaults) for ease of recalling on load?
//@property (strong, nonatomic) NSString *title;
//@property (strong, nonatomic) CLLocation *location;
//@property (strong, nonatomic) NSDate *date;
//@property (strong, nonatomic) NSArray *invitees;
@property (strong, nonatomic) PFObject *event;
@end

@implementation Event

- (instancetype)initEventWithTitle:(NSString *)title
                              location:(CLLocation *)location
                                  date:(NSDate *)date
                             attendees:(NSMutableArray *)invitees
{
    self = [super init];
    
    if (self) {
        // Initialize the event as a PFObject
        self.event = [PFObject objectWithClassName:@"Event"];
        
        // Locally set the host user (current user) of this event
        PFRelation *userRelation = [self.event relationForKey:@"hostUser"];
        [userRelation addObject:[PFUser currentUser]];
        
        // Set the internal properties of the event
        [self setTitle:title location:location date:date attendees:invitees];
    }
    
    return self;
}


- (void)setTitle:(NSString *)title
        location:(CLLocation *)location
            date:(NSDate *)date
       attendees:(NSMutableArray *)invitees
{
    /******* CREATE EVENT OBJECT *******/
    
    // set the title of the event
    if (title) {
        [self.event setObject:title forKey:@"title"];
    }
    
    // set the location
    if (location) {
        PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:location];
        [self.event setObject:geoPoint forKey:@"location"];
    }
    
    // set the date
    if (date) {
        [self.event setObject:date forKey:@"date"];
    }
    
    // set list of invitees(s)
    if (invitees) {
        [self.event setObject:invitees forKey:@"invitees"];
    }
}


/* Commit this event object to the Parse database */
- (void)commit {
    // Save event to Parse "Event" class
    __weak Event *weakSelf = self;
    [self.event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSInteger errCode = [error code];
        if (kPFErrorConnectionFailed == errCode
            ||  kPFErrorInternalServer == errCode)
            [weakSelf.event saveEventually];
    }];
    
    // Add a relation to the "events" column on Parse "User" class
    PFObject *currentUser = [PFUser currentUser];

    PFRelation *eventRelation = [currentUser relationForKey:@"events"];
    [eventRelation addObject:self.event];

    [self.event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSInteger errCode = [error code];
        if (kPFErrorConnectionFailed == errCode
            || kPFErrorInternalServer == errCode)
            [weakSelf.event saveEventually];
        
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSInteger errCode = [error code];
            if (kPFErrorConnectionFailed == errCode
                || kPFErrorInternalServer == errCode)
                [weakSelf.event saveEventually];
        }];
    }];
}

@end
