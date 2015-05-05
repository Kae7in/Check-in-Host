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
#import <Parse/Parse.h>

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
{
    self = [super init];
    
    if (self) {
        // Initialize the event as a PFObject
        self.PFEvent = [PFObject objectWithClassName:@"Event"];
        
        // Locally set the host user (current user) of this event
        [self.PFEvent setObject:[PFUser currentUser] forKey:@"hostUser"];
        
        // Set the internal properties of the event
        [self setTitle:title location:location startDate:startDate endDate:endDate attendees:attendees invitees:invitees];
    }
    
    return self;
}


- (void)setTitle:(NSString *)title
        location:(CLLocation *)location
       startDate:(NSDate *)startDate
         endDate:(NSDate *)endDate
       attendees:(NSMutableArray *)attendees
        invitees:(NSMutableArray *)invitees
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
//        [self.PFEvent setObject:attendees forKey:@"attendees"];
        self.attendees = attendees;
    }
    
    if (invitees) {
//        [self.PFEvent setObject:invitees forKey:@"invitees"];
        self.invitees = invitees;
    }
    
    self.objectID = self.PFEvent.objectId;
}


/* Commit this event object to the Parse database */
- (void)commit {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // Save the event
        [self.PFEvent save];
        
        // Add a relation to the "events" column on Parse "User" class
        PFRelation *eventRelation = [[PFUser currentUser] relationForKey:@"events"];
        [eventRelation addObject:self.PFEvent];
        
        // Add relations to the "invitees" column on Parse "Event" class
        if (self.invitees) {
            [self addInviteesRelations];
        }
        
        [self.PFEvent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    
            }];
        }];
    });
    
}


- (void)addInviteesRelations {
    
    for (NSString *username in self.invitees) {
        // Get a PFUser with username
        PFQuery *query = [PFUser query];
        [query whereKey:@"CHUserID" equalTo:username];
        NSArray *objects = [query findObjects];
        PFUser *invitee = [objects firstObject];

        if (invitee) {
            NSLog(@"User: %@", invitee[@"CHUserID"]);
                
            // Add the PFUser to the "invitees" relation on this event
            PFRelation *userRelation = [self.PFEvent relationForKey:@"invitees"];
            [userRelation addObject:invitee];
                
            // Add the PFEvent to the "events" relation on the invited user
            PFRelation *eventRelation = [invitee relationForKey:@"events"];
            [eventRelation addObject:self.PFEvent];
            
//            [self saveInviteeUsingCloudCode:invitee];
        }
        
    }

}


//- (void)saveInviteeUsingCloudCode:(PFUser *)invitee {
//    PFUser *user = [PFUser currentUser];
//    [PFCloud callFunctionInBackground:@"CalUsed" //This is the Parse function
//                       withParameters:@{@"user": user.objectId}
//                                block:^(NSNumber *CalUsed1, NSError *error) { // This is where the block starts
//                                    if (!error) { //if the block retrieves the data with no problem, this will run
//                                        NSLog(@"Calories : %@",CalUsed1);
//                                        CalUsed = CalUsed1;
//                                    }
//                                    CalUsed = CalUsed1;
//                                    NSLog(@"TDEE IN FN is : %@",CalUsed);
//                                }];
//}


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
