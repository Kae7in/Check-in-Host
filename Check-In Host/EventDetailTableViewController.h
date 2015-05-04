//
//  EventDetailTableViewController.h
//  Check-In Host
//
//  Created by Kaelin D. Hooper on 4/21/15.
//  Copyright (c) 2015 CS378. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "Event.h"
#import "XLFormViewController.h"

@interface EventDetailTableViewController : XLFormViewController
@property (strong, nonatomic) Event *event;
@end
