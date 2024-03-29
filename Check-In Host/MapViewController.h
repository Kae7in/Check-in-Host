//
//  MapViewController.h
//  Check-In Host
//
//  Created by Kaelin D. Hooper on 4/14/15.
//  Copyright (c) 2015 CS378. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface MapViewController : UIViewController
@property (nonatomic, strong) Event *createdEvent;
@property (nonatomic, strong) Event *editedEvent;
@end
