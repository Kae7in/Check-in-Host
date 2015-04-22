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
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSMutableArray *attendees;
@property (strong, nonatomic) GMSMarker *marker;

- (instancetype)initEventWithTitle:(NSString *)title
                          location:(CLLocation *)location
                              date:(NSDate *)date
                         attendees:(NSMutableArray *)attendees
                            marker:(GMSMarker *)marker;

- (void)setTitle:(NSString *)title
        location:(CLLocation *)location
            date:(NSDate *)date
       attendees:(NSMutableArray *)attendees
          marker:(GMSMarker *)marker;

- (void)commit;

#warning: Allow for an update to the existing object after editing.
//- (void)update;

@end
