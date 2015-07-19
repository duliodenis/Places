//
//  AppDelegate.m
//  Places
//
//  Created by Dulio Denis on 7/17/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

#import "AppDelegate.h"
#import "LocationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Responding to a location event
    if (launchOptions[UIApplicationLaunchOptionsLocationKey]) {
        LocationController *locationController = [LocationController sharedInstance];
        [locationController.locationManager startUpdatingLocation];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    LocationController *locationController = [LocationController sharedInstance];
    [locationController.locationManager stopUpdatingLocation];
}

@end
