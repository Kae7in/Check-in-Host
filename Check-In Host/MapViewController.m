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
#import "EventDetailViewController.h"

@interface MapViewController () <GMSMapViewDelegate>
@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) GMSMarker *recentlyCreatedMarker;
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
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(currentCoordinate.latitude, currentCoordinate.longitude);
    marker.title = @"Your Location";
    marker.snippet = @"Place an event here?";
    marker.map = self.mapView;
}


- (void) mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate {
#warning: create default marker and pass to EventDetailViewController
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = coordinate;
    marker.title = @"Event Title";
    PFUser *currentUser = [PFUser currentUser];
    marker.snippet = currentUser[@"CHUserID"];
    marker.map = self.mapView;
    self.recentlyCreatedMarker = marker;
    [self performSegueWithIdentifier:@"toEventDetail" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toEventDetail"]) {
        EventDetailViewController *vc = (EventDetailViewController *)[segue destinationViewController];
        vc.marker = self.recentlyCreatedMarker;
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
