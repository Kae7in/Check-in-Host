//
//  AppDelegate.m
//  Check-In Host
//
//  Created by Kaelin D. Hooper on 4/2/15.
//  Copyright (c) 2015 CS378. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <Parse/Parse.h>
#import <GoogleMaps/GoogleMaps.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    NSLog(@"application didFinishLaunchingWithOptions called with options: %@", launchOptions);
    
    UIColor *color = [UIColor colorWithRed:0 green:.38 blue:.88 alpha:1.0];
    [[UINavigationBar appearance] setTranslucent:true];
    [[UINavigationBar appearance] setBarTintColor:color];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setTintColor:color];
    
//    self.navigationController.navigationBar.translucent = true;
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:.1 green:.38 blue:.88 alpha:1.0];
//    //    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:.18 green:.75 blue:.18 alpha:1.0];
//    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    [Parse setApplicationId:@"blMS2b3IdmiXQ4nF5783j6bsOjQSMkrGUM4jYLRg"
                  clientKey:@"QVB7nIyAQsyLp597iiId4lYIH4HCwWQYOaYQMDAF"];
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    [GMSServices provideAPIKey:@"AIzaSyC_CtC19Q_LoiBtMUBXjqDfEu_LadTmhjM"];
    return true;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
//    NSLog(@"openURL called with %@", url);
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
