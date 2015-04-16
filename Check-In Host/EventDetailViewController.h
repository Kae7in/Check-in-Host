//
//  EventDetailViewController.h
//  Check-In Host
//
//  Created by Kaelin D. Hooper on 4/16/15.
//  Copyright (c) 2015 CS378. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface EventDetailViewController : UIViewController
@property (strong, nonatomic) GMSMarker *marker;
@end
