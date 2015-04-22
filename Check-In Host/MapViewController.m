//
//  MapViewController.m
//  Check-In Host
//
//  Created by Kaelin D. Hooper on 4/14/15.
//  Copyright (c) 2015 CS378. All rights reserved.
//

#import "MapViewController.h"
#import "PFFacebookUtils.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "EventDetailTableViewController.h"
#import "Event.h"

@interface MapViewController () <GMSMapViewDelegate>
@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *events;
@property (strong, nonatomic) Event *eventToSegueWith;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    // Do any additional setup after loading the view.
    
    /* Get current location coordinates (latitude and longitude). */
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    
    CLLocation *currentLocation = [[CLLocation alloc] init];
    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
    if (authStatus == kCLAuthorizationStatusAuthorizedWhenInUse
        || authStatus == kCLAuthorizationStatusAuthorizedAlways) {
        NSLog(@"successfully authorized");
        currentLocation = self.locationManager.location;
    }
    CLLocationCoordinate2D currentCoordinate = {currentLocation.coordinate.latitude, currentLocation.coordinate.longitude};
    
    // Create a GMSCameraPosition that tells the map to display the
    // current location at zoom level 15.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:currentCoordinate zoom:15];
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.myLocationButton = true;
    [self.mapView setCamera:camera];
}


- (NSMutableArray *)events {
    if (!_events) _events = [[NSMutableArray alloc] init];
    return _events;
}


- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate {
#warning: create default marker and pass to EventDetailViewController
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = coordinate;
    marker.title = @"";
    PFUser *currentUser = [PFUser currentUser];
    marker.snippet = currentUser[@"CHUserID"];
    marker.map = self.mapView;
    
    Event *event = [[Event alloc] initEventWithTitle:@"" location:nil date:nil attendees:nil marker:marker];
    [self.events addObject:event];
    
    self.eventToSegueWith = event;
    [self performSegueWithIdentifier:@"toEventDetail" sender:self];
}


- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
#warning: Create custom Window to indicate that tapping it results in segueing to event detail view
    BOOL eventNotFound = true;
    for (Event *e in self.events) {
        if (marker == e.marker) {
            self.eventToSegueWith = e;
            eventNotFound = false;
        }
    }
    
    if (eventNotFound) {
        NSLog(@"Error: event for selected marker not found");
        return;
    }
    
    [self performSegueWithIdentifier:@"toEventDetail" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toEventDetail"]) {
        EventDetailTableViewController *vc = (EventDetailTableViewController *)[segue destinationViewController];
        vc.event = self.eventToSegueWith;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
