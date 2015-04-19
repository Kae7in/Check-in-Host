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

@interface EventRepo : NSObject
- (void)createEventWithTitle:(NSString *)title
                    location:(CLLocation *)location
                        date:(NSDate *)date
                   attendees:(PFUser *)invitees;
- (instancetype)init;
@end
