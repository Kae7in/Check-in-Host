//
//  AuthViewController.m
//  Check-in Host
//
//  Created by Kaelin D. Hooper on 3/20/15.
//  Copyright (c) 2015 CS378. All rights reserved.
//

#import "AuthViewController.h"
#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <PFFacebookUtils.h>


#define PERMISSIONS @[@"public_profile", @"email"]


@interface AuthViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@end


@implementation AuthViewController //: UIViewController <CLLocationManagerDelegate>


- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // segue here
    
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"Already Logged In");

        PFUser *user = [PFUser currentUser];
        if (user && user[@"CHUserID"]) {
            // Go ahead and segue to next appropriate view controller
            [self performSegueWithIdentifier:@"segueToTabBar" sender:self];
        } else {
            [self performSegueWithIdentifier:@"segueToRegistration" sender:self];
        }
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"Already Logged In");
        [self.loginButton setTitle:@"Logout" forState:UIControlStateNormal];
    } else {
        [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    }
}


- (IBAction)returnToLogin:(UIStoryboardSegue *) segue {
    
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
             user[@"fbUserID"] = [result[@"id"] description];
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
