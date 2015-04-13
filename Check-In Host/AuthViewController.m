//
//  AuthViewController.m
//  Check-in Host
//
//  Created by Kaelin D. Hooper on 3/20/15.
//  Copyright (c) 2015 CS378. All rights reserved.
//

//#import <MapKit/MapKit.h>
#import "AuthViewController.h"
#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <PFFacebookUtils.h>


#define PERMISSIONS @[@"public_profile", @"email"]


@interface AuthViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end


@implementation AuthViewController //: UIViewController <CLLocationManagerDelegate>


- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    //    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    //    testObject[@"newKey2"] = @"newValue2";
    //    [testObject saveInBackground];
    
//    self.locationManager = [[CLLocationManager alloc] init];
//    [self.locationManager requestWhenInUseAuthorization];
//
//    CLLocation *currentLocation = [[CLLocation alloc] init];
//    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
//    if (authStatus == kCLAuthorizationStatusAuthorizedWhenInUse
//        || authStatus == kCLAuthorizationStatusAuthorizedAlways) {
//        NSLog(@"successfully authorized");
//        currentLocation = self.locationManager.location;
//    }
//    
//    NSLog(@"location.latitude: %f", currentLocation.coordinate.latitude);
//    NSLog(@"location.longitude: %f", currentLocation.coordinate.longitude);
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // segue here
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"Already Logged In");
        [self.loginButton setTitle:@"Logout" forState:UIControlStateNormal];
        // Go ahead and segue to next appropriate view controller
        [self performSegueWithIdentifier:@"segueToTabBar" sender:self];
    } else {
        [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
        // Stay in AuthViewController to let the user login
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}


- (IBAction)loginButtonTouched:(UIButton *)sender {
    if ([FBSDKAccessToken currentAccessToken]) {
        [PFUser logOut];
        [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    } else {
        [PFFacebookUtils logInInBackgroundWithReadPermissions:PERMISSIONS block:^(PFUser *user, NSError *error) {
                    if (!user) {
                        NSLog(@"Uh oh. The user cancelled the Facebook login.");
                    } else if (user.isNew) {
                        NSLog(@"User signed up and logged in through Facebook!");
                        [self submitUserIDAsColumnEntryIntoUserClass];
                        // segue to username viewcontroller
                        [self performSegueWithIdentifier:@"segueToRegistration" sender:self];
                    } else {
                        NSLog(@"User logged in through Facebook!");
                        [self performSegueWithIdentifier:@"segueToTabBar" sender:self];
                    }
                }];
        [self.loginButton setTitle:@"Logout" forState:UIControlStateNormal];
    }
}


- (void)submitUserIDAsColumnEntryIntoUserClass {
    PFUser *user = [PFUser currentUser];
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             NSLog(@"fetched user:%@", result);
             user[@"userID"] = [result[@"id"] description];
             [user saveInBackground];
         }
     }];
}


//- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
//    if (status == kCLAuthorizationStatusDenied) {
//        // permission denied
//    } else if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
//        // permission granted
//    }
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
