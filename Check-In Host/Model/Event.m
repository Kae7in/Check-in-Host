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
@property (strong, nonatomic) PFObject *PFEvent;
@end

@implementation Event

- (instancetype)initEventWithTitle:(NSString *)title
                              location:(CLLocation *)location
                             startDate:(NSDate *)startDate
                               endDate:(NSDate *)endDate
                             attendees:(NSMutableArray *)attendees
                              invitees:(NSMutableArray *)invitees
                                marker:(GMSMarker *)marker
{
    self = [super init];
    
    if (self) {
        // Initialize the event as a PFObject
        self.PFEvent = [PFObject objectWithClassName:@"Event"];
        
        // Locally set the host user (current user) of this event
        [self.PFEvent setObject:[PFUser currentUser] forKey:@"hostUser"];
        
        // Set the internal properties of the event
        [self setTitle:title location:location startDate:startDate endDate:endDate attendees:attendees invitees:invitees marker:marker];
    }
    
    return self;
}


- (void)setTitle:(NSString *)title
        location:(CLLocation *)location
       startDate:(NSDate *)startDate
         endDate:(NSDate *)endDate
       attendees:(NSMutableArray *)attendees
        invitees:(NSMutableArray *)invitees
          marker:(GMSMarker *)marker
{
    /******* CREATE EVENT OBJECT *******/
    
    // set the title of the event
    if (title) {
        [self.PFEvent setObject:title forKey:@"title"];
        self.title = title;
    }
    
    // set the location
    if (location) {
        PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:location];
        [self.PFEvent setObject:geoPoint forKey:@"location"];
        self.location = location;
    }
    
    // set the date
    if (startDate) {
        [self.PFEvent setObject:startDate forKey:@"startDate"];
        self.startDate = startDate;
    }
    
    if (endDate) {
        [self.PFEvent setObject:endDate forKey:@"endDate"];
        self.endDate = endDate;
    }
    
    // set list of invitees(s)
    if (attendees) {
        [self.PFEvent setObject:attendees forKey:@"attendees"];
        self.attendees = attendees;
    }
    
    if (invitees) {
        [self.PFEvent setObject:invitees forKey:@"invitees"];
        self.invitees = invitees;
    }
    
    if (marker) {
        self.marker = marker;
    }
    
    self.objectID = self.PFEvent.objectId;
}


/* Commit this event object to the Parse database */
- (void)commit {
    // Save event to Parse "Event" class
    __weak Event *weakSelf = self;
    [self.PFEvent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSInteger errCode = [error code];
        if (kPFErrorConnectionFailed == errCode
            ||  kPFErrorInternalServer == errCode)
            [weakSelf.PFEvent saveEventually];
    }];

    // Add a relation to the "events" column on Parse "User" class
    PFObject *currentUser = [PFUser currentUser];
    
    PFRelation *eventRelation = [currentUser relationForKey:@"events"];
    [eventRelation addObject:self.PFEvent];
    
    [self.PFEvent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSInteger errCode = [error code];
        if (kPFErrorConnectionFailed == errCode
            || kPFErrorInternalServer == errCode)
            [weakSelf.PFEvent saveEventually];
        
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSInteger errCode = [error code];
            if (kPFErrorConnectionFailed == errCode
                || kPFErrorInternalServer == errCode)
                [weakSelf.PFEvent saveEventually];
        }];
    }];
}


#warning: Allow for an update to the existing object after editing.
//- (void)update {
//    NSLog(@"here");
//    NSLog(@"self.objectID: %@", self.objectID);
//    PFQuery *PFEventQuery = [[PFQuery alloc] initWithClassName:@"Event"];
//    
//    PFObject *PFEvent = [PFEventQuery getObjectWithId:self.objectID];
//    
//    [PFEvent setObject:self.title forKey:@"title"];
//    [PFEvent setObject:self.date forKey:@"date"];
//    [PFEvent setObject:self.attendees forKey:@"attendees"];
//
//    [PFEvent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        NSInteger errCode = [error code];
//        if (kPFErrorConnectionFailed == errCode
//            || kPFErrorInternalServer == errCode)
//            [PFEvent saveEventually];
//    }];
//}

@end
