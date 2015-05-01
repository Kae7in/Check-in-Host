//
//  MapViewController.m
//  Check-In Host
//
//  Created by Kaelin D. Hooper on 4/14/15.
//  Copyright (c) 2015 CS378. All rights reserved.
//

#import "MapViewController.h"
#import "PFFacebookUtils.h"
#import <Parse/Parse.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "EventDetailTableViewController.h"
#import "CheckinViewController.h"
#import "EventRepo.h"

@interface MapViewController () <GMSMapViewDelegate>
@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
#warning: Maybe change currentUserEvents to a hashmap, later.
//@property (strong, nonatomic) NSMutableArray *currentUserEvents;
@property (strong, nonatomic) EventRepo *eventRepo;
@property (strong, nonatomic) Event *eventToSegueWith;
@property CLLocationCoordinate2D coordinateToSegueWith;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    // Do any additional setup after loading the view.
    
    /* Load any events the current user has created */
    self.eventRepo = [[EventRepo alloc] init];
    [self.eventRepo loadCurrentUserEvents];
    
    self.eventToSegueWith = NULL;
    
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


- (void)viewWillAppear:(BOOL)animated {
    if (self.recentlyCreatedEvent && ![self.recentlyCreatedEvent.title isEqualToString:@""]) {
        NSLog(@"Marker Created");
        /* User created event */
            
        // Create marker on map for it
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = self.recentlyCreatedEvent.location.coordinate;
        marker.title = self.recentlyCreatedEvent.title;
        PFUser *currentUser = [PFUser currentUser];
        marker.snippet = currentUser[@"CHUserID"];
        marker.map = self.mapView;
        self.recentlyCreatedEvent.marker = marker;

        [self.eventRepo addCurrentUserEvent:self.recentlyCreatedEvent];
    }
    
    self.recentlyCreatedEvent = NULL;
}


//- (NSMutableArray *)currentUserEvents {
//    if (!_currentUserEvents) _currentUserEvents = [[NSMutableArray alloc] init];
//    return _currentUserEvents;
//}


- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate {
    Event *event = [[Event alloc] initEventWithTitle:@"" location:[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude] date:nil attendees:nil marker:nil];
    event.currentUserIsOwner = true;

    NSLog(@"Object in events array: %lu", self.eventRepo.countOfCurrentUserEvents);
    
    self.eventToSegueWith = event;
    [self performSegueWithIdentifier:@"toEventDetail" sender:self];
}


- (IBAction)returnToMap:(UIStoryboardSegue *) segue {

}


- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
#warning: Create custom Window to indicate that tapping it results in segueing to event detail view
    
    Event *e = [self.eventRepo eventForMarker:marker];
    self.eventToSegueWith = e;
    
    if (self.eventToSegueWith.currentUserIsOwner) {
        // This is my own event; segue to event detail for editing
        [self performSegueWithIdentifier:@"toEventDetail" sender:self];
    } else {
        // This is another user's event; segue to check-in view
        [self performSegueWithIdentifier:@"toCheckinView" sender:self];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toEventDetail"]) {
        EventDetailTableViewController *vc = (EventDetailTableViewController *)[segue destinationViewController];
        vc.event = self.eventToSegueWith;
    } else if ([segue.identifier isEqualToString:@"toCheckinView"]) {
        CheckinViewController *cvc = (CheckinViewController *)[segue destinationViewController];
        cvc.event = self.eventToSegueWith;
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
