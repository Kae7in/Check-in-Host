//
//  Event.h
//  Check-In Host
//
//  Created by Kaelin D. Hooper on 4/20/15.
//  Copyright (c) 2015 CS378. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "PFFacebookUtils.h"

@interface Event : NSObject

@property (strong, nonatomic) NSString *objectID;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (strong, nonatomic) NSMutableArray *attendees;
@property (strong, nonatomic) NSMutableArray *invitees;
@property (nonatomic) BOOL currentUserIsHost;

- (instancetype)initEventWithTitle:(NSString *)title
                          location:(CLLocation *)location
                         startDate:(NSDate *)startDate
                           endDate:(NSDate *)endDate
                         attendees:(NSMutableArray *)attendees
                          invitees:(NSMutableArray *)invitees;

- (void)setTitle:(NSString *)title
        location:(CLLocation *)location
       startDate:(NSDate *)startDate
         endDate:(NSDate *)endDate
       attendees:(NSMutableArray *)attendees
        invitees:(NSMutableArray *)invitees;

- (void)commit;

#warning: Allow for an update to the existing object after editing.
//- (void)update;

@end
