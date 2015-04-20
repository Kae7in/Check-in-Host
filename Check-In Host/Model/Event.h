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
#import "PFFacebookUtils.h"

@interface Event : NSObject
- (instancetype)initWithEventWithTitle:(NSString *)title
                              location:(CLLocation *)location
                                  date:(NSDate *)date
                             attendees:(NSMutableArray *)invitees;

- (void)setTitle:(NSString *)title
        location:(CLLocation *)location
            date:(NSDate *)date
       attendees:(NSMutableArray *)invitees;

- (void)commit;
@end
