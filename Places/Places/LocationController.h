//
//  LocationController.h
//  Places
//
//  Created by Dulio Denis on 7/19/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationControllerDelegate
- (void)locationDidUpdateLocation:(CLLocation *)location;
@end

@interface LocationController : NSObject <CLLocationManagerDelegate>
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocation *location;
@property (nonatomic) id delegate;

/**
 Singleton Instance
 */
+ (LocationController *)sharedInstance;
- (void)addLocationCoordinatorDelegate:(id<LocationControllerDelegate>)delegate;

@end
